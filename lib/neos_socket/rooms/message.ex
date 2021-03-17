defmodule NeosSocket.Rooms.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :object_id, :id
    field :room_id, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :object_id, :room_id])
    |> validate_required([:body, :object_id, :room_id])
  end
end
