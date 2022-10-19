defmodule Iamvery.Phoenix.LiveView.TestHelpers do
  defmacro __using__([]) do
    quote do
      import Phoenix.LiveViewTest

      def start(conn, path) do
        {conn, live(conn, path)}
      end

      def escape(html) do
        Plug.HTML.html_escape(html)
      end

      def rerender({conn, {:ok, view, _html}}) do
        html = render(view)
        {conn, {:ok, view, html}}
      end

      def assert_html({conn, {:ok, view, html}}, expected_html) do
        assert html =~ expected_html
        {conn, {:ok, view, html}}
      end

      def refute_html({conn, {:ok, view, html}}, unexpected_html) do
        refute html =~ unexpected_html
        {conn, {:ok, view, html}}
      end

      def assert_path({conn, {:ok, view, html}}, path) do
        assert_patch(view, path)
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

      def click({conn, {:ok, view, _html}}, selector, text \\ nil, opts \\ []) do
        html =
          view
          |> element(selector, text)
          |> render_click()

        if Keyword.get(opts, :follow, false) do
          {conn, follow_redirect(html, conn)}
        else
          {conn, {:ok, view, html}}
        end
      end

      def follow(session, selector, text \\ nil) do
        {conn, {:ok, _view, html}} = click(session, selector, text)
        {conn, follow_redirect(html, conn)}
      end

      def change_form({conn, {:ok, view, _html}}, selector, attributes) do
        html =
          view
          |> form(selector, attributes)
          |> render_change()

        {conn, {:ok, view, html}}
      end

      def submit_form({conn, {:ok, view, _html}}, selector, attributes, opts \\ []) do
        html =
          view
          |> form(selector, attributes)
          |> render_submit()

        if Keyword.get(opts, :follow, true) do
          {conn, follow_redirect(html, conn)}
        else
          {conn, {:ok, view, html}}
        end
      end
    end
  end
end
