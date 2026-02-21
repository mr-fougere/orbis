import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import { AuthProvider } from "./components/AuthProvider"
import { Outlet } from "react-router"

    const queryClient = new QueryClient()


export const RootLayout  = () =>   {

    return <QueryClientProvider client={queryClient}>
    <AuthProvider>
       <Outlet />
    </AuthProvider>
  </QueryClientProvider>
  
}