defmodule MpdClient.Handlers.MpdClient do
  @moduledoc """
  TODO: Add document
  """
  import Logger

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    Logger.debug "#{state}"
    {:ok, reply} = :cowboy_req.reply(
      200,
      [{"content-type", "text/html"}],
      generate_body(),
      request)

    {:ok, reply, state}
  end

  def generate_body do
    Logger.debug "generate_body from " <> System.cwd! <> "/priv/templates/mpd_client.html.slime"
    {:ok, body} = File.read(System.cwd! <> "/priv/templates/mpd_client.html.slime")
    albuminfo =
      :util
      |> GenServer.call({:album_list})
      |> Enum.filter(fn(item) -> item.type == "directory" end)

    albumimg =
      albuminfo
      |> Enum.map(fn(_info) -> "/priv/static/images/cat.png" end)

    albumname =
      albuminfo
      |> Enum.map(fn(info) ->
        info.data |> Path.basename
        |> String.replace(" ", "_")
        |> String.replace("!", "_")
        |> String.replace("?", "_")
        |> String.replace("[", "_")
        |> String.replace("]", "_")
      end)

    albumsong =
      albuminfo
      |> Enum.map(fn(info) ->
        :util
        |> GenServer.call({:ls, info.data})
        |> Enum.filter(&(&1.type == "Title"))
        |> Enum.map(&(&1.data))
      end)

    Slime.render(
      body,
      [
        site_title: "MPD Client test",
        albumname: albumname,
        albumimg: albumimg,
        albumsong: albumsong
      ]
    )
  end

  def terminate(reason, request, state) do
    Logger.debug "Terminate for reason: #{inspect(reason)}"
    Logger.debug "Terminate after request: #{inspect(request)}"
    Logger.debug "Ternimating with state: #{inspect(state)}"
    :ok
  end
end
