defmodule TsbankWeb.CustomerController do
  use TsbankWeb, :controller

  alias Tsbank.Customers
  alias Tsbank.Customers.Customer

  action_fallback TsbankWeb.FallbackController

  def index(conn, _params) do
    customers = Customers.list_customers()
    render(conn, :index, customers: customers)
  end

  ##########################################################

  # def createAcc(conn, %{"account" => account_params}) do
  #   with {:ok, %Accounts{} = account} <- Accounts.create_account(account_params) do
  #     acc_val = account_params.acc_num
  #     acc_bal = account_params.bal

  #     BankAccount.start_link(acc_val, acc_bal)
  #     conn
  #     |> put_status(:created)
  #     |> render(:show, account: account)

  #   end
  # end







  ###################################################
  def create(conn, %{"customer" => customer_params}) do
    with {:ok, %Customer{} = customer} <- Customers.create_customer(customer_params) do
      conn
      |> put_status(:created)
      |> render(:show, customer: customer)
    end
  end

  def show(conn, %{"id" => id}) do
    customer = Customers.get_customer!(id)
    render(conn, :show, customer: customer)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Customers.get_customer!(id)

    with {:ok, %Customer{} = customer} <- Customers.update_customer(customer, customer_params) do
      render(conn, :show, customer: customer)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Customers.get_customer!(id)

    with {:ok, %Customer{}} <- Customers.delete_customer(customer) do
      send_resp(conn, :no_content, "")
    end
  end
end
