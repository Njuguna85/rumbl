defmodule RumblWeb.WatchController do
  use RumblWeb, :controller

  alias Rumbl.MultiMedia

  def show(conn, %{"id" => id}) do
    video = MultiMedia.get_video!(id)
    render(conn, "show.html", video: video)
  end
end
