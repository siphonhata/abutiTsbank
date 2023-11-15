defmodule Tsbank.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tsbank.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        type: "some type"
      })
      |> Tsbank.Transactions.create_transaction()

    transaction
  end
end
