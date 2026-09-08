#!/bin/sh
set -e

cd /app

# Verifica alterações em package.json ou package-lock.json para gerenciar dependências no volume
LOCK_HASH=$(cat package.json package-lock.json 2>/dev/null | md5sum | cut -d' ' -f1)
STORED_HASH=$(cat node_modules/.ready 2>/dev/null || true)

if [ ! -d node_modules ] || [ "$LOCK_HASH" != "$STORED_HASH" ]; then
  echo ">> Instalando dependências..."
  mkdir -p node_modules
  npm install --no-audit --no-fund --cache /tmp/.npm --legacy-peer-deps
  echo "$LOCK_HASH" > node_modules/.ready
  echo ">> Dependências instaladas com sucesso."
fi

# Garante que o Prisma Client está gerado e sincronizado apenas se o Prisma existir no projeto
if [ -f "prisma/schema.prisma" ]; then
  if [ ! -d "node_modules/.prisma" ] || [ ! -d "node_modules/@prisma/client" ]; then
    echo ">> Gerando Prisma Client..."
    npx prisma generate
    echo ">> Prisma Client gerado."
  fi
fi

# Se argumentos foram passados no comando do container, executa-os; caso contrário, roda o Next.js dev
if [ $# -gt 0 ]; then
  exec "$@"
else
  # Força Webpack para compatibilidade com polling no Docker/Windows
  exec npx next dev --webpack -H 0.0.0.0 -p 3000
fi
