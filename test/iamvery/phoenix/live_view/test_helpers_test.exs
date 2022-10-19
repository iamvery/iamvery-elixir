defmodule Plug.HTML do
  @moduledoc "A test fake to stand in for the real Plug module"
  def html_escape(v), do: v
end

defmodule Phoenix.LiveViewTest do
  @moduledoc "A test fake to stand in for the real Phoenix module"
  @html "<html>Edit Link. Link updated successfully. It can't be blank</html>"
  def live(_, _), do: {:ok, :live, @html}
  def form(:live, _, _), do: :form
  def element(:live, _, _), do: :live
  def has_element?(:live, _, _), do: true
  def follow_redirect(@html, :conn), do: {:ok, :live, @html}
  def render(:live), do: @html
  def render_click(:live), do: @html
  def render_change(:form), do: @html
  def render_submit(:form), do: @html
  def assert_patch(:live, _), do: {:ok, :live, @html}
end

defmodule Iamvery.Phoenix.LiveView.TestHelpersTest do
  use ExUnit.Case
  doctest Iamvery.Phoenix.LiveView.TestHelpers

  use Iamvery.Phoenix.LiveView.TestHelpers

  test "the pipeline works" do
    conn = :conn

    start(conn, "/")
    |> click("#link-1 a", "Edit")
    |> assert_html("Edit Link")
    |> refute_html("lolwat")
    |> assert_path("/")
    |> assert_element(".lolwat", "Haha")
    |> change_form("#widget-form", widget: %{})
    |> assert_html(escape("can't be blank"))
    |> submit_form("#widget-form", widget: %{lol: "wat"})
    |> assert_html("Link updated successfully")
    |> rerender()
    |> assert_html("Edit Link")
  end
end
