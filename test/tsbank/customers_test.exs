defmodule Tsbank.CustomersTest do
  use Tsbank.DataCase

  alias Tsbank.Customers

  describe "customers" do
    alias Tsbank.Customers.Customer

    import Tsbank.CustomersFixtures

    @invalid_attrs %{ficaComplete: nil, dateOfBirth: nil, firstName: nil, idNumber: nil, lastName: nil, passportNumber: nil, phoneNumber: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Customers.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{ficaComplete: true, dateOfBirth: ~D[2023-08-28], firstName: "some firstName", idNumber: "some idNumber", lastName: "some lastName", passportNumber: "some passportNumber", phoneNumber: "some phoneNumber"}

      assert {:ok, %Customer{} = customer} = Customers.create_customer(valid_attrs)
      assert customer.ficaComplete == true
      assert customer.dateOfBirth == ~D[2023-08-28]
      assert customer.firstName == "some firstName"
      assert customer.idNumber == "some idNumber"
      assert customer.lastName == "some lastName"
      assert customer.passportNumber == "some passportNumber"
      assert customer.phoneNumber == "some phoneNumber"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      update_attrs = %{ficaComplete: false, dateOfBirth: ~D[2023-08-29], firstName: "some updated firstName", idNumber: "some updated idNumber", lastName: "some updated lastName", passportNumber: "some updated passportNumber", phoneNumber: "some updated phoneNumber"}

      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, update_attrs)
      assert customer.ficaComplete == false
      assert customer.dateOfBirth == ~D[2023-08-29]
      assert customer.firstName == "some updated firstName"
      assert customer.idNumber == "some updated idNumber"
      assert customer.lastName == "some updated lastName"
      assert customer.passportNumber == "some updated passportNumber"
      assert customer.phoneNumber == "some updated phoneNumber"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end
end
