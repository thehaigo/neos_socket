defmodule NeosSocket.Repo do
  use Ecto.Repo,
    otp_app: :neos_socket,
    adapter: Ecto.Adapters.Postgres
end
