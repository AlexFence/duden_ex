# Duden_ex

**It's Wednesday my Duden!**

It's a simple little wrapper for [Duden's](https://duden.de) not really existing API. So it gets most of its data out of their HTML.

## Usage

```elixir
iex> {:ok, results} = Duden.search("baumkuchen")
{:ok, ["Baumkuchen", "Pruegeltorte"]}
iex> Duden.fetch_term(List.first(results))
{:ok, %Duden.Term{alt_spelling: "", determiner: "der", word: "Baum­ku­chen"}}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `duden` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:duden, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/duden](https://hexdocs.pm/duden).

