import { useAuthPlayer } from "../components/AuthProvider"

export const PlayerSummary = () => {

    const { player} = useAuthPlayer()

    return <div>
        <div>Username:  {player?.username}</div>
       <div>Token:    {player?.token}</div>
      
    </div>
}