defmodule MultiDict do

  def new() do %{} end
  def add(map, key, value) do
    Map.update(map, key, [value], &[value | &1])
  end
  def entries(map, key) do
    Map.get(map, key, [])
  end
end
