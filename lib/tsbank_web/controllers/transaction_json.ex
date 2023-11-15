defmodule TsbankWeb.TransactionJSON do
  alias Tsbank.Transactions.Transaction

  @doc """
  Renders a list of transactions.
  """
  def index(%{transactions: transactions}) do
    %{data: for(transaction <- transactions, do: data(transaction))}
  end

  @doc """
  Renders a single transaction.
  """
  def show(%{transaction: transaction, my_balance: my_balance}) do
    %{data: data(transaction), my_balance: my_balance}
  end

  defp data(%Transaction{} = transaction) do
    %{
      id: transaction.id,
      type: transaction.type
    }
  end
end
