defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, socket}
    # {:ok, assign(socket, :video_id, String.to_integer(video_id))}
  end

  # handle_info receives OTP messages. It is invoked  whenever
  # an Elixir message reaches the channel
  #  ie its basically a loop, each time it returns the socket as the last tuple element
  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})

    {:noreply, assign(socket, :count, count + 1)}
  end

  # handle in receives direct channel events/messages
  def handle_in("new_annotation", params, socket) do
    # simply broadcast the event to all clients n the topic
    broadcast!(socket, "new_annotation", %{
      user: %{username: "annon"},
      body: params["body"],
      at: params["at"]
    })

    {:reply, :ok, socket}
  end
end
