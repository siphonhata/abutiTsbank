defmodule Tsbank.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tsbank.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        isActive: true,
        lastLoginDate: ~N[2023-08-28 04:27:00],
        password: "some password"
      })
      |> Tsbank.Users.create_user()

    user
  end
end
