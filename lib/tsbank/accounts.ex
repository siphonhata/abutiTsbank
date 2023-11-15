defmodule Tsbank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Tsbank.Repo

  alias Tsbank.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  def listAcc() do
    Account
    |> preload([:account])
    |> Repo.all()
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(customer, attrs \\ %{}) do
    customer
    |> Ecto.build_assoc(:account)
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end


  def get_customer_accounts_by_id(customer_id) do
    Account
    |> where(customer_id: ^customer_id)
    |> preload([:customer])
    |> Repo.all()
  end

  def get_single_account(id) do
    Account
    |> where(id: ^id)
    |> preload([:customer])
    |> Repo.one()
  end
##########
  def get_account_id(id), do: Repo.get(Account, id)

  def get_account_name(id) do
    Account
    |> where(id: ^id)
    |> Repo.one()
  end

  def get_full_account_id(id) do
  Account
    |> where(customer_id: ^id)
    |> Repo.one()

  end


  def get_account_id_use(id), do: Repo.get(Account, id)

end
