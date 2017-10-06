defmodule MpdClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mpd_client,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy],
      mod: {MpdClient, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:slime, "~> 1.0"},
      {:httpoison, "~> 0.13"},
    ]
  end
end
