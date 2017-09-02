defmodule MpdClient.MpdData do
  defstruct [:type, :data]
  def new(type, data) do
    %MpdClient.MpdData {
      type: type,
      data: data,
    }
  end
end

