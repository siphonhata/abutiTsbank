defmodule Tsbank.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tsbank.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        accountBalance: 120.5,
        accountNumber: "some accountNumber",
        branchcode: "some branchcode",
        dateOpened: ~D[2023-08-29],
        interestRate: 120.5,
        overDraftLimit: 42,
        status: "some status",
        type: "some type"
      })
      |> Tsbank.Accounts.create_account()

    account
  end
end
