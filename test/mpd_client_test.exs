defmodule MpdClientTest do
  use ExUnit.Case
  doctest MpdClient

  test "NoSQL update test" do
    alias MpdClient.Util.UpdateDB

    host = Application.get_env(:mpd_client, :redis_host)
    port = Application.get_env(:mpd_client, :redis_port)
    {:ok, conn} = Redix.start_link(host: host, port: port)
    path = System.cwd! <> "/test/morning.mp3"

    {:ok, tag} = path |> Taglib.new()
    tag |> UpdateDB.store_data(path, conn)

    album = tag |> Taglib.album()
    artist = tag |> Taglib.artist()

    album_key = ["Album:", album, ":", artist] |> Enum.join()

    path = ["Song:", path] |> Enum.join()

    assert "sample" == conn |> Redix.command!(["HGET", album_key, "album"])
    assert "sharou" == conn |> Redix.command!(["HGET", album_key, "artist"])
    assert "/priv/static/images/no_image.png" == conn |> Redix.command!(["HGET", album_key, "coverart"])
    assert [path] == conn |> Redix.command!(["SMEMBERS", [album_key, ":", "songs"] |> Enum.join()])
    assert "sample" == conn |> Redix.command!(["HGET", path, "album"])
    assert "sharou" == conn |> Redix.command!(["HGET", path, "artist"])
    assert "true" == conn |> Redix.command!(["HGET", path, "compilation"])
    assert "1" == conn |> Redix.command!(["HGET", path, "disc"])
    assert "165" == conn |> Redix.command!(["HGET", path, "duration"])
    assert "Rock" == conn |> Redix.command!(["HGET", path, "genre"])
    assert "morning" == conn |> Redix.command!(["HGET", path, "title"])
    assert "2" == conn |> Redix.command!(["HGET", path, "track"])
    assert "2000" == conn |> Redix.command!(["HGET", path, "year"])
  end
end
