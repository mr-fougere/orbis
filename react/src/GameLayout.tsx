import { Outlet, useNavigate } from "react-router"
import { GameWebSocketProvider } from "./components/GameWebSockerProvider"
import { useSessionStorage } from "@uidotdev/usehooks"
import { WebSocketProvider } from "./components/WebSockerProvider"
import { useEffect } from "react"

export const GameLayout = () => {
  const navigate = useNavigate()
  const [gameCode] = useSessionStorage<string | null>("game_code", null)

  useEffect(() => {
    if (!gameCode) {
      navigate("/home")
    }
  }, [gameCode, navigate])

  if (!gameCode) return null // on attend la redirection

  return (
    <WebSocketProvider>
      <GameWebSocketProvider gameCode={gameCode}>
        <Outlet />
      </GameWebSocketProvider>
    </WebSocketProvider>
  )
}