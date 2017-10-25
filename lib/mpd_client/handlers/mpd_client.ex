defmodule MpdClient.Handlers.MpdClient do
  import Logger

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    Logger.debug "#{IO.inspect(state)}"
    {:ok, reply} = :cowboy_req.reply(
      200,
      [ {"content-type", "text/html"}],
      generate_body(),
      request)

    {:ok, reply, state}
  end

  def generate_body do
    Logger.debug "generate_body from " <> System.cwd! <> "/priv/templates/mpd_client.html.slime"
    # TODO: 例外時どうする？ => なんで例外が起こるの？
    {:ok, body} = File.read(System.cwd! <> "/priv/templates/mpd_client.html.slime")
    albuminfo =
      :util
      |> GenServer.call({:album_list})
      |> Enum.filter(fn(item) -> item.type == "directory" end)

    detail =
      albuminfo
      |> MpdClient.AlbumData.from_lsinfo()
      end)

    Slime.render(body, [site_title: "MPD Client test", albuminfo: detail])
  end

  def terminate(reason, request, state) do
    Logger.debug "Terminate for reason: #{inspect(reason)}"
    Logger.debug "Terminate after request: #{inspect(request)}"
    Logger.debug "Ternimating with state: #{inspect(state)}"
    :ok
  end
end

