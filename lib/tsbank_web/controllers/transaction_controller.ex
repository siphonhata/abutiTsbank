defmodule TsbankWeb.TransactionController do
  use TsbankWeb, :controller

  alias BankAccount
  alias Tsbank.Transactions
  alias Tsbank.Transactions.Transaction
  alias TsbankWeb.Auth.Guardian
  alias Tsbank.Accounts
  action_fallback TsbankWeb.FallbackController

  def index(conn, _params) do
    transactions = Transactions.list_transactions()
    render(conn, :index, transactions: transactions)
  end

  def create(conn, %{"account_id" => account_id, "transaction" => transaction_params}) do
    user_id_from_session = conn.assigns.user.user_id

    customer_id_by =  Guardian.get_me_id(user_id_from_session)
    cust_id_st =  Guardian.get_me_account_id(customer_id_by)
    acc_struct = Accounts.get_account_id_use(cust_id_st)


    with {:ok, %Transaction{} = transaction} <- Transactions.create_transaction(acc_struct,transaction_params),
    IO.inspect(transaction),
    name_acc <- Guardian.get_that_account_name(account_id),
    {:ok, pid1} <- BankAccount.start_link(name_acc),
    {:ok, my_balance} <- BankAccount.deposit(pid1, name_acc, transaction.amount),
    :ok <- BankAccount.stop(pid1) do
      conn
      |> put_status(:created)
      |> render(:show, transaction: transaction, my_balance: my_balance)
    end

  end


  def show(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    render(conn, :show, transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Transactions.get_transaction!(id)

    with {:ok, %Transaction{} = transaction} <- Transactions.update_transaction(transaction, transaction_params) do
      render(conn, :show, transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)

    with {:ok, %Transaction{}} <- Transactions.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end

  def withdraw_money(conn, %{"account_id" => account_id, "transaction" => transaction_params}) do
    user_id_from_session = IO.inspect(conn.assigns.user.user_id)

    customer_id_by = IO.inspect(Guardian.get_me_id(user_id_from_session))
    cust_id_st = IO.inspect(Guardian.get_me_account_id(customer_id_by))
    acc_struct = IO.inspect(Accounts.get_account_id_use(cust_id_st))


    with {:ok, %Transaction{} = transaction} <- Transactions.create_transaction(acc_struct,transaction_params),
    name_acc  <- Guardian.get_that_account_name(account_id),
    {:ok, pid1}  <- BankAccount.start_link(name_acc),
    {:ok, my_balance} <- BankAccount.withdraw(pid1, name_acc, transaction.amount),
    :ok <- BankAccount.stop(pid1) do
      conn
      |> put_status(:created)
      |> render(:show, transaction: transaction, my_balance: my_balance)
    end
  end

  def transfer(conn, %{"amount" => amount, "destination_account_id" => destination_account_id}) do
    # Perform the transfer logic, update balances, etc.
    # This could include making changes to your local database.

    # Notify the receiver (Project B) about the transfer
    send_notification_to_project_b(destination_account_id, amount)

    conn
    |> put_status(:ok)
    |> json(%{message: "Transfer successful"})
  end

  defp send_notification_to_project_b(destination_account_id, amount) do
    # Use HTTPoison or another HTTP client to make a POST request to Project B
    url = "http://192.168.1.222:4003/api/notify_transfer"
    body = %{amount: amount, destination_account_id: destination_account_id}

    # Use your preferred HTTP client to send the request
    HTTPoison.post(url, Poison.encode!(body), [{"Content-Type", "application/json"}])
  end


  def notify_transfer(conn, %{"amount" => amount, "destination_account_id" => destination_account_id}) do
    # Perform the necessary actions on Project B, such as updating balances

    IO.inspect(amount)
    IO.inspect(destination_account_id)

    conn
    |> put_status(:ok)
    |> json(%{message: "Transfer notification received"})
  end

end
