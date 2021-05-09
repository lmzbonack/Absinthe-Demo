# Tc

To start your Phoenix server:

  * Ensure you have Postgres running locally
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Graphiql explorer is available at `localhost:4000/graphiql`

## Overview

For this project I used [Absinthe](https://github.com/absinthe-graphql/absinthe), which is a popular GraphQL implementation for Elixir on top of [Phoenix](https://www.phoenixframework.org/), which I am sure that you have heard about.

I have previous experience with this stack so I was able to prototype together something pretty quickly. I backed the API with Postgres and secured it with JWT via a library called [Guardian](https://github.com/ueberauth/guardian).
