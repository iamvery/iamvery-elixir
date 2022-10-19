defmodule IamveryTest do
  use ExUnit.Case
  doctest Iamvery

  test "greets the world" do
    assert Iamvery.hello() == :world
  end
end
