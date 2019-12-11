defmodule Duden do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://www.duden.de")
  plug(Tesla.Middleware.JSON)

  def search(word) do
    get("/search_api_autocomplete/dictionary_search", query: [q: word])
    |> case do
      {:ok, %{status: 200, body: body}} ->
        Enum.map(body, fn %{"value" => value} ->
          value
          |> String.trim()
          |> String.split("/")
          |> List.last()
        end)

      {:ok, %{status: _status} = req} ->
        {:error, req}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def fetch_term(term) do
    case get("/rechtschreibung/#{term}") do
      {:ok, %{status: 200, body: body}} ->
        article = Floki.find(body, "article")

        word =
          article
          |> Floki.find(".lemma__title .lemma__main")
          |> Floki.text()

        alt_spelling =
          article
          |> Floki.find(".lemma__title .lemma__alt-spelling")
          |> Floki.text()

        determiner =
          article
          |> Floki.find(".lemma__title .lemma__determiner")
          |> Floki.text()

        %{"word" => word, "alt_spelling" => alt_spelling, "determiner" => determiner}

      {:ok, %{status: _status} = req} ->
        {:error, req}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
