defmodule MpdClient.Util.Commands do
  @moduledoc """
  TODO: Add document
  """

  import Logger

  use GenServer

  alias MpdClient.Util.Query

  def start_link(_) do
    Logger.debug "start_link"

    {:ok, pid} = GenServer.start_link(__MODULE__, [])

    Process.register(pid, :util)

    {:ok, pid}
  end

  def mpd_sock do
     # TODO: domainとportを動的取得したい
    sock =
      case :gen_tcp.connect('localhost', 6600, [:binary, active: false]) do
        {:ok, sock} -> sock
        {:error, _reason} -> raise("MPD Do not running. or connection is missing")
      end

    # TODO: RECVで使うバッファのサイズ指定 now(10^8)
    # IDEA: C++とかでやればよくね？
    # PROBLEM?: 恐らく1プロセスのメモリ量がかなり制限されていることが原因だと思われる
    :ok = :inet.setopts(sock, recbuf: 100_000_000)

    sock
  end

  # TODO: Utilを全部ラップ
  def handle_call({:current}, _from, _) do
    Logger.debug "Commnad current"
    res = Query.current(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:database_list}, _from, _) do
    Logger.debug "Commnad database list"
    res = Query.database_list(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:list_all, file_name}, _from, _) do
    Logger.debug "Commnad list all"
    res = Query.list_all(file_name, mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:ls, dir_name}, _from, _) do
    Logger.debug "Commnad ls"
    res = Query.ls(dir_name, mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:stats}, _from, _) do
    Logger.debug "Commnad stats"
    res = Query.stats(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:status}, _from, _) do
    Logger.debug "Commnad status"
    res = Query.status(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:list_all_info}, _from, _) do
    Logger.debug "Commnad list all info"
    res = Query.list_all_info(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:find, type, query}, _from, _) do
    res = Query.find(type, query, mpd_sock())
    Logger.debug "Commnad find #{type} #{query}"
    {:reply, res, []}
  end

  # 以下は、既存のMPDコマンドをラップして使いやすかなぁみたいなのの実装
  def handle_call({:list_all_file}, _from, _) do
    Logger.debug "Commnad list all file"
    res = Query.list_all_file(mpd_sock())
    {:reply, res, []}
  end

  def handle_call({:list_all_dir}, _from, _) do
    Logger.debug "Commnad list all dir"
    res = Query.list_all_dir(mpd_sock())
    {:reply, res, []}
  end

  # TODO: album名取得はelixirで実装
  def handle_call({:album_list}, _from, _) do
    Logger.debug "Commnad album list"
    res = Query.album_list(mpd_sock())
    {:reply, res, []}
  end
end
