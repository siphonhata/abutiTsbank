defmodule TsbankWeb.CustomerJSON do
  alias Tsbank.Customers.Customer

  @doc """
  Renders a list of customers.
  """
  def index(%{customers: customers}) do
    %{data: for(customer <- customers, do: data(customer))}
  end

  @doc """
  Renders a single customer.
  """
  def show(%{customer: customer}) do
    %{data: data(customer)}
  end

  defp data(%Customer{} = customer) do
    %{
      id: customer.id,
      firstName: customer.firstName,
      lastName: customer.lastName,
      phoneNumber: customer.phoneNumber,
      dateOfBirth: customer.dateOfBirth,
      idNumber: customer.idNumber,
      passportNumber: customer.passportNumber,
      ficaComplete: customer.ficaComplete
    }
  end
end
