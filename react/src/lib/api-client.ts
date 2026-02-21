import axios from "axios"

export const AxiosApiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  
})
