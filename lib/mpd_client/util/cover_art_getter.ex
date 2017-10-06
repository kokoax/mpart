defmodule MpdClient.CoverArtGetter do
  def start_link do
  end

  def handle_call({:get_cover_url, album_name}, _from, state) do
    resp = Process.get(:cover_path, album_name)
    {:reply, resp, state}
  end
end

