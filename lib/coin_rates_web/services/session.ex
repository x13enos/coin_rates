defmodule CoinRatesWeb.Session do
  alias CoinRates.Accounts.User
  alias CoinRates.Accounts

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Accounts.get_user!(id)
  end

  def logged_in?(conn), do: !!current_user(conn)

  def login(params) do
    user = Accounts.get_user_by([email: String.downcase(params["email"])])
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Bcrypt.verify_pass(password, user.crypted_password)
    end
  end
end