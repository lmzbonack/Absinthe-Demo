defmodule Tc.Guardian do
  use Guardian, otp_app: :tc

  alias Tc.Accounts

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    {:ok, Accounts.get_user!(claims["sub"])}
  end
end
