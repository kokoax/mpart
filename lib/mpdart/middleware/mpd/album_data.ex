defmodule Mpdart.AlbumData do
  @moduledoc """
  The module is struct of album data from command of MPD.
  """
  defstruct [:songs, :album, :albumartist, :dirname, :image]
  import Logger

  alias Mpdart.Util.Commands
  alias Mpdart.MpdData
  alias Mpdart.SongData
  alias Mpdart.AlbumData

  def from_lsinfo(lsinfo) do
    Logger.debug "Mpdart.AlbumData from_lsinfo"
    %AlbumData {
      songs: lsinfo |> get_songs(),
      album: lsinfo |> get_album(),
      albumartist: lsinfo |> get_albumartist(),
      dirname:   lsinfo |> get_dirname(),
      image: lsinfo |> get_image()
    }
  end

  defp get_title(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_title"
    lsinfo
    |> Enum.filter(&(&1.type == "Title"))
    |> case do
      [] -> nil
      other -> other
    end
  end

  defp get_file(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_file"
    lsinfo
    |> Enum.filter(&(&1.type == "file"))
    |> case do
      [] -> nil
      other -> other
    end
  end

  defp get_time(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_time"
    lsinfo
    |> Enum.filter(&(&1.type == "Time"))
    |> case do
      [] -> nil
      other -> other
    end
  end

  defp get_duration(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_duration"
    lsinfo
    |> Enum.filter(&(&1.type == "duration"))
    |> case do
      [] -> nil
      other -> other
    end
  end

  defp get_one(elm) do
    elm
    |> case do
      nil -> nil
      other -> other |> Enum.at(0)
    end
  end

  defp get_songs(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_songs"
    lsinfo
    |> get_file
    |> Enum.map(fn(file) ->
      # Task.async(fn -> GenServer.call(:util, {:ls, file.data}) end)
      Query.ls(file.data, Commands.mpd_sock())
    end)
    # |> Enum.map(&(&1 |> Task.await))
    |> Enum.map(fn(songinfo) ->
      SongData.new(
        songinfo |> get_title    |> get_one,
        songinfo |> get_file     |> get_one,
        songinfo |> get_time     |> get_one,
        songinfo |> get_duration |> get_one
      )
    end)
  end

  defp get_album(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_album"
    lsinfo
    |> Enum.filter(&(&1.type == "Album"))
    |> Enum.uniq
    |> Enum.at(0)
  end

  defp get_albumartist(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_albumartist"
    lsinfo |> Enum.filter(&(&1.type == "AlbumArtist"))
    |> case do
      [] ->
        artist =
          lsinfo
          |> Enum.filter(&(&1.type == "Artist"))
          |> Enum.uniq
        if artist |> Enum.count == 1 do
          artist |> Enum.at(0)
        else
          %MpdData {
            type: "Artist",
            data: "Various"
          }
        end
      albumartist -> albumartist |> Enum.uniq |> Enum.at(0)
    end
  end

  defp get_dirname(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_dirname"
    lsinfo
    |> Enum.filter(&(&1.type == "file"))
    |> Enum.at(0)
    |> MpdData.get
    |> Path.dirname
    |> Path.basename
  end

  defp get_image(lsinfo) do
    Logger.debug "Mpdart.AlbumData get_image"
    "/priv/static/images/cat.png"
  end
end

defmodule Mpdart.SongData do
  @moduledoc """
  The module is struct of specific music data.
  """

  defstruct [:title, :file, :time, :duration]

  alias Mpdart.SongData

  def new(title, file, time, duration) do
    %SongData {
      title: title,
      file: file,
      time: time,
      duration: duration,
    }
  end
end
