defmodule TsbankWeb.AdminController do
  use TsbankWeb, :controller

  alias Tsbank.Admins
  alias Tsbank.Admins.Admin
  alias Tsbank.Accounts
  alias Tsbank.Accounts.Account
  alias Tsbank.Users

  action_fallback TsbankWeb.FallbackController

  def index(conn, _params) do
    admins = Admins.list_admins()
    render(conn, :index, admins: admins)
  end

  def create(conn, %{"admin" => admin_params}) do
    with {:ok, %Admin{} = admin} <- Admins.create_admin(admin_params) do
      conn
      |> put_status(:created)
      |> render(:show, admin: admin)
    end
  end

  def show(conn, %{"id" => id}) do
    admin = Admins.get_admin!(id)
    render(conn, :show, admin: admin)
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    admin = Admins.get_admin!(id)

    with {:ok, %Admin{} = admin} <- Admins.update_admin(admin, admin_params) do
      render(conn, :show, admin: admin)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin = Admins.get_admin!(id)

    with {:ok, %Admin{}} <- Admins.delete_admin(admin) do
      send_resp(conn, :no_content, "")
    end
  end

  def createCustomerAccount(conn, %{"customer_id" => customer_id, "account" => account_params}) do
    customer = Users.get_customer_user(customer_id)
    with {:ok, %Account{} = account} <- Accounts.create_account(customer, account_params) do
      conn
      |> put_status(:created)
      |> render(:show, account: account)
    end
  end

  def view_all_accounts(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :show, accounts: accounts)
  end

end
