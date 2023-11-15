defmodule TsbankWeb.Auth.SetAccount do
  import Plug.Conn
  alias TsbankWeb.Auth.ErrorResponse
  alias Tsbank.Users

  def init(_options) do

  end

  def call(conn, _options) do
    if conn.assigns[:user] do
      conn
     else
      user_id = get_session(conn, :user_id)
      if user_id == nil, do: raise ErrorResponse.Unauthorized
        user = Users.get_full_user(user_id)
        cond do
           user_id && user -> assign(conn, :user, user)
           true -> assign(conn, :user, nil)
        end
      end
    end
end
