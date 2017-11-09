defmodule MpdClient.Handlers.Javascript do
  @moduledoc """
  This module is javascript handler from /priv/static/js/:javascript
  """
  import Logger

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    # Logger.debug fn -> "#{IO.inspect(state)}" end

    method = request |> :cowboy_req.method |> elem(0)
    param = :javascript |> :cowboy_req.binding(request) |> elem(0)
    {:ok, reply} = html_example(method, param, request)
    {:ok, reply, state}
  end

  def html_example("GET", :undefined, req) do
    headers = {"content-type", "text/javascript"}
    body = ""
    :cowboy_req.reply(404, [headers], body, req)
  end

  def html_example("GET", param, req) do
    headers = {"content-type", "text/javascript"}
    {:ok, body} = File.read System.cwd! <> "/priv/static/js/#{param}"
    :cowboy_req.reply(200, [headers], body, req)
  end

  def terminate(reason, request, state) do
    Logger.debug "terminate MpdClient.Handlers.Javascript"
    Logger.debug fn -> "Terminate for reason: #{inspect(reason)}" end
    Logger.debug fn -> "Terminate after request: #{inspect(request)}" end
    Logger.debug fn -> "Ternimating with state: #{inspect(state)}" end
    :ok
  end
end
