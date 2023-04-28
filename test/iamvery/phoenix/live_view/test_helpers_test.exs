defmodule Iamvery.Phoenix.LiveView.TestHelpersTest do
  use ExUnit.Case, async: true
  doctest Iamvery.Phoenix.LiveView.TestHelpers

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint Test.Support.Endpoint

  use Iamvery.Phoenix.LiveView.TestHelpers

  setup do
    conn = build_conn() |> Plug.Test.init_test_session(%{})
    {:ok, conn: conn}
  end

  test "the pipeline works", %{conn: conn} do
    start(conn, "/")
    |> click("#link-1 a", "Edit")
    |> click("#link-1 a")
    |> assert_html("Edit Link")
    |> assert_visible("Edit Link")
    |> refute_html("LOLWAT")
    |> refute_visible("LOLWAT")
    |> assert_path("/")
    |> assert_visible("html", "Home")
    |> refute_visible("html", "Away")
    |> assert_element(".lolwat", "yes")
    |> assert_element(".lolwat")
    |> refute_element(".lolwat", "no")
    |> refute_element(".no")
    |> change_form("#widget-form", widget: %{})
    |> assert_html(escape("can't be blank"))
    |> submit_form("#widget-form", widget: %{lol: "wat"})
    |> assert_html("Link updated successfully")
    |> rerender()
    |> assert_html("Edit Link")
    |> follow("a", "Home")
    |> follow(".home")
    # |> follow()
    |> assert_html("Home")
  end

  describe "regression tests" do
    @tag :skip
    test "element scope leads to next assertion", %{conn: conn} do
      start(conn, "/")
      |> assert_visible(".lolwat", "yes")
      |> assert_visible("Home")
    end
  end
end
