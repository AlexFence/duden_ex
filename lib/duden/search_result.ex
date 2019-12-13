defmodule Duden.SearchResult do
  @moduledoc """
  A struct representing a result from Duden's autocomplete API.

  Some keys have been changed to make it clearer:
    value -> id
    build -> display_name

  """

  @enforce_keys [:id, :display_name]
  defstruct id: "",
            display_name: "",
            group: "Duden-Online-Wörterbuch"

  @typedoc "A search result"
  @type t() :: %__MODULE__{
          id: String.t(),
          display_name: String.t(),
          group: String.t()
        }

  @spec create_from_api_json(map) :: t | nil
  def create_from_api_json(json) do
    case json do
      %{"value" => value, "build" => build, "group" => group} ->
        id =
          value
          |> String.trim()
          |> String.split("/")
          |> List.last()

        display_name = Floki.text(build)
        %__MODULE__{id: id, display_name: display_name, group: group}

      _ ->
        nil
    end
  end
end
