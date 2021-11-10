defmodule ArtistTest do
  use ExUnit.Case
  doctest Artist

  test "greets the world" do
    assert Artist.hello() == :world
  end
end
