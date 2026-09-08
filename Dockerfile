# syntax=docker/dockerfile:1

# ------------------------------------------------------------------------------
# 1. Base Stage: Sistema e Dependências de Runtime
# ------------------------------------------------------------------------------
FROM node:20-bookworm-slim AS base

WORKDIR /app

ENV NEXT_TELEMETRY_DISABLED=1 \
    NODE_ENV=production

# Instalação de certificados, OpenSSL (necessário para Prisma) e curl (para healthcheck)
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends openssl ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# 2. Dependencies Stage: Cache de Instalação e Geração do Prisma
# ------------------------------------------------------------------------------
FROM base AS deps

WORKDIR /app

ENV NODE_ENV=development

# Copia apenas manifestos para otimização de cache de camadas
COPY package.json package-lock.json ./

# Instalação limpa e determinística com montagem de cache
RUN --mount=type=cache,target=/root/.npm \
    npm ci --legacy-peer-deps

# ------------------------------------------------------------------------------
# 3. Builder Stage: Compilação do Next.js (Standalone)
# ------------------------------------------------------------------------------
FROM base AS builder

WORKDIR /app

ENV NODE_ENV=production \
    BETTER_AUTH_SECRET="build_time_dummy_secret_for_compilation_min_32_chars" \
    BETTER_AUTH_URL="http://localhost:3000" \
    POLAR_WEBHOOK_SECRET="build_time_dummy_webhook_secret"

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Compilação da aplicação para produção em modo standalone
RUN npm run build

# ------------------------------------------------------------------------------
# 4. Runner Stage: Imagem de Produção Hardened & Non-Root
# ------------------------------------------------------------------------------
FROM base AS runner

WORKDIR /app

ENV PORT=3000 \
    HOSTNAME="0.0.0.0"

# Criação de usuário e grupo não-root dedicados para segurança
RUN groupadd --system --gid 1001 nodejs \
  && useradd --system --uid 1001 nextjs

# Cópia seletiva dos artefatos standalone e estáticos
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3000/api/health').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))" || exit 1

CMD ["node", "server.js"]

# ------------------------------------------------------------------------------
# 5. Development Stage: Utilizado pelo Docker Compose Local
# ------------------------------------------------------------------------------
FROM base AS development

WORKDIR /app

ENV NODE_ENV=development

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh \
  && chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3000/api/health').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))" || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
