import {
  useQuery,
  type UseQueryOptions,
} from "@tanstack/react-query"
import { AxiosApiClient } from "../api-client"

type GameModesResponse = {
    game_modes: string[]
}

type GameModesOptions = UseQueryOptions<
    GameModesResponse
  >

export const useGameModesQuery = (
  options?: GameModesOptions
) => {
  return useQuery<
    GameModesResponse
  >({
    queryKey: ["game-modes"],
    queryFn: async () => {
      const response = await AxiosApiClient.get<GameModesResponse>(
        "/game_modes",
        { headers: {
          'Content-Type': 'application/json'
        }}
      )

      return response.data
    },
    ...options,
  })
}
