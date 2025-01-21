defmodule S2Azure.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :s2_azure,
      version:         "0.1.1",
      elixir:          "~> 1.18 ",
      description:     "Azure wrapper for Elixir using :erlazure",
      package:         package(),
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps(),
    ]
  end

  def application do
    [applications: [:erlazure],
     mod: {S2Azure, []}]
  end

  defp deps do
    [
      {:erlazure, github: "gullitmiranda/erlazure", manager: :rebar},
      {:ex_doc  , "~> 0.11.5", only: [:dev, :test]},
      {:earmark , "~> 0.2.1" , only: [:dev, :test]},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Gullit Miranda <gullitmiranda@gmail.com>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/gullitmiranda/s2_azure",
        "Docs"   => "https://hexdocs.pm/s2_azure",
      }
    ]
  end
end
