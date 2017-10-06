defmodule MpdClient.Util.CoverArtGetter do

  import Logger
  use GenServer

  def start_link(_) do
    Logger.debug "MpdClient.CoverArtGetter start_link"

    {:ok, pid} = GenServer.start_link(__MODULE__, [])

    Process.register(pid, :coverart)

    {:ok, pid}
  end

  def search_song(album) do
    api_token = Application.get_env(:mpd_client, :api_token)
    query = Regex.replace(~r(_+), album, " ")
    url = "http://ws.audioscrobbler.com/2.0/?method=album.search&album='#{query}'&api_key=#{api_token}&format=json"
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(url, [], [recv_timeout: :infinity])
    json = body |> Poison.decode!
      json["results"]["albummatches"]["album"]
      |> Enum.at(0)
      |> Map.get("image")
      |> Enum.filter(&(&1["size"] == "extralarge"))
      |> Enum.at(0)
      |> Map.get("#text")
  end

  def handle_call({:get_cover, album}, _from, state) do
    img_url = search_song(album)
    {:reply, img_url, state}
  end
end

