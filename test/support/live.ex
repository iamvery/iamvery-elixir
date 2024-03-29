defmodule Test.Support.Live do
  use Phoenix.LiveView

  @impl true
  def render(assigns) do
    ~H"""
    <html>
      <a class="home" phx-click="home">Home</a>
      <span id="link-1"><a phx-click="link-1">Edit Link</a></span>
      <div class="lolwat">yes</div>
      <form id="widget-form" phx-change="changed" phx-submit="submitted">
        can't be blank
        <textarea name="widget[lol]" />
        Link updated successfully
      </form>
    </html>
    """
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("link-1", _params, socket) do
    socket = push_patch(socket, to: "/")
    {:noreply, socket}
  end

  @impl true
  def handle_event("changed", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("submitted", _params, socket) do
    socket = push_navigate(socket, to: "/")
    {:noreply, socket}
  end

  @impl true
  def handle_event("home", _params, socket) do
    socket = push_navigate(socket, to: "/")
    {:noreply, socket}
  end
end
