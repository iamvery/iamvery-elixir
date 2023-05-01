defmodule Iamvery.Phoenix.LiveView.TestHelpers do
  @moduledoc """
  A set of helper functions that make LiveView tests easier to read and write
  as a pipeline without leaking details of the conn, view, rendering, patching,
  etc.

  To use in your tests, you may replace:

      import Phoneix.LiveViewTest

  with (using the helpers takes care of the import for you):

      use Iamvery.Phoenix.LiveView.TestHelpers

  And then write tests like:

      test "a view", %{conn: conn} do
        start(conn, "/")
        |> assert_visible("Something")
        |> click("Edit")
        |> assert_visible("Editing Something")
      end
  """

  import ExUnit.Assertions
  import Phoenix.LiveViewTest

  defmacro __using__([]) do
    quote do
      import Phoenix.LiveViewTest
      import unquote(__MODULE__)

      defp handle_redirects(conn, view, html) when is_binary(html) do
        {conn, {:ok, view, html}}
      end

      defp handle_redirects(conn, nil, {:ok, view, html}) do
        {conn, {:ok, view, html}}
      end

      defp handle_redirects(conn, _view, redirect) do
        result = follow_redirect(redirect, conn)
        handle_redirects(conn, nil, result)
      end

      def follow(session, selector, text \\ nil) do
        IO.warn("The function follow/3 is deprecated. Use click/3 instead")
        click(session, selector, text)
      end

      def follow({conn, redirect}) do
        IO.warn("The function click/3 handles following redirects recursively")
        {conn, follow_redirect(redirect, conn)}
      end
    end
  end

  ########
  # Entry

  @doc """
  This function is the "helpers" analog of LiveView's live/2 function.
  """
  defmacro start(conn, path) do
    quote do
      {unquote(conn), live(unquote(conn), unquote(path))}
    end
  end

  #############
  # Assertions

  def assert_html(session, expected) do
    IO.warn("The function assert_html/2 is deprecated. Use assert_visible/2 instead")
    assert_visible(session, expected)
  end

  def refute_html(session, expected) do
    IO.warn("The function refute_html/2 is deprecated. Use refute_visible/2 instead")
    refute_visible(session, expected)
  end

  @doc """
  Assert that some content exists in the view.

  Note: At this time, the assertion will match any part of the entire page
  document as a string which does not precisely align with the "visible" part
  of the function name. This is a known issue and is on the slate for
  discussion.
  """
  def assert_visible({conn, {:ok, view, html}}, expected_html) do
    assert html =~ expected_html
    {conn, {:ok, view, html}}
  end

  @doc """
  The opposite of assert_visible/2.

  Note: At this time, the assertion will match any part of the entire page
  document as a string which does not precisely align with the "visible" part
  of the function name. This is a known issue and is on the slate for
  discussion.
  """
  def refute_visible({conn, {:ok, view, html}}, unexpected_html) do
    refute html =~ unexpected_html
    {conn, {:ok, view, html}}
  end

  @doc """
  Assert that some selector exists in the view whose (optional) content
  matches. You may notice the similarity of this function to assert_element/3.
  The advantage of assert_visible/3 becomes apparent when the assertion fails.
  This function provides and more specific failure message, i.e. "here's the
  element that was found" vs. "the expected element simply doesn't exist on the
  page".

  Note: At this time, the assertion will match any part of the entire page
  document as a string which does not precisely align with the "visible" part
  of the function name. This is a known issue and is on the slate for
  discussion.
  """
  def assert_visible({conn, {:ok, view, html}}, selector, expected_html) do
    element_html = element(view, selector) |> render()
    assert element_html =~ expected_html
    {conn, {:ok, view, html}}
  end

  @doc """
  The opposite of assert_visible/3.

  Note: At this time, the assertion will match any part of the entire page
  document as a string which does not precisely align with the "visible" part
  of the function name. This is a known issue and is on the slate for
  discussion.
  """
  def refute_visible({conn, {:ok, view, html}}, selector, unexpected_html) do
    element_html = element(view, selector) |> render()
    refute element_html =~ unexpected_html
    {conn, {:ok, view, html}}
  end

  @doc """
  Assert that some selector with the (optional) content exists in the view. You
  may notice the similarity of this function to assert_visible/3. The downside
  of this function is that assertion failures to not provide as specific
  feedback (due to the difference in implementation). The advantage is that it
  may be used to assert in elements that appear repeatedly by their selector.

  ## Example

      # Given some multi-select
      |> assert_element("option[selected]", "Picked")
      # Would pass if there is any selected "option" that matches the text
      # "Picked". While assert_visible/3 in this case would fail when there are
      # multiple selected options on the page at all.
  """
  def assert_element({conn, {:ok, view, html}}, selector, text \\ nil) do
    assert has_element?(view, selector, text)
    {conn, {:ok, view, html}}
  end

  @doc """
  The opposite of assert_element/3.
  """
  def refute_element({conn, {:ok, view, html}}, selector, text \\ nil) do
    refute has_element?(view, selector, text)
    {conn, {:ok, view, html}}
  end

  def assert_path({conn, {:ok, view, html}}, path) do
    IO.warn("""
    Tests should avoid leaking details about the underlying framework.Lean
    on asserting things about the page itself rather than LiveView-specific
    concepts like "patching".
    """)

    assert_patch(view, path)
    {conn, {:ok, view, html}}
  end

  ###############
  # Interactions

  @doc """
  Locate an element on page an issue a phx-click event. If the system
  redirects, automatically follow the redirects (recursively) until a view is
  rendered.. If it simply renders, the new rendered view is returned.
  """
  defmacro click(session, selector, text \\ nil) do
    quote do
      {conn, {:ok, view, _html}} = unquote(session)
      result = element(view, unquote(selector), unquote(text)) |> render_click()
      handle_redirects(conn, view, result)
    end
  end

  @doc """
  Change a form and render the change so that assertions may be made about the
  result.
  """
  def change_form({conn, {:ok, view, _html}}, selector, attributes) do
    html =
      view
      |> form(selector, attributes)
      |> render_change()

    {conn, {:ok, view, html}}
  end

  @doc """
  Submit a form and follow its redirect.
  """
  defmacro submit_form(session, selector, attributes) do
    quote do
      {conn, {:ok, view, html}} = unquote(session)

      html =
        view
        |> form(unquote(selector), unquote(attributes))
        |> render_submit()

      handle_redirects(conn, view, html)
    end
  end

  ##########
  # Utility

  @doc """
  Simply rerender the LiveView. In some test, there are background events that
  trigger changes to the view, this functions provides a mechanism to render
  the view again after such an event in your test.
  """
  def rerender({conn, {:ok, view, _html}}) do
    html = render(view)
    {conn, {:ok, view, html}}
  end

  @doc """
  A small utility function that makes it easy to assert HTML as a string.

  Note: I am considering a sigil for this case. It requires more research.

  ## Example

      |> assert_visible("can&#39;t be blank")
      |> assert_visible(escape(can't be blank"))
  """
  def escape(html) do
    Plug.HTML.html_escape(html)
  end

  @doc """
  A utility function that makes it easy to open the current view up in a
  browser for visual debugging as you write your test. No more than a small
  wrapper over the open_browser/1 function you may already be familiar with.
  """
  def view_in_browser({_conn, {:ok, view, _html}} = session) do
    open_browser(view)
    session
  end
end
