// Estes são exportados como "default", então aqui, podemos
// importar sem as chaves {}, e com qualquer nome
// Importando desta maneira, devido a exportação no arquivo index.ts
// Agora tem que ser o mesmo nome que foi exportado
import { Footer, Header } from "./components";

// Function "expression"
// Atribui uma função anônima a uma variável
// const Home = function () {

// Function "Declaration"
export default function Home() {
  return (
    <>
      <Header />
      <main className="flex-1">This is the main</main>
      <Footer />
    </>
  );
}
