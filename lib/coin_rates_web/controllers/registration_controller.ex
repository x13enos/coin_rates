defmodule CoinRatesWeb.RegistrationController do
  use CoinRatesWeb, :controller
  alias CoinRates.Accounts.User

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do  
    case CoinRates.Accounts.create_user(user_params) do
      {:ok, changeset} ->
        conn
        |> put_session(:current_user_id, changeset.id)
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end
end