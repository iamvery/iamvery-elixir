# Iamvery Elixir

[![Build Status](https://github.com/iamvery/iamvery-elixir/actions/workflows/ci.yml/badge.svg)](https://github.com/iamvery/iamvery-elixir/actions/workflows/ci.yml) [![Hex.pm](https://img.shields.io/hexpm/v/iamvery.svg)](https://hex.pm/packages/iamvery)

A set of Elixir utilities for myself and others.
Using this Hex package as a test bed for ideas that may be eventually spun off as separate projects or open source contributions.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `iamvery` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:iamvery, "~> 0.8.1", only: :test}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/iamvery>.

## Phoenix LiveView Test Helpers

I've put together a set of test helper functions for testing Phoenix LiveView.
For more details on this pattern, see the [blog post][live-view-helpers-blog].

As a quick example, the helpers let you go from:

```elixir
import Phoenix.LiveViewTest

test "live view", %{conn: conn} do
  {:ok, live, html} = live(conn, "/")
  assert html =~ "New"
  assert live |> element("a.new") |> render_click() =~ "Enter new"
  assert_patch(live, "/new")
  {:ok, _, html} = live |> form(".form", @attrs) |> render_submit() |> follow_redirect(conn)
  assert html =~ "success"
end
```

To:

```elixir
use Iamvery.Phoenix.LiveView.TestHelpers

test "live view", %{conn: conn} do
  start(conn, "/")
  |> assert_html("New")
  |> click("a.new")
  |> assert_html("Enter new")
  |> assert_path("/new")
  |> submit_form(".form", @attrs)
  |> assert_html("success")
end
```

## Copyright and License

Copyright (c) 2022, Jay Hayes.

Source code is licensed under the [MIT License](LICENSE.md).


[live-view-helpers-blog]: https://iamvery.com/2022/10/19/better-live-view-tests.html
