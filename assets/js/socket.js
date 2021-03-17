import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:1", {room_id: 1, object_id: 1,name: "socket"})

channel.join()
  .receive("ok", resp => { console.log("joined successfully", resp)})
  .receive("error", resp => {console.log("unable to join", resp)})

channel.on("broadcast_room", payload => {
  console.log("receive_room_broadcast", payload)
})

channel.on("send_broadcast_user", payload => {
  console.log("receive_user_broadcast", payload)
})


setTimeout(
  function () {
    channel.push("post", {body: "first", room_id: 1, object_id: 1})
      .receive("ok", (resp) => console.log("first post ok:", resp))
  },
  "1000"
);

setTimeout(
  function () {
    channel.push("broadcast", {body: "broadcast", room_id: 1, object_id: 1})
      .receive("ok", (resp) => console.log("broadcast send ok:", resp))
  },
  "1000"
);

export default socket
