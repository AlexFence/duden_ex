defmodule Duden.Http do
  @moduledoc """
  Contains all the HTTP stuff 
  so Tesla doesn't polute the top-level module with a bunch of functions 
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://www.duden.de")
  plug(Tesla.Middleware.JSON)

  @type duden_error :: {:error, :site_error} | {:error, :network_error}
  @type not_found_error :: {:error, :not_found} | duden_error

  @spec get_search_api(String.t()) :: {:ok, [map]} | duden_error
  def get_search_api(query) do
    case get("/search_api_autocomplete/dictionary_search", query: [q: query]) do
      {:ok, %{status: 200, body: response}} ->
        {:ok, response}

      # their api always seems to return a 200 no matter the input or result
      # we'll consider any other status as an error
      {:ok, %{status: _status}} ->
        {:error, :site_error}

      {:error, _reason} ->
        {:error, :network_error}
    end
  end

  @spec get_term_page(String.t()) :: {:ok, String.t()} | not_found_error
  def get_term_page(term) do
    case get("/rechtschreibung/#{term}") do
      {:ok, %{status: 200, body: response}} ->
        {:ok, response}

      {:ok, %{status: 404}} ->
        {:error, :term_not_found}

      # we'll consider any other status as an error
      {:ok, %{status: _status}} ->
        {:error, :site_error}

      {:error, _reason} ->
        {:error, :network_error}
    end
  end
end
