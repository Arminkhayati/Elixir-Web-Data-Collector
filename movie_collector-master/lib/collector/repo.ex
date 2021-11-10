defmodule Collector.Repo do
  use Ecto.Repo,
    otp_app: :new_collector,
    adapter: Ecto.Adapters.Postgres
end
