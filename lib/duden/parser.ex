defmodule Duden.Parser do
  @moduledoc """
  Logic for scapping Term deifintions out of Duden's HTML.
  """

  alias Duden.Term

  @type html_tree :: Floki.html_tree() | String.t()

  @spec parse_term(html_tree) :: {:ok, Term.t()} | {:error}
  def parse_term(html) do
    article = Floki.find(html, "article")

    if length(article) > 0 do
      word = get_word(article)
      alt_spelling = get_alt_spelling(article)
      determiner = get_determiner(article)
      {:ok, %Term{word: word, alt_spelling: alt_spelling, determiner: determiner}}
    else
      {:error}
    end
  end

  defp get_word(article) do
    article
    |> Floki.find(".lemma__title .lemma__main")
    |> Floki.text()
  end

  defp get_alt_spelling(article) do
    article
    |> Floki.find(".lemma__title .lemma__alt-spelling")
    |> Floki.text()
  end

  defp get_determiner(article) do
    article
    |> Floki.find(".lemma__title .lemma__determiner")
    |> Floki.text()
  end
end
