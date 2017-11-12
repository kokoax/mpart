defmodule Mpdart.API.Mpd.Add do
  @moduledoc """
  Add document
  """

  import Logger

  alias Mpdart.Middleware.Mpd.MpdData

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    Logger.debug fn -> "#{state}" end
    method = request |> :cowboy_req.method() |> elem(0)
    {:ok, params, _req} = request |> :cowboy_req.body_qs()

    {:ok, reply} = :cowboy_req.reply(
      200,
      [{"content-type", "text/json"}],
      generate_body(method, params),
      request)


    {:ok, reply, state}
  end

  def generate_body("POST", [{"query", query}]) do
    Logger.debug fn -> "generate_body from MPD's Add #{query}" end

    :util |> GenServer.call({:add, query}) |> MpdData.to_json
  end

  def terminate(reason, request, state) do
    Logger.debug fn -> "Terminate Mpdart.API.Mpd.Add" end
    Logger.debug fn -> "Terminate for reason: #{inspect(reason)}" end
    Logger.debug fn -> "Terminate after request: #{inspect(request)}" end
    Logger.debug fn -> "Ternimating with state: #{inspect(state)}" end
    :ok
  end
end
