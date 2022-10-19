defmodule Iamvery.MixProject do
  use Mix.Project

  @description """
  """

  @package [
    files: ["lib", "mix.exs", "README"],
    maintainers: ["Jay Hayes"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/iamvery/iamvery-elixir"}
  ]

  def project do
    [
      app: :iamvery,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: @description,
      package: @package,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
