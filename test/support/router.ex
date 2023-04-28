# Inspired by https://github.com/phoenixframework/phoenix_live_view/blob/dc4c139092c8b5eb6617ba9c9c6266853011c88e/test/support/router.ex
defmodule Test.Support.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  live("/", Test.Support.Live)
end
