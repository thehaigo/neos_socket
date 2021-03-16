defmodule NeosSocketWeb.RoomChannel do
  use Phoenix.Channel
  alias NeosSocket.Rooms
  alias NeosSocketWeb.Presence

  @impl true
  def join(topic, payload, socket) do
    room_id = payload["room_id"]
    case Rooms.get_room(room_id) do
      nil ->
        {:error, "room not found"}
      _room ->
        object_id = payload["object_id"]
        Presence.track_presence(
          self(),
          "room:#{room_id}",
          object_id,
          %{ id: object_id, name: payload["name"]}
        )

        {
          :ok,
          Presence.list_presence("room:#{room_id}"),
          socket
          |> assign(:room_id, room_id)
          |> assign(:users, Presence.list_presence("room:#{room_id}"))
        }
    end
  end

  @impl
  def handle_info(%{event: "presence_diff"}, socket = %{ assigns: %{room_id: room_id } }) do
    {:noreply, assign(socket, users: Presence.list_presence("room:#{room_id}"))}
  end
end
