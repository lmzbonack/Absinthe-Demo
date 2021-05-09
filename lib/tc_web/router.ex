defmodule TcWeb.Router do
  use TcWeb, :router

  pipeline :api do
    plug TcWeb.Context
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TcWeb.Schema,
      interface: :advanced,
      context: %{pubsub: TcWeb.Endpoint}

    forward "/", Absinthe.Plug, schema: TcWeb.Schema
  end
end
