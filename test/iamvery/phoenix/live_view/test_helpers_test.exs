defmodule Iamvery.Phoenix.LiveView.TestHelpersTest do
  use ExUnit.Case, async: true
  doctest Iamvery.Phoenix.LiveView.TestHelpers

  import Phoenix.ConnTest

  @endpoint Test.Support.Endpoint

  use Iamvery.Phoenix.LiveView.TestHelpers

  setup do
    conn = build_conn() |> Plug.Test.init_test_session(%{})
    {:ok, conn: conn}
  end

  describe "assertions" do
    test "asserting page content", %{conn: conn} do
      session =
        start(conn, "/")
        |> assert_visible("Home")
        |> assert_visible(".home", "Home")
        |> refute_visible("Nope")
        |> refute_visible(".home", "Nope")

      assert_raise ArgumentError, ~r/expected selector/, fn ->
        session |> refute_visible(".nope", "Home")
      end
    end

    test "asserting page structure", %{conn: conn} do
      start(conn, "/")
      |> assert_element(".home")
      |> assert_element(".home", "Home")
      |> refute_element(".nope")
      |> refute_element(".home", "Nope")
      |> refute_element(".nope", "Home")
    end
  end

  describe "interactions" do
    test "clicking", %{conn: conn} do
      start(conn, "/")
      |> click("#link-1 a")
      |> assert_visible("Home")
    end

    test "following redirects happens implicitly", %{conn: conn} do
      start(conn, "/")
      |> click(".home")
      |> assert_visible("Home")
      |> click("[phx-click=redirect]")
      |> assert_visible("Home")
    end

    test "forms", %{conn: conn} do
      start(conn, "/")
      |> change_form("#widget-form", widget: %{})
      |> assert_visible(escape("can't be blank"))
      |> submit_form("#widget-form", widget: %{lol: "wat"})
      |> assert_visible("Link updated successfully")
      |> rerender()
      |> assert_visible("Home")
    end
  end

  describe "utilities" do
    test "rerender/1", %{conn: conn} do
      session =
        start(conn, "/")
        |> assert_visible(".count", "1")

      {_, {:ok, view, _}} = session
      Process.send(view.pid, :increment, [])

      session
      |> rerender()
      |> assert_visible(".count", "2")
    end
  end

  # NOTE: This is the original test that I'm going to leave around a bit longer
  # for library coverage. It shouldn't be changed much anymore as smaller tests
  # are prefered to focus on specific behavior. This test may use some
  # deprecated interfaces.
  @tag :deprecated
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
    test "element scope leads to next assertion", %{conn: conn} do
      start(conn, "/")
      |> assert_visible(".lolwat", "yes")
      |> assert_visible("Home")
    end
  end
end
