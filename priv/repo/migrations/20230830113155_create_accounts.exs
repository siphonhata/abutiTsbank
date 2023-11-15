defmodule Tsbank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :accountNumber, :string
      add :status, :string
      add :dateOpened, :date
      add :interestRate, :float
      add :balance, :float
      add :overDraftLimit, :integer
      add :branchcode, :string
      add :type, :string
      add :customer_id, references(:customers, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
    create unique_index(:accounts, [:accountNumber])
  end
end
