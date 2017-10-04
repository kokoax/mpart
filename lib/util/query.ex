defmodule MpdClient.Query do
  def to_struct(data) do
    Regex.split(~r/\n/, data)
    |> Enum.map(&(Regex.split(~r/:\s/, &1)))
    # |> Enum.map(&(%{String.to_atom(Enum.at(&1,0)) => Enum.at(&1,1)}))
    |> Enum.map(fn(item) ->
      MpdClient.MpdData.new(
        Enum.at(item, 0),
        Enum.at(item, 1)
      )
    end)
    |> Enum.filter(&(&1.data != ""))
  end

  def current(sock) do
    cmd_do("currentsong \n", sock)
  end

  def database_list(sock) do
    MpdClient.Query.cmd_do("list MPD \n", sock)
  end

  def list_all(file_name \\ "/", sock)
  def list_all(file_name, sock) do
    cmd_do(~s(listall "#{file_name}"\n), sock)
  end

  def ls(dir_name, sock) do
    cmd_do(~s(lsinfo "#{dir_name}" \n), sock)
  end

  def stats(sock) do
    cmd_do(~s(stats \n), sock)
  end

  def status(sock) do
    cmd_do(~s(status \n), sock)
  end

  def list_all_info(sock) do
    cmd_do(~s(listallinfo \n), sock)
  end

  def update(sock) do
    cmd_do(~s(update \n), sock)
  end

  def list(type \\ "any", query, sock)
  def list(type, query, sock) do
    cmd_do(~s(list "#{type}" "#{query}" \n), sock)
  end

  def find(type \\ "any", query, sock)
  def find(type, query, sock) do
    cmd_do(~s(find "#{type}" "#{query}" \n), sock)
  end

  # 以下、MPDコマンド以外の作成したコマンド

  # 音楽ファイルの入っているディレクトリは全てアルバムであると仮定して
  # 全ての音楽ファイルのPathを抽出して、そのディレクトリ名をmap
  # それをuniqすれば、アルバム名が取り出せる算段
  def album_list(sock) do
    cmd_do(~s(listall \n), sock)
    |> Enum.filter(&(&1.type == "file"))
    |> Enum.map(fn(minfo) ->
      MpdClient.MpdData.new(
        "directory",
        minfo.data |> Path.dirname)
    end)
    |> Enum.uniq
  end

  def list_all_file(sock) do
    MpdClient.Query.list_all(sock)
    |> Enum.filter(fn(info) ->
      info |> Map.has_key?("file")
    end)
  end

  def list_all_dir(sock) do
    MpdClient.Query.list_all(sock)
    |> Enum.filter(fn(info) ->
      info |> Map.has_key?("directory")
    end)
  end

  # コマンド実行を隠蔽
  def cmd_do(cmd, sock) do
    :ok = :gen_tcp.send(sock, cmd)
    :timer.sleep(10)
    {:ok, msg} = :gen_tcp.recv(sock, 0)

    :gen_tcp.close(sock)

    Enum.join(for <<c::utf8 <- msg>>, do: <<c::utf8>>)
    |> to_struct
  end
end

