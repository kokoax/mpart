defmodule MpdClient.Util.UpdateDB do
  @moduledoc """
  The module update music data on Redis, from music directory.
  """
  use GenServer
  import Logger

  def update_db do
    host = Application.get_env(:mpd_client, :redis_host)
    port = Application.get_env(:mpd_client, :redis_port)
    {:ok, conn} = Redix.start_link(host: host, port: port)

    :util
    |> GenServer.call({:list_all, "/"})
    |> Enum.filter(&(&1.type == "file"))
    |> Enum.each(fn(path) ->
      {:ok, t} =
        (Application.get_env(:mpd_client, :musicdir) <> path.data)
        |> Taglib.new()
      t |> store_data(path.data, conn)
    end)
  end

  def store_data(tag, path, conn) do
    path = ["Song:", path] |> Enum.join()

    album = tag |> Taglib.album()
    artist = tag |> Taglib.artist()
    album_key = ["Album:", album, ":", artist] |> Enum.join()

    conn |> Redix.command(["HSET", album_key, "album", album])
    conn |> Redix.command(["HSET", path, "album", album])
    conn |> Redix.command(["HSET", album_key, "artist", artist])
    conn |> Redix.command(["HSET", path, "artist", artist])

    conn |> Redix.command(["HSET", album_key, "coverart", "/priv/static/images/no_image.png"])
    conn |> Redix.command(["SADD", [album_key, ":", "songs"] |> Enum.join(), path])

    [
      fn(tag) -> {"compilation", tag |> Taglib.compilation()} end,
      fn(tag) -> {"disc",        tag |> Taglib.disc()} end,
      fn(tag) -> {"duration",    tag |> Taglib.duration()} end,
      fn(tag) -> {"genre",       tag |> Taglib.genre()} end,
      fn(tag) -> {"title",       tag |> Taglib.title()} end,
      fn(tag) -> {"track",       tag |> Taglib.track()} end,
      fn(tag) -> {"year",        tag |> Taglib.year()} end,
    ] |> Enum.each(fn(func) ->
      Task.async(fn ->
        {id, key} = tag |> func.()
        conn |> Redix.command(["HSET", path, id, key])
      end)
    end)
    :ok
  end
end
