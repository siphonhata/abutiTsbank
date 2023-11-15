defmodule TsbankWeb.AccountController do
  use TsbankWeb, :controller

  alias Tsbank.Accounts
  alias Tsbank.Accounts.Account
  alias TsbankWeb.Auth.Guardian
  alias Tsbank.Users

  action_fallback TsbankWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do

    cust_id = Guardian.get_me_id(conn.assigns.user.user_id)
    custom = Users.get_customer_user(cust_id)

    with {:ok, %Account{} = account} <- Accounts.create_account(custom, account_params) do
      conn
      |> put_status(:created)
      |> render(:show, account: account)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :status, account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)
    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end

  def customerAccounts(conn, %{"customer_id" => customer_id}) do
    accounts = Accounts.get_customer_accounts_by_id(customer_id)
    render(conn, :showAccounts, accounts: accounts)

  end


  def view_one_account(conn, %{"account_id" => account_id}) do
    account = Accounts.get_single_account(account_id)
    render(conn, :showSpecificAccount, account: account)
  end

  def view_all_accounts(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :showAccounts, accounts: accounts)
  end


  def status_update(conn, %{"account_id" => account_id}) do
    account = Accounts.get_single_account(account_id)
    if account.status == "true" do
      with {:ok, %Account{} = account} <- Accounts.update_account(account, %{status: "false"}) do
        render(conn, :show, account: account)
      end
    else
      with {:ok, %Account{} = account} <- Accounts.update_account(account,  %{status: "true"}) do
        render(conn, :show, account: account)
      end
    end
    #Map.put(user_params, "end_date", DateTime.utc_now)
  end

end
