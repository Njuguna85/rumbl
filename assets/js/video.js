import Player from "./player";

let Video = {
  init(socket, element) {
    if (!element) {
      return;
    }
    let playerId = element.getAttribute("data-player-id");
    let videoId = element.getAttribute("data-id");

    socket.connect();

    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket);
    });
  },

  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container");
    let msgInput = document.getElementById("msg-input");
    let postButton = document.getElementById("msg-submit");
    let vidChannel = socket.channel("videos:" + videoId);

    postButton.addEventListener("click", (e) => {
      let payload = { body: msgInput.value, at: Player.getCurrentTime() };
      vidChannel
        .push("new_annotation", payload)
        .receive("error", (e) => console.log(e));
      msgInput.value = "";
    });

    vidChannel.on("new_annotation", (resp) => {
      this.renderAnnotation(msgContainer, resp);
    });

    // Join the vidChannel
    vidChannel
      .join()
      .receive("ok", ({ annotations }) => {
        annotations.forEach((ann) => this.renderAnnotation(msgContainer, ann));
      })
      .receive("error", (resp) => {
        console.log("Unable to join", resp);
      });
  },

  renderAnnotation(msgContainer, { user, body, at }) {
    //  append annotation to msgContainer
    let template = document.createElement("div");
    template.innerHTML = `
    <a href="#" data-seek="${this.esc(at)}">
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    `;

    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },

  esc(str) {
    let div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  },
};

export default Video;
