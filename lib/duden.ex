defmodule Duden do
  @moduledoc """
  A Module for accesing the data of duden.de, 
  sadly they lack a proper api so it's a little messy.

  Usage:

    iex> {:ok, results} = Duden.search("baumkuchen")
    {:ok, ["Baumkuchen", "Pruegeltorte"]}
    iex> Duden.fetch_term(List.first(results))
    {:ok, %Duden.Term{alt_spelling: "", determiner: "der", word: "Baum­ku­chen"}}
  """

  use Tesla
  alias Duden.Parser
  alias Duden.Term

  plug(Tesla.Middleware.BaseUrl, "https://www.duden.de")
  plug(Tesla.Middleware.JSON)

  @type term_name :: String.t()

  @doc """
  Searches Duden's site for a word.

    Returns a list a list of results,
    those results can then be passed to Duden.fetch_term() for fetching a definition of that word.
    iex> Duden.search("baumkuchen")
    {:ok, ["Baumkuchen", "Pruegeltorte"]}
  """
  @spec search(String.t()) :: {:ok, [term_name]} | {:err, any}
  def search(word) do
    get("/search_api_autocomplete/dictionary_search", query: [q: word])
    |> case do
      {:ok, %{status: 200, body: body}} ->
        results =
          Enum.map(body, fn %{"value" => value} ->
            value
            |> String.trim()
            |> String.split("/")
            |> List.last()
          end)

        {:ok, results}

      {:ok, %{status: _status} = req} ->
        {:error, req}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Fetches the definition of a term that has been searched for.
    
    You should pass return values from Duden.search() to it.

    iex> Duden.fetch_term("Kuchen")
    {:ok, %Duden.Term{alt_spelling: "", determiner: "der", word: "Ku­chen"}}
  """
  @spec fetch_term(term_name) :: {:ok, Term.t()} | {:err, any}
  def fetch_term(term) do
    case get("/rechtschreibung/#{term}") do
      {:ok, %{status: 200, body: body}} ->
        Parser.parse_term(body)

      {:ok, %{status: _status} = req} ->
        {:error, req}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
