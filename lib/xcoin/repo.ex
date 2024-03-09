defmodule Xcoin.Repo do
  use Ecto.Repo,
    otp_app: :xcoin,
    adapter: Ecto.Adapters.Postgres
end
