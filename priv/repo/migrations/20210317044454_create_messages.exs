defmodule NeosSocket.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :object_id, references(:objects, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:object_id])
    create index(:messages, [:room_id])
  end
end
