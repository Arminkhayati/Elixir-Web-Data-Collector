defmodule Collector.Repo do
  use Ecto.Repo,
    otp_app: :artist,
    adapter: Ecto.Adapters.Postgres
end
