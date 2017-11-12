defmodule Mpdart.Middleware.Mpd.MpdData do
  @moduledoc """
  Add document
  """
  defstruct [:type, :data]

  alias Mpdart.Middleware.Mpd.MpdData

  def new(type, data) do
    %MpdData {
      type: type,
      data: data,
    }
  end
  def to_json(mpd_data) do
    mpd_data
    |> Enum.map(fn(data) ->
      {data.type, data.data}
    end)
    |> Map.new
    |> Poison.encode!
  end
  def get(mpd_data) do
    mpd_data.data
  end
end
