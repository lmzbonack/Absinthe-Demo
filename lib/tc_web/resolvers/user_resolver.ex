defmodule TcWeb.Resolvers.UserResolver do
  alias Tc.{Accounts, Guardian}

  def current_user(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def current_user(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  def signup(_parent, args, _resolution) do
    args
    |> Accounts.create_user()
    |> case do
      {:ok, user} ->
        {:ok,
         user
         |> add_auth_token()
         |> add_refresh_token()}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  def authenticate(_parent, args, _resolution) do
    error = {:error, [[field: :email, message: "Invalid email or password"]]}

    case Accounts.get_user_by_email(String.downcase(args[:email])) do
      nil ->
        error

      user ->
        case Bcrypt.check_pass(user, args[:password]) do
          {:error, _} ->
            error

          {:ok, user} ->
            {:ok,
             user
             |> add_auth_token()
             |> add_refresh_token()}
        end
    end
  end

  @spec refresh(any, atom | %{:refresh_token => binary, optional(any) => any}, any) :: any
  def refresh(_parent, args, _resolution) do
    case Guardian.decode_and_verify(args.refresh_token) do
      {:ok, decoded} -> validate_refresh_token_and_create_new_token(decoded)
      {:error, _} -> {:error, "Error decoding refresh token"}
    end
  end

  defp add_auth_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    Map.put(user, :token, token)
  end

  defp add_refresh_token(user) do
    {:ok, refresh_token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {4, :weeks})

    Map.put(user, :refresh_token, refresh_token)
  end

  defp validate_refresh_token_and_create_new_token(%{"typ" => "refresh", "sub" => sub}) do
    user = Accounts.get_user!(sub)
    {:ok, add_auth_token(user)}
  end

  defp validate_refresh_token_and_create_new_token(_claim) do
    {:error, "That is not a refresh token"}
  end

  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
