defmodule DudenTest do
  use ExUnit.Case

  test "it can search for terms" do
    {:ok, results} = Duden.search("hanna")
    assert length(results) == 1
    assert hd(results) == "Hanna"
  end

  test "search no results" do
    {:ok, results} = Duden.search("Yui Funami")
    assert Enum.empty?(results)
  end

  test "it can fetch a term" do
    {:ok, term} = Duden.fetch_term("Hanna")
    assert term.word == "Han­na"
    assert term.alt_spelling == "Han­nah"
  end

  test "it will return an error if a term does not exist" do
    {:error, _} = Duden.fetch_term("Hannah")
  end
end
