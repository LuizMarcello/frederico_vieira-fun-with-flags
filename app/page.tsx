// Estes são exportados como "default", então aqui, podemos
// importar sem as chaves {}, e com qualquer nome
// Importando desta maneira, devido a exportação no arquivo index.ts
// Agora tem que ser o mesmo nome que foi exportado
import { Footer, Header, Carddd, Grid } from "./components";

const countries = [
  {
    id: 1,
    country: "Brazil",
    capital: "Brasília",
    region: "South America",
    population: "212583750",
  },
  {
    id: 2,
    country: "Japan",
    capital: "Tokyo",
    region: "Asia",
    population: "123103479",
  },
  {
    id: 3,
    country: "United States",
    capital: "Washington, D.C.",
    region: "North America",
    population: "347275807",
  },
  {
    id: 4,
    country: "Germany",
    capital: "Berlin",
    region: "Europe",
    population: "84075075",
  },
  {
    id: 5,
    country: "France",
    capital: "Paris",
    region: "Europe",
    population: "66650804",
  },
  {
    id: 6,
    country: "Australia",
    capital: "Canberra",
    region: "Oceania",
    population: "26974147",
  },
  {
    id: 7,
    country: "Canada",
    capital: "Ottawa",
    region: "North America",
    population: "40126723",
  },
  {
    id: 8,
    country: "India",
    capital: "New Delhi",
    region: "Asia",
    population: "1476625576",
  },
];

// Function "expression"
// Atribui uma função anônima a uma variável
// const Home = function () {

// Function "Declaration"
export default function Home() {
  return (
    <>
      <Header />
      <main className="flex-1">
        <Grid>
          {/* No JSX, estas chaves { ... } indicam: "saia do HTML e
         execute código JavaScript aqui dentro". */}
          {/* Iterando através do .map */}
          {/* Para cada iteração(cada país) é retornado o componente <Carddd/> */}
          {/* assim: */}
          {/* {countries.map((country) => ( */}
          {/* ou assim: */}
          {countries.map(({ id, country, capital, region, population }) => (
            <Carddd
              // key={country.id}
              // country={country.country}
              // capital={country.capital}
              // region={country.region}
              // population={country.population}
              key={id}
              country={country}
              capital={capital}
              region={region}
              population={population}
            />
          ))}
        </Grid>

        {/* <Grid>
          <span>Elemento 1</span>
          <span>Elemento 2</span>
          <span>Elemento 3</span>
          <span>Elemento 4</span>
        </Grid> */}
      </main>
      <Footer />
    </>
  );
}
