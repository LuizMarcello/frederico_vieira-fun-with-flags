import { HeartIcon } from "@heroicons/react/24/solid";

// Nos componentes: Arrow function
const Footer = () => {
  return (
    <footer className="py-6 mb-8">
      <p className="flex items-center justify-center">
        Made with <HeartIcon className="size-4 mx-1 text-red-500" /> by Luiz
        Marcello
      </p>
    </footer>
  );
};

export default Footer;
