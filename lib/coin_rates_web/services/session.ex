defmodule CoinRatesWeb.Session do
  alias CoinRates.Accounts.User
  alias CoinRates.Accounts

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