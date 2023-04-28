# Inspired by https://github.com/phoenixframework/phoenix_live_view/blob/dc4c139092c8b5eb6617ba9c9c6266853011c88e/test/support/endpoint.ex
defmodule Test.Support.Endpoint do
  use Phoenix.Endpoint, otp_app: :iamvery

  def call(conn, _options) do
    conn
    |> Test.Support.Router.call([])
  end

  defoverridable url: 0, script_name: 0, config: 1, config: 2, static_path: 1
  def config(:live_view), do: [signing_salt: "112345678212345678312345678412"]
  def config(:secret_key_base), do: String.duplicate("57689", 50)
  def config(which), do: super(which)
  def config(which, default), do: super(which, default)
end
