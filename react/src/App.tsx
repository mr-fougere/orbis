import './App.css'
import { PlayerRegisterForm } from './player/RegisterForm'
import { useAuthPlayer } from './components/AuthProvider'
import { PlayerSummary } from './player/Summary'

function App() {

  const { isLogged} = useAuthPlayer()
  return (
    <>
      <h1>Orbis</h1>
      {isLogged ?<PlayerSummary/> :  <PlayerRegisterForm/>}
     
    </>
  )
}

export default App
