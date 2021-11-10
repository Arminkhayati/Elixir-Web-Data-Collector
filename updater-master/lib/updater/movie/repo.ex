defmodule Updater.Movie.Repo do
  use Ecto.Repo,
    otp_app: :updater,
    adapter: Ecto.Adapters.Postgres
end
