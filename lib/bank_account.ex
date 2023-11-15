defmodule BankAccount do
  require Logger
  use GenServer
  alias Transaction
  alias Tsbank.Accounts.Account
  import Ecto.Query

  # Starts the GenServer for a BankAccount
  def start_link(account_number) do
    account = Tsbank.Repo.get_by!(Account, accountNumber: account_number)
    result = GenServer.start_link(__MODULE__, account.accountNumber, name: {:via, Registry, {BankRegistry, account.accountNumber}})
    result
  end


  def deposit(pid, account_number, amount) do
    try do
      case GenServer.call(pid, {:deposit, account_number, amount}) do
        {:ok, new_balance} ->
          Logger.debug("Deposited #{amount}. New balance: #{new_balance}")
        {:ok, new_balance}

        {:error, reason} ->
          Logger.error("Deposit failed: #{reason}")
        {:error, reason}
      end
    rescue
      _ -> {:error, "Invalid PID"}
    end
  end


  # Withdraw function
  def withdraw(pid, account_number, amount) do
    try do
      case GenServer.call(pid, {:withdraw, account_number, amount}) do
        {:ok, new_balance} ->
          Logger.debug("Withdrew #{amount}. New balance: #{new_balance}")
          {:ok, new_balance}
        {:error, reason} ->
          Logger.error("Withdrawal failed: #{reason}")
          {:error, reason}
      end
    rescue
      _ -> {:error, "Invalid PID"}
    end
  end

# Balance function
def balance(pid) do
  try do
    GenServer.call(pid, :balance)
  rescue
    _ -> {:error, "Invalid PID"}
  end
end

  # Transfer function
  def transfer(from_account, to_account, amount) do
    with [{from_account_pid, _}] <- Registry.lookup(BankRegistry, from_account),
          [{to_account_pid, _}] <- Registry.lookup(BankRegistry, to_account),
          {:ok, _} <- GenServer.call(from_account_pid, {:withdraw, amount}) do
      Logger.debug("Both accounts exist and withdrawal was successful.")

      case GenServer.call(to_account_pid, {:deposit, amount}) do
        {:ok, _} -> Logger.debug("Transfer was successful.")
          {:ok, "Transfer successful"}

        {:error, reason} -> Logger.error("Deposit failed: #{reason}")
          {:error, reason}
      end
    else
      _ -> {:error, "Transfer failed. Either one of the accounts does not exist, or withdrawal failed."}
    end
  end

  # GenServer Callbacks

  def handle_call({:deposit, account_number, amount}, _from, balance) when amount > 0 do
    new_balance = balance + amount
    Tsbank.Repo.get_by!(Tsbank.Accounts.Account, accountNumber: account_number)
    {1, [_updated_account]} = from(a in Account, where: a.accountNumber == ^account_number, select: a)
    |> Tsbank.Repo.update_all(set: [balance: new_balance])

    Logger.debug("Deposited #{amount}. New balance: #{new_balance}")
    {:reply, {:ok, new_balance}, new_balance}
  end

  def handle_call({:deposit, _account_number, _amount}, _from, balance) do
    {:reply, {:error, "Invalid amount"}, balance}
  end

  def handle_call({:withdraw, account_number, amount}, _from, balance) when amount > 0 and amount <= balance do
    new_balance = balance - amount

    {1, [_updated_account]} =
      from(mm in Account, where: mm.accountNumber == ^account_number, select: mm)
      |> Tsbank.Repo.update_all(set: [balance: new_balance])

    Logger.debug("Withdrew #{amount}. New balance: #{new_balance}")
    {:reply, {:ok, new_balance}, new_balance}
  end

  def handle_call({:withdraw, _amount}, _from, balance) do
    Logger.warning("Attempt to withdraw with insufficient funds.")
    {:reply, {:error, "Insufficient funds"}, balance}
  end

  def handle_call(:balance, _from, balance) do
    Logger.info("Balance checked. Current balance: #{balance}")
    {:reply, balance, balance}
  end

  def stop(pid) do
    GenServer.stop(pid, :normal, :infinity)
  end

  # Initialization callback
  def init(account_number) do
    account = (Tsbank.Repo.get_by!(Tsbank.Accounts.Account, accountNumber: account_number))
    {:ok, account.balance}
  end

end
