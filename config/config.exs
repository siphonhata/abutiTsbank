# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.


# General application configuration
import Config
config :tsbank,
  ecto_repos: [Tsbank.Repo],
  generators: [binary_id: true]

config :prom_ex, custom_metrics: [:custom_metric]


config :tsbank, Tsbank.PromEx,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: [
    host: System.get_env("GRAFANA_HOST", "http://localhost:3000"),
    auth_token: "glsa_SvnOYpkxMB4oGVu7Kki7cmdHUzKfiGX5_8537da90",
    upload_dashboard_on_start: true,
    folder_name: "tracer_dashboard",
    annotate_app_lifecycle: true
  ]

# Configures the endpoint
config :tsbank, TsbankWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: TsbankWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Tsbank.PubSub,
  live_view: [signing_salt: "R4SEKDMa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :tsbank, TsbankWeb.Auth.Guardian,
    issuer: "tsbank",
    secret_key: "pSmdmGNIUq8tG+Xo8vqrtemJQxtQBepMiiPHfMdnbwjpwIiPsYTXWLFBj9F2ta/1"
# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
