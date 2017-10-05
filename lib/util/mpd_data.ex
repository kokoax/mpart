defmodule MpdClient.MpdData do
  defstruct [:type, :data]
  def new(type, data) do
    %MpdClient.MpdData {
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
    |> IO.inspect
    |> Poison.encode!
  end
end

