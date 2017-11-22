defmodule Mpdart.Middleware.Mpd.Util do
  @moduledoc """
  Add document
  """

  import Logger

  use GenServer

  alias Mpdart.Middleware.Mpd.Query

  def start_link(_) do
    Logger.debug fn -> "Mpdart.Middleware.Mpd.Util start" end

    {:ok, pid} = GenServer.start_link(__MODULE__, [])

    Process.register(pid, :util)

    {:ok, pid}
  end

  def mpd_sock do
    sock =
      case :gen_tcp.connect('localhost', 6600, [:binary, active: false]) do
        {:ok, sock} -> sock
        {:error, _reason} -> raise("MPD Do not running. or connection is missing")
      end

    :ok = :inet.setopts(sock, recbuf: 100_000_000)

    sock
  end

  def handle_call({:current}, _from, _) do
    Logger.debug fn -> "Commnad current" end
    res = Query.current(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:database_list}, _from, _) do
    Logger.debug fn -> "Commnad database list" end
    res = Query.database_list(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:list_all, file_name}, _from, _) do
    Logger.debug fn -> "Commnad list all" end
    res = Query.list_all(file_name, mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:ls, dir_name}, _from, _) do
    Logger.debug fn -> "Commnad ls" end
    res = Query.ls(dir_name, mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:stats}, _from, _) do
    Logger.debug fn -> "Commnad stats" end
    res = Query.stats(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:status}, _from, _) do
    Logger.debug fn -> "Commnad status" end
    res = Query.status(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:list_all_info}, _from, _) do
    Logger.debug fn -> "Commnad list all info" end
    res = Query.list_all_info(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:find, type, query}, _from, _) do
    Logger.debug fn -> "Commnad find #{type} #{query}" end
    res = Query.find(type, query, mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:add, query}, _from, _) do
    Logger.debug fn -> "Commnad add #{query}" end
    res = Query.add(query, mpd_sock())
    {:reply, res, []}
  end

  # 以下は、既存のMPDコマンドをラップして使いやすかなぁみたいなのの実装
  def handle_call({:list_all_file}, _from, _) do
    Logger.debug fn -> "Commnad list all file" end
    res = Query.list_all_file(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:list_all_dir}, _from, _) do
    Logger.debug fn -> "Commnad list all dir" end
    res = Query.list_all_dir(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:album_list}, _from, _) do
    Logger.debug fn -> "Commnad album list" end
    res = Query.album_list(mpd_sock())
    {:reply, res, []}
  end
end
