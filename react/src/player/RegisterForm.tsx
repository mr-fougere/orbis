import { useForm, type SubmitHandler } from "react-hook-form"
import { useAuthPlayer, type Player } from "../components/AuthProvider"

type Inputs = Pick<Player,'username'>



export const PlayerRegisterForm = () => {

    const { register: registerPlayer } = useAuthPlayer()

    const {
        register,
        handleSubmit,
        formState: { errors },
    } = useForm<Inputs>()

    const onSubmit: SubmitHandler<Inputs> = (data) => {
        registerPlayer(data.username)
    }

    return (
    /* "handleSubmit" will validate your inputs before invoking "onSubmit" */
    <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4">

      <input {...register('username', { required: true })} />
      {errors.username && <span className="text-red">This field is required</span>}

      <button type="submit"> Démarrer</button>
    </form>
  )

}