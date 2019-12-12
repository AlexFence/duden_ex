defmodule DudenTest do
  use ExUnit.Case
  doctest Duden

  test "search" do
    {:ok, results} = Duden.search("hanna")
    assert length(results) == 1
    assert hd(results) == "Hanna"
  end

  test "fetch_term" do
    {:ok, term} = Duden.fetch_term("Hanna")
    assert term.word == "Han­na"
    assert term.alt_spelling == "Han­nah"
  end
end
