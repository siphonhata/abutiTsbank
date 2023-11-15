defmodule Tsbank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password, :string
      add :isActive, :boolean, default: true, null: true
      add :lastLoginDate, :naive_datetime

      timestamps()
    end

    create unique_index(:users, [:email])

  end
end
