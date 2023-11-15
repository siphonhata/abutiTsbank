defmodule TsbankWeb.Auth.Guardian do
  use Guardian, otp_app: :tsbank
  alias Tsbank.Users
  alias Tsbank.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, pass) do
    case Users.get_user_by_email(email) do
      nil -> {:error, :unauthorized}
      user ->
        #Map.put(user, "lastLoginDate", DateTime.utc_now)
        case validate_password(pass, user.password) do
          true -> create_token(user, :access)
          false -> {:error, :unauthorized}
        end
    end
  end

  defp validate_password(pass, password) do
    Bcrypt.verify_pass(pass, password)
  end

  defp create_token(user, type) do
    {:ok, token, _claims} = encode_and_sign(user, %{}, token_options(type))
    {:ok, user, token}
  end

  defp token_options(type) do
    case type do

      #:admin -> [token_type: "admin", ttl: {90, :day}]
      #:reset -> [token_type: "reset", ttl: {15, :minute}]
      :access -> [token_type: "access", ttl: {2, :hour}]

    end
  end

  def get_me_id(id) do
    case Users.get_full_user(id) do
      nil -> {:error, :unauthorized}
      customer -> customer.id
    end
  end

  def get_that_account_name(id) do
    case Accounts.get_account_name(id) do
      nil -> {:error, :unauthorized} # this works for the error response plug ehrn using it by other side
      account -> account.accountNumber
    end
  end

  def get_me_account_id(id) do
    case Accounts.get_full_account_id(id) do
      nil -> {:error, :unauthorized} # this works for the error response plug ehrn using it by other side
      account -> account.id
    end
  end
end
