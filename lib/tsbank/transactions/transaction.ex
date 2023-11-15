defmodule Tsbank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :float
    field :description, :string
    field :method, :string
    field :status, :string
    field :type, :string
    belongs_to :account, Tsbank.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:account_id, :type, :status, :method, :amount, :description])
    |> validate_required([:type])
  end
end
