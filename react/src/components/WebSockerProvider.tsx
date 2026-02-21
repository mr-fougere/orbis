import {
  createContext,
  useContext,
  useEffect,
  useRef,
  useState,
  type PropsWithChildren,
} from "react"
import { useAuthPlayer } from "./AuthProvider"


type WebSocketContextType = {
  socket: WebSocket | null
  send: (data: any) => void
  isConnected: boolean
}

const WebSocketContext = createContext<WebSocketContextType | null>(null)

export const WebSocketProvider = ({ children }: PropsWithChildren) => {
  const { player } = useAuthPlayer()
  const socketRef = useRef<WebSocket | null>(null)
  const [isConnected, setIsConnected] = useState(false)

  useEffect(() => {
    const socket = new WebSocket(
      `${import.meta.env.VITE_WEBSOCKET_URL}?token=${player?.token}`
    )

    socketRef.current = socket

    socket.onopen = () => {
      console.log("✅ WebSocket connected")
      setIsConnected(true)
    }

    socket.onclose = () => {
      console.log("❌ WebSocket disconnected")
      setIsConnected(false)
    }

    socket.onerror = (err) => {
      console.error("WebSocket error", err)
    }

    return () => {
      socket.close()
    }
  }, [])

  const send = (data: any) => {
    if (!socketRef.current) return
    socketRef.current.send(JSON.stringify(data))
  }

  return (
    <WebSocketContext.Provider
      value={{
        socket: socketRef.current,
        send,
        isConnected,
      }}
    >
      {children}
    </WebSocketContext.Provider>
  )
}

export const useWebSocket = () => {
  const context = useContext(WebSocketContext)
  if (!context) throw new Error("useWebSocket must be used inside provider")
  return context
}