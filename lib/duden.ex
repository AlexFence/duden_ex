defmodule Duden do
  @moduledoc """
  A Module for accesing the data of duden.de, 
  sadly they lack a proper api so it's a little messy.

  Usage:

    > {:ok, results} = Duden.search("baumkuchen")
    {:ok, [%Duden.SearchResult{...}, %Duden.SearchResult{...}]}
    > Duden.fetch_term(List.first(results))
    {:ok, %Duden.Term{alt_spelling: "", determiner: "der", word: "Baum­ku­chen"}}
  """

  alias Duden.Http
  alias Duden.Parser
  alias Duden.SearchResult
  alias Duden.Term

  @type term_name :: String.t()
  @type duden_error :: Http.duden_error()
  @type not_found_error :: Http.not_found_error()

  @spec search(String.t()) :: {:ok, [SearchResult.t()]} | duden_error
  def search(word) do
    case Http.get_search_api(word) do
      {:ok, response} ->
        results =
          Enum.map(response, fn x ->
            SearchResult.create_from_api_json(x)
          end)
          |> Enum.filter(fn x -> x !== nil end)

        {:ok, results}

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
  @spec fetch_term(term_name) :: {:ok, Term.t()} | not_found_error
  def fetch_term(term) when is_binary(term) do
    case Http.get_term_page(term) do
      {:ok, term_html} ->
        Parser.parse_term(term_html)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec fetch_term(SearchResult.t()) ::
          {:ok, Term.t()} | not_found_error | {:error, :not_a_search_result}
  def fetch_term(search_result) when is_map(search_result) do
    if Map.has_key?(search_result, :id) do
      fetch_term(search_result)
    else
      {:error, :not_a_search_result}
    end
  end
end
