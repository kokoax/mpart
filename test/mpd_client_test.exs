defmodule MpdClientTest do
  use ExUnit.Case
  doctest MpdClient

  test "greets the world" do
    assert MpdClient.hello() == :world
  end
  test "update db to NoSQL test" do
    MpdClient.Util.UpdateDB.update_db()
    assert true == false
  end
end
