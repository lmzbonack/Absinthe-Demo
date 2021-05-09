defmodule TcWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Tc.{Guardian, Accounts}

  def init(opts), do: opts

  # Carry the context that holds our current user through to each request
  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claim} <- Guardian.decode_and_verify(token),
         user when not is_nil(user) <- Accounts.get_user!(claim["sub"]) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
