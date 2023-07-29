defmodule RumblWeb.VideoChannel do
  alias Rumbl.{Accounts, MultiMedia}
  use RumblWeb, :channel
  alias RumblWeb.AnnotationView

  # on joining the topic videos of a certain video_id
  # we fetch the video and list its annotations json
  # the render_many function collects the render results for
  # all elements in the enumerable passed to it.
  # the view is used to present data thus offloading the work
  # to the view layer so the channel layer can focus on messaging
  def join("videos:" <> video_id, params, socket) do
    send(self(), :after_join)

    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = MultiMedia.get_video!(video_id)

    annotations =
      video
      |> MultiMedia.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(AnnotationView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  # handle_info receives OTP messages. It is invoked  whenever
  # an Elixir message reaches the channel
  #  ie its basically a loop, each time it returns the socket as the last tuple element
  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})

    {:noreply, assign(socket, :count, count + 1)}
  end

  # ensure all incoming events have the current user
  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  # handle in receives direct channel events/messages
  def handle_in("new_annotation", params, user, socket) do
    #
    case MultiMedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          user: RumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", RumblWeb.Presence.list(socket))
    {:ok, _} = RumblWeb.Presence.track(socket, socket.assigns.user_id, %{device: "browser"})
    {:noreply, socket}
  end
end
