defmodule TsbankWeb.UserJSON do
  alias Tsbank.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      password: user.password,
      isActive: user.isActive,
      lastLoginDate: user.lastLoginDate
    }
  end

  def showDataCustomer(%{user: user, customer: customer, token: token}) do
    %{
      user_id: user.id,
      email: user.email,
      customer_id: customer.id,
      token: token
    }
  end

  def showDataAdmin(%{user: user, admin: admin, token: token}) do
    %{
      id: user.id,
      email: user.email,
      admin_id: admin.id,
      token: token
    }
  end

  def showDataLogin(%{user: user, token: token}) do
    %{
      id: user.id,
      email: user.email,
      token: token
    }
  end

  def showAdminData(%{user: user, token: token}) do
    %{
      id: user.id,
      email: user.email,
      token: token
    }
  end

end
