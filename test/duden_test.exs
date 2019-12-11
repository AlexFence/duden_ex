defmodule DudenTest do
  use ExUnit.Case
  doctest Duden

  test "search" do
    results = Duden.search("hanna")
    assert length(results) == 1
    assert hd(results) == "Hanna"
  end

end
