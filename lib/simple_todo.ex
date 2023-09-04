defmodule TodoList do
  def new(), do: MultiDict.new()

  def add_entry(todo_list, date, title) do
    MultiDict.add(todo_list, date, title)
  end

  def entries(todo_list, date) do
    MultiDict.entries(todo_list, date)
  end
end


defmodule MultiDict do

  def new() do %{} end
  def add(map, key, value) do
    Map.update(map, key, [value], &[value | &1])
  end
  def entries(map, key) do
    Map.get(map, key, [])
  end
end
