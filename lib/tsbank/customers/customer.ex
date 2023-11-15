defmodule Tsbank.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customers" do
    field :ficaComplete, :boolean, default: false
    field :dateOfBirth, :date
    field :firstName, :string
    field :idNumber, :string
    field :lastName, :string
    field :passportNumber, :string
    field :phoneNumber, :string
    belongs_to :user, Tsbank.Users.User
    has_many :account, Tsbank.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:user_id, :firstName, :lastName, :phoneNumber, :dateOfBirth, :idNumber, :passportNumber, :ficaComplete])
    |> validate_required([:user_id])
    |> validate_length(:idNumber, min: 13, max: 13)
    |> unique_constraint(:idNumber)
  end
end
