import { redirect, type LoaderFunctionArgs } from "react-router"
import { createBrowserRouter } from "react-router"
import { RootLayout } from "./RootLayout"
import { GameLayout } from "./GameLayout"
import { Game } from "./Game"
import { Home } from "./Home"

export const gameCodeLoader = async ({ params }: LoaderFunctionArgs) => {
  const code = params.code

  if (code) {
    // 🔹 sessionStorage standard (pas de hook)
    sessionStorage.setItem("game_code",JSON.stringify(code) )
  }

  // Redirige vers /game sans le code dans l'URL
  return redirect("/game")
}

export const router = createBrowserRouter([
  {
    path: "/",
    Component: RootLayout,
    children: [
      { index: true, Component: Home },

      {
        path: "game/:code",
        loader: gameCodeLoader,
      },

      {
        path: "game",
        Component: GameLayout,
        children: [
          { index: true, Component: Game },
        ],
      },
    ],
  },
])