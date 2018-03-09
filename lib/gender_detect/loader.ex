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
    # init ETS tables
    :people |> :ets.new([:bag, :named_table, :public, read_concurrency: true, write_concurrency: true])
    :people_name_stats |> :ets.new([:set, :named_table, :public, read_concurrency: true, write_concurrency: true])

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
    first_name = ss(first_name)
    last_name = ss(last_name)
    gender = ss(gender)
    race = ss(race)
    # store all people from csv
    :ets.insert(:people, {first_name, last_name, gender, race})

    # pre-calculate stats
    # {"alex", %{"gender" => %{"male" => 10, "female" => 0, "probability" => 1.0}}}
    stats_struct = case :ets.lookup(:people_name_stats, first_name) do
      # no records yet
      [] ->
        prepare_stats(gender, {first_name, %{"gender" => %{"male" => 0, "female" => 0, "probability" => 0}}})
      [{first_name, %{"gender" => %{"male" => male_num, "female" => female_num, "probability" => probability}}}] ->
        prepare_stats(gender, {first_name, %{"gender" => %{"male" => male_num, "female" => female_num, "probability" => probability}}})
    end

    :ets.insert(:people_name_stats, stats_struct)
  end

  defp put_to_ets([first_name, gender, race]) do
    [nil, first_name, gender, race] |> put_to_ets()
  end

  defp prepare_stats("m", {first_name, %{"gender" => %{"male" => male_num, "female" => female_num}} = gender_map}) do
    gender_map = gender_map
    |> Kernel.put_in(["gender", "name"], "male")
    |> Kernel.put_in(["gender", "male"], male_num + 1)
    |> Kernel.put_in(["gender", "probability"], find_probability(female_num, male_num, "male"))
    {first_name, gender_map}
  end

  defp prepare_stats("f", {first_name, %{"gender" => %{"male" => male_num, "female" => female_num}} = gender_map}) do
    gender_map = gender_map
    |> Kernel.put_in(["gender", "name"], "female")
    |> Kernel.put_in(["gender", "female"], female_num + 1)
    |> Kernel.put_in(["gender", "probability"], find_probability(female_num, male_num, "female"))
    {first_name, gender_map}
  end


  @spec find_probability(number, number, string) :: float
  defp find_probability(0, 0, _), do: 0
  defp find_probability(female_num, male_num, "female") do
     female_num / ((female_num + male_num) / 100) / 100
  end
  defp find_probability(female_num, male_num, "male") do
     male_num / ((female_num + male_num) / 100) / 100
  end
  defp find_probability(female_num, male_num, "unknown"), do: 0

  defp ss(nil), do: ""
  defp ss(string), do: String.trim(string)
end
