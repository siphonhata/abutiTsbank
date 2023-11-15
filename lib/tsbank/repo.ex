defmodule Tsbank.Repo do
  use Ecto.Repo,
    otp_app: :tsbank,
    adapter: Ecto.Adapters.Postgres
end
