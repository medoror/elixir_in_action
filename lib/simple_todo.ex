defmodule TodoList do

  defstruct next_id: 1, entries: %{}

  def new(), do: %TodoList{}


  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.next_id)
    # Add the new entry to the collection.
    new_entries = Map.put(todo_list.entries,
    todo_list.next_id,
    entry)
    #Increment the next_id field.
    %TodoList{todo_list |
      entries: new_entries,
      next_id: todo_list.next_id + 1
    }
  end

  def entries(todo_list, date) do
    todo_list.entries |> Map.values() |> Enum.filter(fn entry -> entry.date == date end)
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
