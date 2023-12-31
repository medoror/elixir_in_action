defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list_acc ->
        add_entry(todo_list_acc, entry)
      end
    )
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.next_id)
    # Add the new entry to the collection.
    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.next_id,
        entry
      )

    # Increment the next_id field.
    %TodoList{todo_list | entries: new_entries, next_id: todo_list.next_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries |> Map.values() |> Enum.filter(fn entry -> entry.date == date end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    new_entries = Map.delete(todo_list.entries, entry_id)
    %TodoList{todo_list | entries: new_entries}
  end
end

defmodule MultiDict do
  def new() do
    %{}
  end

  def add(map, key, value) do
    Map.update(map, key, [value], &[value | &1])
  end

  def entries(map, key) do
    Map.get(map, key, [])
  end
end

defmodule TodoList.CsvImporter do
  def import(file_path) do
    file_path
    |> read_lines
    |> create_todo_entries
    |> TodoList.new()
  end

  defp read_lines(file_path) do
    file_path
    |> File.stream!
    |> Stream.map(&String.trim_trailing(&1, "\n"))
  end

  defp create_todo_entries(line) do
    line
    |> Stream.map(&extract_fields/1)
    |> Stream.map(&create_todo/1)
  end

  defp extract_fields(line) do
    line
    |> String.split(",")
    |> convert_date
  end

  defp convert_date([date_string, title]) do
    {parse_date(date_string), title}
  end

  defp parse_date(date_string) do
    [year, month, day] = String.split(date_string, "-")
    |> Enum.map(&String.to_integer/1)

    {:ok, date} = Date.new(year, month, day)
    date
  end

  defp create_todo({date, title}) do
    %{date: date, title: title}
  end
end
