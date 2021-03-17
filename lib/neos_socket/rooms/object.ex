defmodule NeosSocket.Rooms.Object do
  use Ecto.Schema
  import Ecto.Changeset

  schema "objects" do
    field :name, :string
    field :object_id, :integer
    field :room_id, :id

    timestamps()
  end

  @doc false
  def changeset(object, attrs) do
    object
    |> cast(attrs, [:name, :object_id, :room_id])
    |> validate_required([:name, :object_id, :room_id])
  end
end
