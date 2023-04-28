defmodule YoloTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint Test.Support.Endpoint

  setup do
    conn = build_conn() |> Plug.Test.init_test_session(%{})
    {:ok, conn: conn}
  end

  test "something", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "LOLWAT"
  end
end
