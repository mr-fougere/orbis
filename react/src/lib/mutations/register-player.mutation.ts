import {
  useMutation,
  type UseMutationOptions,
} from "@tanstack/react-query"
import { AxiosApiClient } from "../api-client"

type RegisterPlayerResponse = {
    token: string
    username: string
}

type RegisterPlayerOptions = UseMutationOptions<
    RegisterPlayerResponse,
    unknown,
    string 
  >

export const useRegisterPlayerMutation = (
  options?: RegisterPlayerOptions
) => {
  return useMutation<
    RegisterPlayerResponse,
    unknown,
    string
  >({
    mutationKey: ["player", "register"],
    mutationFn: async (username: string) => {
      const response = await AxiosApiClient.post<RegisterPlayerResponse>(
        "/register",
        {
          player: { username },
        },
        { headers: {
          'Content-Type': 'application/json'
        }}
      )

      return response.data
    },
    ...options,
  })
}
