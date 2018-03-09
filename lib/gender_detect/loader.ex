defmodule GenderDetect.Loader do
  use GenServer
  require Logger

  @location "./names"

  NimbleCSV.define(GenderParser, separator: ",")

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def start_link(_), do: start_link()

  # loads all csv files into ETS
  def init(state) do
    # init ETS
    :people
    |> :ets.new([:duplicate_bag, :named_table, :public, read_concurrency: true, write_concurrency: true])

    # Load files into ETS
    process_csv_files()

    {:ok, state}
  end

  def process_csv_files() do
    with {:ok, files} <- File.ls(@location) do
      files
      |> Enum.map(fn(file) -> load_file(file) end)
    else
      error -> Logger.error "ERROR: #{inspect error}"
    end
  end


  defp load_file(file) do
    IO.puts "#{@location}/#{file}"
    "#{@location}/#{file}"
    |> File.stream!(read_ahead: 100_000)
    |> GenderParser.parse_stream()
    |> Stream.map(fn(record) ->
      put_to_ets(record)
    end)
    |> Stream.run()
  end

  defp put_to_ets([last_name, first_name, gender, race]) do
    :ets.insert(:people, {ss(first_name), ss(last_name), ss(gender), ss(race)})
  end

  defp put_to_ets([first_name, gender, race]) do
    [nil, first_name, gender, race] |> put_to_ets()
  end

  defp ss(nil), do: ""
  defp ss(string), do: String.trim(string)
end
