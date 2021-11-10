defmodule NewCollectorTest do
  use ExUnit.Case
  doctest NewCollector

  test "greets the world" do
    assert NewCollector.hello() == :world
  end
end
