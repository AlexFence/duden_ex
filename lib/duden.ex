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

  alias Duden.Http
  alias Duden.Parser
  alias Duden.Term

  @type term_name :: String.t()
  @type duden_error :: Http.duden_error()
  @type not_found_error :: Http.not_found_error()

  @spec search(String.t()) :: {:ok, [term_name]} | duden_error
  def search(word) do
    case Http.get_search_api(word) do
      {:ok, response} ->
        results =
          Enum.map(response, fn %{"value" => value} ->
            value
            |> String.trim()
            |> String.split("/")
            |> List.last()
          end)

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
  def fetch_term(term) do
    case Http.get_term_page(term) do
      {:ok, term_html} ->
        Parser.parse_term(term_html)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
