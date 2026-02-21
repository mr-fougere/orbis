import {
  useMutation,
  type UseMutationOptions,
} from "@tanstack/react-query"
import { AxiosApiClient } from "../api-client"
import { useAuthPlayer } from "../../components/AuthProvider"

type CreatedGamedResponse = {
    code: string
}

type GameConfiguration = {
  game_mode: string
}

type CreateGameOptions = UseMutationOptions<
    CreatedGamedResponse,
    unknown,
    GameConfiguration 
  >

export const useCreateGameMutation = (
  options?: CreateGameOptions
) => {

  const { player} = useAuthPlayer()

  return useMutation<
    CreatedGamedResponse,
    unknown,
    GameConfiguration
  >({
    mutationKey: ["game"],
    mutationFn: async (game_configuration: GameConfiguration) => {
      const response = await AxiosApiClient.post<CreatedGamedResponse>(
        "/games",
        {
          game_configuration,
        },
        { headers: {
          'Content-Type': 'application/json',
          'Authorization': player?.token
        }}
      )

      return response.data
    },
    ...options,
  })
}
