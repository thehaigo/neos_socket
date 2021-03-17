defmodule NeosSocketWeb.RoomLive.Show do
  use NeosSocketWeb, :live_view

  alias NeosSocket.Rooms
  alias NeosSocket.Rooms.Message
  alias NeosSocketWeb.Presence

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    obj_id = 9999
    room = Rooms.get_room!(id)
    changeset = Rooms.change_message(%Message{object_id: obj_id, room_id: id})
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
      |> assign(:changeset, changeset)
      |> assign(:users, Presence.list_presence("room:#{id}"))
    }
  end

  @impl true
  def handle_event("send", %{"message" => message_params}, socket) do
    message = Rooms.create_message(message_params).changes
    type = if message.object_id == 0, do: "room", else: "user"
    topic = if message.object_id == 0 do
              "#{type}:#{message.room_id}"
            else
              "#{type}:#{message.object_id}"
            end

    NeosWeb.Endpoint.broadcast!(
      topic,
      "broadcast_#{type}",
      message
    )
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{room: room}}) do
    {:noreply, assign(socket, users: Presence.list_presence("room:#{room.id}"))}
  end
end
