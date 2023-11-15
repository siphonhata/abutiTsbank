defmodule Tsbank.AdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tsbank.Admins` context.
  """

  @doc """
  Generate a admin.
  """
  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        role: "some role"
      })
      |> Tsbank.Admins.create_admin()

    admin
  end
end
