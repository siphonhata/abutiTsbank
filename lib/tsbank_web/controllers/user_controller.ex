defmodule TsbankWeb.UserController do
  use TsbankWeb, :controller
 require Logger
  alias TsbankWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias Tsbank.{Users, Admins, Admins.Admin, Users.User, Customers, Customers.Customer}
  alias CounterServer

  action_fallback TsbankWeb.FallbackController


  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do

    start = System.monotonic_time() #start time
    users = Users.list_users()
    #coun = Tsbank.CounterServer.get()
    Tsbank.CounterServer.increment()
    :telemetry.execute([:phoenix, :request], %{duration: System.monotonic_time() - start, log_counter: Tsbank.CounterServer.get()}, conn) # End time
    render(conn, :index, users: users)
  end

  @spec create(any(), map()) :: any()
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user),
         {:ok, %Customer{} = customer} <-  Customers.create_customer(user, user_params) do
      conn
        |> put_status(:created)
        |> render(:showDataCustomer, user: user, customer: customer, token: token)
    end
  end

  @spec sign_in(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def sign_in(conn, %{"email" => email,  "password" => password}) do
     case Guardian.authenticate(email, password) do
       {:ok, user, token} ->
        Users.update_user(%User{} = user, %{lastLoginDate: DateTime.utc_now})
        conn
          |> Plug.Conn.put_session(:user_id, user.id)
          |> put_status(:ok)
          |> render(:showDataLogin, user: user, token: token)
       {:error, :unauthorized} ->
          raise ErrorResponse.Unauthorized, message: "Email or Password incorrect."
     end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "Deleted")
    end
  end

  ################ADMINS

  def createAdmin(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user),
         {:ok, %Admin{} = admin} <-  Admins.create_admin(user, user_params) do
      conn
        |> put_status(:created)
        |> render(:showDataAdmin, user: user, admin: admin, token: token)
    end
  end

  def log_in(conn, %{"email" => email,  "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        IO.inspect(user)
        #update_account(%Account{} = account, %{lastLoginDate: DateTime.utc_now})
       conn
         |> Plug.Conn.put_session(:user_id, user.id)
         |> put_status(:ok)
         |> render(:showAdminData, user: user, token: token)
         {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or Password incorrect."
    end
 end

end
