defmodule CoinRatesWeb.SessionController do
  use CoinRatesWeb, :controller
  import CoinRatesWeb.Session, only: [login: 1]
  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, params) do
    case login(params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end