defmodule NeosSocketWeb.RoomLive.Show do
  use NeosSocketWeb, :live_view

  alias NeosSocket.Rooms
  alias NeosSocketWeb.Presence

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    obj_id = 9999
    room = Rooms.get_room!(id)
    NeosSocketWeb.Endpoint.subscribe("room:#{id}")
    Presence.track_presence(
      self(),
      "room:#{id}",
      obj_id,
      %{ name: "liveview", id: obj_id}
    )

    {
      :ok,
      socket
      |> assign(:page_title, "Room")
      |> assign(:room, room)
      |> assign(:object_id, obj_id)
      |> assign(:users, Presence.list_presence("room:#{id}"))
    }
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{room: room}}) do
    {:noreply, assign(socket, users: Presence.list_presence("room:#{room.id}"))}
  end  
end
