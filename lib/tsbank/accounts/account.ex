defmodule Tsbank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :float
    field :accountNumber, :string
    field :branchcode, :string
    field :dateOpened, :date
    field :interestRate, :float
    field :overDraftLimit, :integer
    field :status, :string
    field :type, :string
    has_many :transaction, Tsbank.Transactions.Transaction
    belongs_to :customer, Tsbank.Customers.Customer

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:accountNumber, :status, :dateOpened, :interestRate, :balance, :overDraftLimit, :branchcode, :type])
    |> validate_required([:accountNumber, :status, :dateOpened, :interestRate, :balance, :overDraftLimit, :branchcode, :type])
    |> unique_constraint(:accountNumber)
  end
end
