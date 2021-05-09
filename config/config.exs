# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tc,
  ecto_repos: [Tc.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :tc, TcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WjtY1cIs/zTtwYjcMj1bYD9xKHWE3dRjmiHr0Jcp7hPG0mitVxf0HMSo8yXYWDu3",
  render_errors: [view: TcWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Tc.PubSub,
  live_view: [signing_salt: "FopBOhgZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian Config
config :tc, Tc.Guardian,
  issuer: "tc",
  secret_key: "3TrEVHPaCT1PIToFKDBh4Lh4jLwwM75BjpwjueKQw66CtaHVhpqC0pS0U9gmpk5Z",
  allowed_drift: 2000,
  ttl: {60, :minutes}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
