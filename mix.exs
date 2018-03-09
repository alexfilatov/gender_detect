defmodule GenderDetect.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gender_detect,
      version: "0.1.0",
      elixir: "~> 1.6.2",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {GenderDetect, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_csv, "~> 0.4"},
      {:remix, only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end
end
