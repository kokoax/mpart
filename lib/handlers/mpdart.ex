defmodule Mpdart.Handlers.Mpdart do
  @moduledoc """
  Add document
  """
  import Logger

  alias Mpdart.AlbumData

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    Logger.debug fn -> "#{state}" end
    {:ok, reply} = :cowboy_req.reply(
      200,
      [{"content-type", "text/html"}],
      generate_body(),
      request)

    {:ok, reply, state}
  end

  def generate_body do
    Logger.debug fn -> "generate_body from " <> System.cwd! <> "/priv/templates/mpdart.html.slime" end
    {:ok, body} = File.read(System.cwd! <> "/priv/templates/mpdart.html.slime")
    host = Application.get_env(:mpdart, :redis_host)
    port = Application.get_env(:mpdart, :redis_port)
    {:ok, conn} = Redix.start_link(host: host, port: port)

    albumnames = Redix.command!(conn, ["KEYS", "Album:*"])

    Slime.render(body, [site_title: "MPD Client test", albumnames: albumnames, conn: conn])
  end

  def terminate(reason, request, state) do
    Logger.debug fn -> "Terminate for reason: #{inspect(reason)}" end
    Logger.debug fn -> "Terminate after request: #{inspect(request)}" end
    Logger.debug fn -> "Ternimating with state: #{inspect(state)}" end
    :ok
  end
end
