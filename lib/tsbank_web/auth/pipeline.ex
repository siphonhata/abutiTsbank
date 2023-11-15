defmodule TsbankWeb.Auth.Pipeline do
    use Guardian.Plug.Pipeline, otp_app: :tsbank,
    module: TsbankWeb.Auth.Guardian,
    error_handler: TsbankWeb.Auth.GuardianErrorHandler

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
end
