import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:1", {room_id: 1, object_id: 1,name: "socket"})

channel.join()
  .receive("ok", resp => { console.log("joined successfully", resp)})
  .receive("error", resp => {console.log("unable to join", resp)})


export default socket
