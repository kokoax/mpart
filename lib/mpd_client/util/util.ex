defmodule MpdClient.Util do
  import Logger

  # use Supervisor
  use GenServer

  def start_link(_) do
    Logger.debug "MpdClient.Util start_link"

    {:ok, pid} = GenServer.start_link(__MODULE__, [])

    Process.register pid, :mpd_client_util

    {:ok, pid}
  end

  def mpd_sock() do
     # TODO: domainとportを動的取得したい
    sock =
      case :gen_tcp.connect('localhost', 6600, [:binary, active: false]) do
        {:ok, sock} -> sock
        {:error, reson} -> raise("MPD Do not running. or connection is missing")
      end

    # TODO: RECVで使うバッファのサイズ指定 now(10^8)
    # IDEA: C++とかでやればよくね？
    # PROBLEM?: 恐らく1プロセスのメモリ量がかなり制限されていることが原因だと思われる
    :ok = :inet.setopts(sock, recbuf: 100000000)

    sock
  end

  # TODO: Utilを全部ラップ
  def handle_call({:current}, _from, _) do
    Logger.debug "Commnad current"
    res = MpdClient.Query.current(mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:database_list}, _from, _) do
    Logger.debug "Commnad database list"
    res = MpdClient.Query.database_list(mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:list_all, file_name}, _from, _) do
    Logger.debug "Commnad list all"
    res = MpdClient.Query.list_all(file_name, mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:ls, dir_name}, _from, _) do
    Logger.debug "Commnad ls"
    res = MpdClient.Query.ls(dir_name, mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:stats}, _from, _) do
    Logger.debug "Commnad stats"
    res = MpdClient.Query.stats(mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:status}, _from, _) do
    Logger.debug "Commnad status"
    res = MpdClient.Query.status(mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:list_all_info}, _from, _) do
    Logger.debug "Commnad list all info"
    res = MpdClient.Query.list_all_info(mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:find, type, query}, _from, _) do
    Logger.debug "Commnad find #{type} #{query}"
    res = MpdClient.Query.find(type, query, mpd_sock)
    {:reply, res, []}
  end

  # 以下は、既存のMPDコマンドをラップして使いやすかなぁみたいなのの実装
  def handle_call({:list_all_file}, _from, _) do
    Logger.debug "Commnad list all file"
    res = MpdClient.Query.list_all_file(mpd_sock)
    {:reply, res, []}
  end

  def handle_call({:list_all_dir}, _from, _) do
    Logger.debug "Commnad list all dir"
    res = MpdClient.Query.list_all_dir(mpd_sock)
    {:reply, res, []}
  end

  # TODO: album名取得はelixirで実装
  def handle_call({:album_list}, _from, _) do
    Logger.debug "Commnad album list"
    res = MpdClient.Query.album_list(mpd_sock)
    {:reply, res, []}
  end
end

