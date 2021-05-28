defmodule CoinRates.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [put_change: 3, put_assoc: 3, change: 1]
  alias CoinRates.Repo

  alias CoinRates.Accounts.User
  alias CoinRates.Currencies.Coin

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: User |> preload(:coins) |> Repo.get!(id)

  def get_user_by(params), do: Repo.get_by(User, params)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> put_change(:crypted_password, hashed_password(attrs["password"]))
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """

  def add_coin(%User{} = user, %Coin{} = coin) do
    user
    |> change()
    |> put_assoc(:coins, [coin | user.coins])
    |> Repo.update!()
  end

  def remove_coin(%User{} = user, %Coin{} = coin) do
    user
    |> change()
    |> put_assoc(:coins, List.delete(user.coins, coin))
    |> Repo.update!()
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defp hashed_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end
end
