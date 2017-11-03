defmodule MpdClient.Util.UpdateDB.Bmark do
  use Bmark

  bmark :runner_with_runs, runs: 1 do
    MpdClient.Util.UpdateDB.update_db()
    IO.puts "update_db run 1 times"
  end
end
