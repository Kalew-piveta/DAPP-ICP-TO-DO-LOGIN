import { useState } from "react";
import { createActor, to_do_backend } from "declarations/to_do_backend";
import { AuthClient } from "@dfinity/auth-client";
import { HttpAgent } from "@dfinity/agent";
import { BrowserRouter as Router, Route, Routes, useNavigate } from "react-router-dom";
import Index from "./index";
import Tarefas from "./tarefas";

let actorLoginBackend = to_do_backend;

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  async function login() {
    try {
      let authClient = await AuthClient.create();

      await authClient.login({
        identityProvider: "https://identity.ic0.app/#authorize",
        onSuccess: async () => {
          const identity = authClient.getIdentity();
          console.log("Usuário autenticado:", identity.getPrincipal().toText());

          const agent = new HttpAgent({ identity });

          actorLoginBackend = createActor(({}).CANISTER_ID_LOGIN_BACKEND, {
            agent,
          });

          const principalText = await actorLoginBackend.get_principal_client();
          setIsLoggedIn(true);

          document.getElementById("principalText").innerText = principalText;

           
        },
        
        windowOpenerFeatures: "left=100,top=100,toolbar=0,location=0,menubar=0,width=525,height=705",
      });
      // Redireciona para tarefas após login bem-sucedido
      navigate("/tarefas")
    } catch (error) {
      console.error("Erro no login:", error);
    }
  }

  async function logout() {
    const authClient = await AuthClient.create();
    await authClient.logout();
    document.getElementById("principalText").innerText = "";
    setIsLoggedIn(false);
  }

  return (
    <Router>
      <Routes>
        <Route path="/" element={<Index login={login} />} />
        <Route path="/tarefas" element={<Tarefas />} />
      </Routes>
    </Router>
  );
}

export default App;
