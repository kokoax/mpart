defmodule MpdClientTest do
  use ExUnit.Case
  doctest MpdClient

  test "greets the world" do
    assert MpdClient.hello() == :world
  end
end
