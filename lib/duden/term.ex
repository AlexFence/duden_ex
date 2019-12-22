defmodule Duden.Term do
  @moduledoc """
  A struct representing a Term.
  """
  
  @derive Jason.Encoder
  @enforce_keys [:word]
  defstruct word: nil,
            determiner: nil,
            alt_spelling: nil

  @typedoc "A Term"
  @type t() :: %__MODULE__{
          word: String.t(),
          determiner: String.t() | nil,
          alt_spelling: String.t() | nil
        }
end
