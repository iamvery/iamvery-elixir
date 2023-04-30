# Inspired by https://github.com/phoenixframework/phoenix_live_view/blob/dc4c139092c8b5eb6617ba9c9c6266853011c88e/test/support/router.ex
defmodule Test.Support.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  live("/", Test.Support.Live)
  live("/redirect", Redirect)
end

defmodule Redirect do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    socket = push_redirect(socket, to: "/")
    {:ok, socket}
  end

  @impl true
  def render(assigns), do: ~H"redirected"
end
