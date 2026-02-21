import './App.css'
import { useGameWebSocket } from './components/GameWebSockerProvider'
import { useWebSocket } from './components/WebSockerProvider'
import { PlayerSummary } from './player/Summary'

export function Game() {
  const {  isConnected} = useWebSocket()
  const { disconnectGameChannel } = useGameWebSocket()
  return (
    <>
      {isConnected && <PlayerSummary/>}

      <button onClick={disconnectGameChannel} className='bg-red-500'> Disconnect</button>
     
    </>
  )
}

