defmodule Iamvery.Phoenix.LiveView.TestHelpers do
  defmacro __using__([]) do
    quote do
      import Phoenix.LiveViewTest

      ########
      # Entry

      def start(conn, path) do
        {conn, live(conn, path)}
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

      def assert_visible({conn, {:ok, view, html}}, expected_html) do
        assert html =~ expected_html
        {conn, {:ok, view, html}}
      end

      def refute_visible({conn, {:ok, view, html}}, unexpected_html) do
        refute html =~ unexpected_html
        {conn, {:ok, view, html}}
      end

      def assert_visible({conn, {:ok, view, html}}, selector, expected_html) do
        element_html = element(view, selector) |> render()
        assert element_html =~ expected_html
        {conn, {:ok, view, html}}
      end

      def refute_visible({conn, {:ok, view, html}}, selector, unexpected_html) do
        element_html = element(view, selector) |> render()
        refute element_html =~ unexpected_html
        {conn, {:ok, view, html}}
      end

      def assert_element({conn, {:ok, view, html}}, selector, text \\ nil) do
        assert has_element?(view, selector, text)
        {conn, {:ok, view, html}}
      end

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

      def click({conn, {:ok, view, _html}}, selector, text \\ nil) do
        result = element(view, selector, text) |> render_click()
        handle_redirects(conn, view, result)
      end

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

      def change_form({conn, {:ok, view, _html}}, selector, attributes) do
        html =
          view
          |> form(selector, attributes)
          |> render_change()

        {conn, {:ok, view, html}}
      end

      def submit_form({conn, {:ok, view, _html}}, selector, attributes) do
        html =
          view
          |> form(selector, attributes)
          |> render_submit()

        {conn, follow_redirect(html, conn)}
      end

      ##########
      # Utility

      def rerender({conn, {:ok, view, _html}}) do
        html = render(view)
        {conn, {:ok, view, html}}
      end

      def escape(html) do
        Plug.HTML.html_escape(html)
      end

      def view_in_browser({_conn, {:ok, view, _html}} = session) do
        open_browser(view)
        session
      end
    end
  end
end
