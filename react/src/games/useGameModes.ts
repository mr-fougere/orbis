import { useMemo } from "react"
import { useGameModesQuery } from "../lib/queries/get-game-modes.query"


export const useGameModes = () => {

    const { data } = useGameModesQuery()


    const gameModes = useMemo(()=>  data?.game_modes, [data])

    return {
        gameModes
    }
}