defmodule CoinRates.CurrenciesTest do
  use CoinRates.DataCase

  alias CoinRates.Currencies

  describe "coins" do
    alias CoinRates.Currencies.Coin

    @valid_attrs %{cmc_id: 42, name: "some name", slug: "some slslugud"}
    @update_attrs %{cmc_id: 43, name: "some updated name", slug: "some updated slug"}
    @invalid_attrs %{cmc_id: nil, name: nil, slug: nil}

    def coin_fixture(attrs \\ %{}) do
      {:ok, coin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Currencies.create_coin()

      coin
    end

    test "list_coins/0 returns all coins" do
      coin = coin_fixture()
      assert Currencies.list_coins() == [coin]
    end

    test "get_coin!/1 returns the coin with given id" do
      coin = coin_fixture()
      assert Currencies.get_coin!(coin.id) == coin
    end

    test "create_coin/1 with valid data creates a coin" do
      assert {:ok, %Coin{} = coin} = Currencies.create_coin(@valid_attrs)
      assert coin.cmc_id == 42
      assert coin.name == "some name"
      assert coin.slug == "some slug"
    end

    test "create_coin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Currencies.create_coin(@invalid_attrs)
    end

    test "update_coin/2 with valid data updates the coin" do
      coin = coin_fixture()
      assert {:ok, %Coin{} = coin} = Currencies.update_coin(coin, @update_attrs)
      assert coin.cmc_id == 43
      assert coin.name == "some updated name"
      assert coin.slug == "some updated slug"
    end

    test "update_coin/2 with invalid data returns error changeset" do
      coin = coin_fixture()
      assert {:error, %Ecto.Changeset{}} = Currencies.update_coin(coin, @invalid_attrs)
      assert coin == Currencies.get_coin!(coin.id)
    end

    test "delete_coin/1 deletes the coin" do
      coin = coin_fixture()
      assert {:ok, %Coin{}} = Currencies.delete_coin(coin)
      assert_raise Ecto.NoResultsError, fn -> Currencies.get_coin!(coin.id) end
    end

    test "change_coin/1 returns a coin changeset" do
      coin = coin_fixture()
      assert %Ecto.Changeset{} = Currencies.change_coin(coin)
    end
  end
end
