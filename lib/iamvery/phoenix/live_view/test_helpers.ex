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

      def assert_html({conn, {:ok, view, html}}, expected_html) do
        assert html =~ expected_html
        {conn, {:ok, view, html}}
      end

      def refute_html({conn, {:ok, view, html}}, unexpected_html) do
        refute html =~ unexpected_html
        {conn, {:ok, view, html}}
      end

      def assert_visible(session, expected), do: assert_html(session, expected)
      def refute_visible(session, expected), do: refute_html(session, expected)

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
        assert_patch(view, path)
        {conn, {:ok, view, html}}
      end

      ###############
      # Interactions

      def click({conn, {:ok, view, _html}}, selector, text \\ nil) do
        html =
          view
          |> element(selector, text)
          |> render_click()

        {conn, {:ok, view, html}}
      end

      def follow(session, selector, text \\ nil) do
        {conn, {:ok, _view, html}} = click(session, selector, text)
        {conn, follow_redirect(html, conn)}
      end

      def follow({conn, redirect}) do
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
