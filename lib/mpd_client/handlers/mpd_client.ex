defmodule MpdClient.Handlers.MpdClient do
  @moduledoc """
  Add document
  """
  import Logger

  alias MpdClient.AlbumData

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
    Logger.debug fn -> "generate_body from " <> System.cwd! <> "/priv/templates/mpd_client.html.slime" end
    {:ok, body} = File.read(System.cwd! <> "/priv/templates/mpd_client.html.slime")
    host = Application.get_env(:mpd_client, :redis_host)
    port = Application.get_env(:mpd_client, :redis_port)
    {:ok, conn} = Redix.start_link(host: host, port: port)

    albumnames =
      :util
      |> GenServer.call({:album_list})
      |> Enum.map(&(&1.data))

    Slime.render(body, [site_title: "MPD Client test", albumnames: albumnames, conn: conn])
  end

  def terminate(reason, request, state) do
    Logger.debug fn -> "Terminate for reason: #{inspect(reason)}" end
    Logger.debug fn -> "Terminate after request: #{inspect(request)}" end
    Logger.debug fn -> "Ternimating with state: #{inspect(state)}" end
    :ok
  end
end
