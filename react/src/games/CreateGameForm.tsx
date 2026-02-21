import { useForm, type SubmitHandler } from "react-hook-form"
import { useGameModes } from "./useGameModes"
import { useCreateGameMutation } from "../lib/mutations/create-game.mutation"
import { redirect, useNavigate } from "react-router"

type Inputs = {
  gameConfiguration: {
    game_mode: string
  }
}

export const CreateGameForm = () => {
  const { mutateAsync: createGameAsync, isPending} = useCreateGameMutation()
  const { gameModes } = useGameModes()
  const navigate = useNavigate()

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<Inputs>()

  const onSubmit: SubmitHandler<Inputs> = async (data) => {
    const response = await createGameAsync(data.gameConfiguration)

    console.log(response.code);
    
    navigate(`/game/${response.code}`)    
  }


  return (
    <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4">

      {/* Game Mode Select */}
      <div className="flex flex-col">
        <select
          {...register("gameConfiguration.game_mode", { required: true })}
          className="border p-2 rounded"
        >
          <option value="">Choisir un mode de jeu</option>

          {gameModes?.map((mode: string) => (
            <option key={mode} value={mode}>
              {mode.replaceAll("_", " ")}
            </option>
          ))}
        </select>

        {errors.gameConfiguration?.game_mode && (
          <span className="text-red-500">
            Veuillez sélectionner un mode
          </span>
        )}
      </div>

      <button
        type="submit"
        className="bg-black text-white p-2 rounded"
      >
        Démarrer
      </button>
    </form>
  )
}