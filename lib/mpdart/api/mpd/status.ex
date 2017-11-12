defmodule Mpdart.Handlers.Status do
  @moduledoc """
  Add document
  """

  import Logger

  alias Mpdart.MpdData

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    Logger.debug fn -> "#{state}" end
    {:ok, reply} = :cowboy_req.reply(
      200,
      [{"content-type", "text/json"}],
      generate_body(),
      request)

    {:ok, reply, state}
  end

  def generate_body do
    Logger.debug "generate_body from MPD's status"

    :mpdart_util |> GenServer.call({:status}) |> MpdData.to_json
  end

  def terminate(reason, request, state) do
    Logger.debug fn -> "Terminate for reason: #{inspect(reason)}" end
    Logger.debug fn -> "Terminate after request: #{inspect(request)}" end
    Logger.debug fn -> "Ternimating with state: #{inspect(state)}" end
    :ok
  end
end
