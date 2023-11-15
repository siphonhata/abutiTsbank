defmodule Tsbank.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tsbank.Customers` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        ficaComplete: true,
        dateOfBirth: ~D[2023-08-28],
        firstName: "some firstName",
        idNumber: "some idNumber",
        lastName: "some lastName",
        passportNumber: "some passportNumber",
        phoneNumber: "some phoneNumber"
      })
      |> Tsbank.Customers.create_customer()

    customer
  end
end
