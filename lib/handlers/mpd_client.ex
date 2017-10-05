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
      GenServer.call(:mpd_client_util, {:album_list})
      |> Enum.filter(fn(item) -> item.type == "directory" end)

    albumimg =
      albuminfo
      |> Enum.map(fn(_info) -> "/priv/static/images/cat.png" end)

    albumname =
      albuminfo
      |> Enum.map(fn(info) ->
        info.data |> Path.basename
      end)

    albumsong =
      albuminfo
      |> Enum.map(fn(info) ->
        GenServer.call(:mpd_client_util, {:ls, info.data})
        |> Enum.filter(&(&1.type == "Title"))
        |> Enum.map(&(&1.data))
      end)

    Slime.render(body, [site_title: "MPD Client test", albumname: albumname, albumimg: albumimg, albumsong: albumsong])
  end

  def terminate(reason, request, state) do
    Logger.debug "Terminate for reason: #{inspect(reason)}"
    Logger.debug "Terminate after request: #{inspect(request)}"
    Logger.debug "Ternimating with state: #{inspect(state)}"
    :ok
  end
end

