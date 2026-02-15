import { createContext, useContext, useMemo, type PropsWithChildren } from "react";
import { useRegisterPlayerMutation } from "../lib/mutations/register-player.mutation";
import { useLocalStorage } from "@uidotdev/usehooks";
import { LocalStorageKey } from "../constant";


export type Player = {
  username: string;
  token: string
}

type AuthPlayerContextType = {
  player: Player | null
  isLogged: boolean
  register: (username: string) => void
  logout: () => void
}


export const AuthPlayerContext= createContext<AuthPlayerContextType | null>(null)


export const useAuthPlayer = () => {
  const context = useContext(AuthPlayerContext)
  if (!context) {
    throw new Error("useAuth must be used inside AuthProvider")
  }
  return context
}

export const AuthProvider = ({children}:PropsWithChildren) => {

  const [ player, setPlayer ] = useLocalStorage<Player| null>(LocalStorageKey.Player)
  
  const { mutateAsync} = useRegisterPlayerMutation({
    onSuccess: (data) => { 
        setPlayer(data)
    }
  })

  const register = (username: string) => {
    mutateAsync(username)
  }

  const logout = () => {
    setPlayer(null)
  }

  const isLogged = useMemo(() => !!player?.token && !!player.username, [player])

  return (
    <AuthPlayerContext.Provider value={{ player, register, logout,isLogged }}>
      {children}
    </AuthPlayerContext.Provider>
  )
}
