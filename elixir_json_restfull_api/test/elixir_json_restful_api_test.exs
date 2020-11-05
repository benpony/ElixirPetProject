defmodule ElixirJsonRestfulApiTest do
  use ExUnit.Case
  doctest ElixirJsonRestfulApi

  test "greets the world" do
    assert ElixirJsonRestfulApi.hello() == :world
  end
end
