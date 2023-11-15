defmodule TsbankWeb.AdminJSON do
  alias Tsbank.Admins.Admin
  alias Tsbank.Accounts.Account
#  alias Tsbank.Accounts

  @doc """
  Renders a list of admins.
  """
  def index(%{admins: admins}) do
    %{data: for(admin <- admins, do: data(admin))}
  end

  # @doc """
  # Renders a single admin.
  # """
  def show(%{account: account}) do
    %{dataAcc: dataAcc(account)}
  end

  defp dataAcc(%Account{} = account) do
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

  defp data(%Admin{} = admin) do
    %{
      id: admin.id,
      role: admin.role
    }
  end

  def showAccounts(%{accounts: accounts}) do
    %{dataAcc: for(account <- accounts, do: dataAcc(account))}

  end

 end
