defmodule Tsbank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :status, :string
      add :method, :string
      add :amount, :float
      add :description, :string
      #add :account_id, references(:accounts, on_delete: :delete_all, type: :uuid)
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:account_id])
  end
end
