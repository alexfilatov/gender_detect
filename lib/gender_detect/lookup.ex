defmodule GenderDetect.Lookup do
  @ets_name :people

  def by_name(name) do
    name = name
    |> String.downcase()
    |> String.trim()

    fun = do_fun(name)

    :ets.select(@ets_name, fun)
    |> Enum.reduce(%{name: "", gender: %{male: 0, female: 0}}, fn(record, acc) ->
        acc = calc_gender(record, acc)
    end)
    |> (fn(%{gender: %{female: female_num, male: male_num}, name: name}) ->
      gender = find_gender(female_num, male_num)
      probability = find_probability(female_num, male_num, gender)
      %{name: name, gender: gender, probability: probability}
    end).()
  end

  defp find_gender(0, 0), do: "unknown"
  defp find_gender(female_num, male_num) when female_num >= male_num, do: "female"
  defp find_gender(female_num, male_num) when female_num < male_num, do: "male"

  @spec find_probability(number, number, string) :: float
  defp find_probability(female_num, male_num, "female") do
     female_num / ((female_num + male_num) / 100) / 100
  end
  defp find_probability(female_num, male_num, "male") do
     male_num / ((female_num + male_num) / 100) / 100
  end
  defp find_probability(female_num, male_num, "unknown"), do: 0

  @spec calc_gender({string, string, string, string}, map) :: float
  defp calc_gender({first_name, last_name, "f", race}, acc) do
    acc
    |> Map.put(:name, first_name)
    |> Kernel.put_in([:gender, :female], Kernel.get_in(acc, [:gender, :female]) + 1)
  end
  defp calc_gender({first_name, last_name, "m", race}, acc) do
    acc
    |> Map.put(:name, first_name)
    |> Kernel.put_in([:gender, :male], Kernel.get_in(acc, [:gender, :male]) + 1)
  end
  defp calc_gender({first_name, last_name, _, race}, acc), do: acc |> Map.put(:name, "not_found")

  defp do_fun(name) do
    [
      { {:"$1", :"$2", :"$3", :"$4"}, [{:==, :"$1", name}], [{{:"$1", :"$2", :"$3", :"$4"}}] }
    ]
  end
end
