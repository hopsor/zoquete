defmodule ZoqueteWeb.RoomChannel do
  use ZoqueteWeb, :channel

  def join("room:lobby", _payload, socket) do
    {:ok, %{welcome_message: "Benvingut"}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("message", payload, socket) do
    IO.inspect(payload)
    {:noreply, socket}
  end
end
