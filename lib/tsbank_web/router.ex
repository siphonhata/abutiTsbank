defmodule TsbankWeb.Router do
  alias AccountController
  use TsbankWeb, :router
  use Plug.ErrorHandler

 #rescue_from Jason.DecodeError, Tsbank.ErrorHelpers, :handle_json_decode_error

 def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session

  end

  pipeline :auth do
    plug TsbankWeb.Auth.Pipeline
    plug TsbankWeb.Auth.SetAccount
  end

  scope "/api/v1", TsbankWeb do
    pipe_through :api

    post "/notify_transfer", TransactionController, :notify_transfer
    post "/transfer", TransactionController, :transfer
    #get "/register/new", UserController, :index
    post "/customer/create", UserController, :create #
    post "/customer/sign_in", UserController, :sign_in #

    #admins
    post "/admin/create", UserController, :createAdmin #
    post "/admin/log_in", UserController, :log_in #
  end

  scope "/api/v1", TsbankWeb do
    pipe_through [:api, :auth]

    #get "/accounts", AccountController, :index
    post "/accounts", AccountController, :create #
    get "/customers/:customer_id", AccountController, :customerAccounts #
    get "/accounts/:account_id", AccountController, :view_one_account #
    patch "/accounts/status_change/:account_id", AccountController, :status_update #

    #ADMINS
    get "/admin/accounts", AccountController, :view_all_accounts #
    get "/admin/accounts/:account_id", AccountController, :view_one_account #
    post "/admin/accounts/:customer_id", AdminController, :createCustomerAccount #
    post "/accounts/:account_id/deposit", TransactionController, :create
    post "/accounts/:account_id/withdraw", TransactionController, :withdraw_money

  end
end
