defmodule TsbankWeb.AccountJSON do
  alias Tsbank.Accounts.Account

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    #BankAccount.start_link(account.accountNumber, account.accountBalance)
    %{data: data(account)}
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      accountNumber: account.accountNumber,
      status: account.status,
      dateOpened: account.dateOpened,
      interestRate: account.interestRate,
      balance: account.balance,
      overDraftLimit: account.overDraftLimit,
      branchcode: account.branchcode,
      type: account.type
    }
  end

  def showAccounts(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}

  end

  def showSpecificAccount(%{account: account}) do
    %{data: data(account)}
  end

end
