defmodule CoinRates.Currencies do
  @moduledoc """
  The Currencies context.
  """

  import Ecto.Query, warn: false
  alias CoinRates.Repo

  alias CoinRates.Currencies.{Coin, Quote}

  @doc """
  Returns the list of coins.

  ## Examples

      iex> list_coins()
      [%Coin{}, ...]

  """
  def list_coins do
    quotes_query = from q in Quote, order_by: [asc: q.inserted_at], where: q.inserted_at >= datetime_add(^DateTime.utc_now, -1, "day")
    Repo.all(from Coin, preload: [quotes: ^quotes_query])
  end

  @doc """
  Gets a single coin.

  Raises `Ecto.NoResultsError` if the Coin does not exist.

  ## Examples

      iex> get_coin!(123)
      %Coin{}

      iex> get_coin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coin!(id), do: Repo.get!(Coin, id)

  @doc """
  Gets a single coin by specific attribute.

  Return nil if the Coin does not exist.

  ## Examples

      iex> get_coin_by(%{ name: "Bitcoin" })
      %Coin{}

      iex> get_coin_by(%{ name: "Gitcoin" })
      nil

  """
  def get_coin_by(attribute), do: Repo.get_by(Coin, attribute)


  @doc """
  Creates a coin.

  ## Examples

      iex> create_coin(%{field: value})
      {:ok, %Coin{}}

      iex> create_coin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coin(attrs \\ %{}) do
    %Coin{}
    |> Coin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coin.

  ## Examples

      iex> update_coin(coin, %{field: new_value})
      {:ok, %Coin{}}

      iex> update_coin(coin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coin(%Coin{} = coin, attrs) do
    coin
    |> Coin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a coin.

  ## Examples

      iex> delete_coin(coin)
      {:ok, %Coin{}}

      iex> delete_coin(coin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coin(%Coin{} = coin) do
    Repo.delete(coin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coin changes.

  ## Examples

      iex> change_coin(coin)
      %Ecto.Changeset{data: %Coin{}}

  """
  def change_coin(%Coin{} = coin, attrs \\ %{}) do
    Coin.changeset(coin, attrs)
  end

  def last_coin() do
    from(c in Coin, limit: 1) |> CoinRates.Repo.one
  end

  def last_quote() do
    from(q in Quote, limit: 1) |> CoinRates.Repo.one
  end

  @doc """
  Creates a quote.

  ## Examples

      iex> create_quote(%{field: value})
      {:ok, %Quote{}}

      iex> create_quote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quote(attrs \\ %{}) do
    %Quote{}
    |> Quote.changeset(attrs)
    |> Repo.insert()
  end
end
