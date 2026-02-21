import './App.css'
import { PlayerRegisterForm } from './player/RegisterForm'
import { useAuthPlayer } from './components/AuthProvider'
import { CreateGameForm } from './games/CreateGameForm'

export function Home() {
  const { isLogged} = useAuthPlayer()
  return (
    <>
      <h1>Orbis</h1>
      {isLogged ?<CreateGameForm/> :  <PlayerRegisterForm/>}
     
    </>
  )
}

