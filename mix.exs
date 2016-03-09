defmodule Handlebars.Mixfile do
  use Mix.Project

  @version "1.0.0"

  def project do
    [app: :handlebars,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: description,
     package: package,
     deps: deps,
     version: @version,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp description do
    """
    This is an implementation of the Handlebars templating system for Elixir.
    """
  end

  defp package do
    [
      name: "odgn_handlebars",
      licenses: ["MIT"],
      maintainers: [ "Alexander Veenendaal" ],
      links: %{"GitHub" => "https://github.com/odogono/elixir-handlebars"},
      files: [ "lib", "src", "mix.exs", "README.md", "LICENSE"]
    ]
  end

end
