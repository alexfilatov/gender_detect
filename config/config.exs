# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :gender_detect, ecto_repos: [GenderDetect.Repo]

config :gender_detect, GenderDetect.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "syft2_dev",
  username: "syft",
  password: "syftpass",
  hostname: "localhost",
  port: "5432"
