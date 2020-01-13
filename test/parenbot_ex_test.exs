defmodule ParenbotExTest do
  use ExUnit.Case
  doctest ParenbotEx

  test "greets the world" do
    assert ParenbotEx.hello() == :world
  end
end
