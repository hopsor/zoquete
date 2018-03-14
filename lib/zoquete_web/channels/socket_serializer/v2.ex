defmodule ZoqueteWeb.SocketSerializer.V2 do
  @moduledoc false

  @behaviour Phoenix.Transports.Serializer

  alias Phoenix.Socket.{Reply, Message, Broadcast}
  alias Accent.Transformer

  @doc """
  Translates a `Phoenix.Socket.Broadcast` into a `Phoenix.Socket.Message`.
  """
  def fastlane!(%Broadcast{} = msg) do
    data = Poison.encode_to_iodata!([nil, nil, msg.topic, msg.event, msg.payload])
    {:socket_push, :text, data}
  end

  @doc """
  Encodes a `Phoenix.Socket.Message` struct to JSON string.
  """
  def encode!(%Reply{} = reply) do
    data = [
      reply.join_ref,
      reply.ref,
      reply.topic,
      "phx_reply",
      %{
        status: reply.status,
        response: Transformer.transform(reply.payload, Transformer.PascalCase)
      }
    ]

    {:socket_push, :text, Poison.encode_to_iodata!(data)}
  end

  def encode!(%Message{} = msg) do
    data = [
      msg.join_ref,
      msg.ref,
      msg.topic,
      msg.event,
      Transformer.transform(msg.payload, Transformer.PascalCase)
    ]

    {:socket_push, :text, Poison.encode_to_iodata!(data)}
  end

  @doc """
  Decodes JSON String into `Phoenix.Socket.Message` struct.
  """
  def decode!(raw_message, _opts) do
    [join_ref, ref, topic, event, payload | _] = Poison.decode!(raw_message)

    %Phoenix.Socket.Message{
      topic: topic,
      event: event,
      payload: Transformer.transform(payload, Transformer.SnakeCase),
      ref: ref,
      join_ref: join_ref
    }
  end
end
