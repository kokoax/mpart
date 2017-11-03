defmodule MpdClient.Util.UpdateDB do
  use GenServer
  import Logger
  @musicdir "/home/kokoax/Music/"

  def update_db do
    {:ok, conn} = Redix.start_link(host: "localhost", port: 6379)

    :util
    |> GenServer.call({:list_all, "/"})
    |> Enum.filter(&(&1.type == "file"))
    |> Enum.each(fn(path) ->
      {:ok, t} = (@musicdir <> path.data) |> Taglib.new()
      t |> store_data(path.data, conn)
    end)
  end

  def store_data(tag, path, conn) do
    [
      fn(tag) -> {path <> ":album",       tag |> Taglib.album()} end,
      fn(tag) -> {path <> ":artist",      tag |> Taglib.artist()} end,
      fn(tag) -> {path <> ":compilation", tag |> Taglib.compilation()} end,
      fn(tag) -> {path <> ":disc",        tag |> Taglib.disc()} end,
      fn(tag) -> {path <> ":duration",    tag |> Taglib.duration()} end,
      fn(tag) -> {path <> ":genre",       tag |> Taglib.genre()} end,
      fn(tag) -> {path <> ":title",       tag |> Taglib.title()} end,
      fn(tag) -> {path <> ":track",       tag |> Taglib.track()} end,
      fn(tag) -> {path <> ":year",        tag |> Taglib.year()} end,
    ] |> Enum.each(fn(func) ->
      Task.async(fn ->
        {id, key} = tag |> func.()
        conn |> Redix.command(["SET", id, key])
      end)
    end)
    :ok
  end
end
