import {
  createContext,
  useContext,
  useEffect,
  useRef,
  useState,
  type PropsWithChildren,
} from "react"
import { useWebSocket } from "./WebSockerProvider" // ton hook WebSocket natif

const Side = { RECTO: 'recto', VERSO: 'verso' } as const

type Disk = { x: number; y: number; side: typeof Side[keyof typeof Side] }

type BoardState = {
  board: Disk[]
  current_turn: string
  last_disk: Disk
  flipped_disks: Disk[]
  possible_positions: Disk[]
}

const GameChannelEventType = { game_state: 'game_state' } as const

type GameChannelEvent = { event: keyof typeof GameChannelEventType; data: BoardState }

type GameWebSocketContextType = {
  getGameState: () => void
  disconnectGameChannel: () => void
  putsDisk: (disk: Disk) => void
  isConnectedGameChannel: boolean
}

const GameWebSocketContext = createContext<GameWebSocketContextType | null>(null)

type GameWebSocketProviderProps = PropsWithChildren & { gameCode: string | null }

export const GameWebSocketProvider = ({ children, gameCode }: GameWebSocketProviderProps) => {
  const { send, socket } = useWebSocket()
  const [isConnectedGameChannel, setIsConnectedGameChannel] = useState(false)
  const subscriptionRef = useRef<{ identifier: string } | null>(null)
  const [boardState, setBoardState] = useState<BoardState | null>(null)

  console.log(boardState);
  

  useEffect(() => {
    if (!socket || !gameCode) return

    connectGameChannel()

    socket.onmessage = (ev: MessageEvent) => {
      try {
        const message = JSON.parse(ev.data) as { type: string; identifier?: string; message?: any }

        // ⚡ Gère confirm_subscription
        if (message.type === "confirm_subscription" && message.identifier === subscriptionRef.current?.identifier) {
          console.log("Subscription confirmée ✅")
          setIsConnectedGameChannel(true)
          return
        }

        // Ignore les ping / welcome etc.
        if (!message.message) return

        // Vérifie que le message concerne notre channel
        if (message.identifier && message.identifier === subscriptionRef.current?.identifier) {
          const data: GameChannelEvent = message.message
          if (!data) return

          switch (data.event) {
            case GameChannelEventType.game_state:
              setBoardState(data.data)
              break
            default:
              break
          }
        }
      } catch (e) {
        console.warn("Message non JSON ou inattendu", ev.data)
      }
    }

    return () => {
      disconnectGameChannel()
    }
  }, [socket, gameCode])

  const connectGameChannel = () => {
    if (!socket || !gameCode) return

    const identifierObj = { channel: "GameChannel", token: gameCode }
    const identifier = JSON.stringify(identifierObj)
    subscriptionRef.current = { identifier }
    send({ command: "subscribe", identifier })
  }

  const disconnectGameChannel = () => {
    if (!socket || !subscriptionRef.current) return

    send({ command: "unsubscribe", identifier: subscriptionRef.current.identifier })
    subscriptionRef.current = null
    setIsConnectedGameChannel(false)
  }

  const getGameState = () => {
    if (!socket || !subscriptionRef.current || !isConnectedGameChannel) return
    console.log('ici');
    
    send({
      command: "message",
      identifier: subscriptionRef.current.identifier,
      data: JSON.stringify({ action: "get_game_state" })
    })
  }

  const putsDisk = (disk: Disk) => {
    if (!socket || !subscriptionRef.current || !isConnectedGameChannel) return
    send({
      command: "message",
      identifier: subscriptionRef.current.identifier,
      data: JSON.stringify({ action: "puts_disk", disk })
    })
  }

  useEffect(() => {
    
    if(!boardState && isConnectedGameChannel){
      getGameState()
    }
  
  }, [isConnectedGameChannel])
  

  return (
    <GameWebSocketContext.Provider
      value={{ getGameState, disconnectGameChannel, putsDisk, isConnectedGameChannel }}
    >
      {children}
    </GameWebSocketContext.Provider>
  )
}

export const useGameWebSocket = () => {
  const context = useContext(GameWebSocketContext)
  if (!context) throw new Error("useGameWebSocket must be used inside provider")
  return context
}