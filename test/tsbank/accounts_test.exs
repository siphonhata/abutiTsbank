defmodule Tsbank.AccountsTest do
  use Tsbank.DataCase

  alias Tsbank.Accounts

  describe "accounts" do
    alias Tsbank.Accounts.Account

    import Tsbank.AccountsFixtures

    @invalid_attrs %{accountBalance: nil, accountNumber: nil, branchcode: nil, dateOpened: nil, interestRate: nil, overDraftLimit: nil, status: nil, type: nil}

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{accountBalance: 120.5, accountNumber: "some accountNumber", branchcode: "some branchcode", dateOpened: ~D[2023-08-29], interestRate: 120.5, overDraftLimit: 42, status: "some status", type: "some type"}

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.accountBalance == 120.5
      assert account.accountNumber == "some accountNumber"
      assert account.branchcode == "some branchcode"
      assert account.dateOpened == ~D[2023-08-29]
      assert account.interestRate == 120.5
      assert account.overDraftLimit == 42
      assert account.status == "some status"
      assert account.type == "some type"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      update_attrs = %{accountBalance: 456.7, accountNumber: "some updated accountNumber", branchcode: "some updated branchcode", dateOpened: ~D[2023-08-30], interestRate: 456.7, overDraftLimit: 43, status: "some updated status", type: "some updated type"}

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.accountBalance == 456.7
      assert account.accountNumber == "some updated accountNumber"
      assert account.branchcode == "some updated branchcode"
      assert account.dateOpened == ~D[2023-08-30]
      assert account.interestRate == 456.7
      assert account.overDraftLimit == 43
      assert account.status == "some updated status"
      assert account.type == "some updated type"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
