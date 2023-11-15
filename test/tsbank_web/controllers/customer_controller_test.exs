defmodule TsbankWeb.CustomerControllerTest do
  use TsbankWeb.ConnCase

  import Tsbank.CustomersFixtures

  alias Tsbank.Customers.Customer

  @create_attrs %{
    ficaComplete: true,
    dateOfBirth: ~D[2023-08-28],
    firstName: "some firstName",
    idNumber: "some idNumber",
    lastName: "some lastName",
    passportNumber: "some passportNumber",
    phoneNumber: "some phoneNumber"
  }
  @update_attrs %{
    ficaComplete: false,
    dateOfBirth: ~D[2023-08-29],
    firstName: "some updated firstName",
    idNumber: "some updated idNumber",
    lastName: "some updated lastName",
    passportNumber: "some updated passportNumber",
    phoneNumber: "some updated phoneNumber"
  }
  @invalid_attrs %{ficaComplete: nil, dateOfBirth: nil, firstName: nil, idNumber: nil, lastName: nil, passportNumber: nil, phoneNumber: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all customers", %{conn: conn} do
      conn = get(conn, ~p"/api/customers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create customer" do
    test "renders customer when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/customers", customer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/customers/#{id}")

      assert %{
               "id" => ^id,
               "ficaComplete" => true,
               "dateOfBirth" => "2023-08-28",
               "firstName" => "some firstName",
               "idNumber" => "some idNumber",
               "lastName" => "some lastName",
               "passportNumber" => "some passportNumber",
               "phoneNumber" => "some phoneNumber"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/customers", customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update customer" do
    setup [:create_customer]

    test "renders customer when data is valid", %{conn: conn, customer: %Customer{id: id} = customer} do
      conn = put(conn, ~p"/api/customers/#{customer}", customer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/customers/#{id}")

      assert %{
               "id" => ^id,
               "ficaComplete" => false,
               "dateOfBirth" => "2023-08-29",
               "firstName" => "some updated firstName",
               "idNumber" => "some updated idNumber",
               "lastName" => "some updated lastName",
               "passportNumber" => "some updated passportNumber",
               "phoneNumber" => "some updated phoneNumber"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, customer: customer} do
      conn = put(conn, ~p"/api/customers/#{customer}", customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete customer" do
    setup [:create_customer]

    test "deletes chosen customer", %{conn: conn, customer: customer} do
      conn = delete(conn, ~p"/api/customers/#{customer}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/customers/#{customer}")
      end
    end
  end

  defp create_customer(_) do
    customer = customer_fixture()
    %{customer: customer}
  end
end
