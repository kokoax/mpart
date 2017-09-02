defmodule MpdClient.Util do
  import Logger

  # use Supervisor
  use GenServer

  def start_link(_) do
    Logger.debug "MpdClient.Util start_link"

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

    # {:ok, pid} = Supervisor.start_link(__MODULE__, [sock], name: __MODULE__)
    # GenServer.start_link(__MODULE__, [sock], name: __MODULE__)
    {:ok, pid} = GenServer.start_link(__MODULE__, sock)
    # {:ok, pid} = GenServer.start_link(__MODULE__, sock)
    Process.register pid, :mpd_client_util
    {:ok, pid}
  end


  # TODO: Utilを全部ラップ
  def handle_call({:current}, _from, sock) do
    Logger.debug "Commnad current"
    res = MpdClient.Query.current(sock)
    {:reply, res, sock}
  end

  def handle_call({:database_list}, _from, sock) do
    Logger.debug "Commnad database list"
    res = MpdClient.Query.database_list(sock)
    {:reply, res, sock}
  end

  def handle_call({:list_all, file_name}, _from, sock) do
    Logger.debug "Commnad list all"
    res = MpdClient.Query.list_all(file_name, sock)
    {:reply, res, sock}
  end

  def handle_call({:ls, dir_name}, _from, sock) do
    Logger.debug "Commnad ls"
    res = MpdClient.Query.ls(dir_name, sock)
    {:reply, res, sock}
  end

  def handle_call({:stats}, _from, sock) do
    Logger.debug "Commnad stats"
    res = MpdClient.Query.stats(sock)
    {:reply, res, sock}
  end

  def handle_call({:status}, _from, sock) do
    Logger.debug "Commnad status"
    res = MpdClient.Query.status(sock)
    {:reply, res, sock}
  end

  def handle_call({:list_all_info}, _from, sock) do
    Logger.debug "Commnad list all info"
    res = MpdClient.Query.list_all_info(sock)
    {:reply, res, sock}
  end

  def handle_call({:find, type, query}, _from, sock) do
    Logger.debug "Commnad find #{type} #{query}"
    res = MpdClient.Query.find(type, query, sock)
    {:reply, res, sock}
  end

  # 以下は、既存のMPDコマンドをラップして使いやすかなぁみたいなのの実装
  def handle_call({:list_all_file}, _from, sock) do
    Logger.debug "Commnad list all file"
    res = MpdClient.Query.list_all_file(sock)
    {:reply, res, sock}
  end

  def handle_call({:list_all_dir}, _from, sock) do
    Logger.debug "Commnad list all dir"
    res = MpdClient.Query.list_all_dir(sock)
    {:reply, res, sock}
  end

  # TODO: album名取得はelixirで実装
  def handle_call({:album_list}, _from, sock) do
    Logger.debug "Commnad album list"
    res = MpdClient.Query.album_list(sock)
    {:reply, res, sock}
  end
end

