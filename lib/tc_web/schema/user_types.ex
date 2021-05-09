defmodule TcWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias TcWeb.Data
  alias TcWeb.Resolvers.UserResolver

  @desc "user object"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :token, non_null(:string)
    field :refresh_token, non_null(:string)

    field :books, non_null(list_of(non_null(:book))), resolve: dataloader(Data)
  end

  object :user_queries do
    @desc "Get current user"
    field :current_user, non_null(:user) do
      resolve &UserResolver.current_user/3
    end
  end

  object :user_mutations do
    @desc "Authenticate"
    field :authenticate, :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &UserResolver.authenticate/3
    end

    @desc "Refresh Session"
    field :refresh, :user do
      arg(:refresh_token, non_null(:string))

      resolve &UserResolver.refresh/3
    end

    @desc "Sign up"
    field :sign_up, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &UserResolver.signup/3
    end
  end
end
