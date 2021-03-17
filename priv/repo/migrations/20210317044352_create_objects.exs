defmodule NeosSocket.Repo.Migrations.CreateObjects do
  use Ecto.Migration

  def change do
    create table(:objects) do
      add :name, :string
      add :object_id, :integer
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:objects, [:room_id])
  end
end
