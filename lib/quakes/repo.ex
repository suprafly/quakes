defmodule Quakes.Repo do
  use Ecto.Repo,
    otp_app: :quakes,
    adapter: Ecto.Adapters.Postgres
end
