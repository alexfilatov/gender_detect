defmodule GenderDetect.Lookup do
  @ets_name :people_name_stats

  def by_name(name) do
    name = name
    |> String.downcase()
    |> String.trim()

    case :ets.lookup(@ets_name, name) do
      [] -> %{name: name, status: "not_found"}
      [{name, %{"gender" => %{"name" => gender, "probability" => probability}}}] ->
        %{name: name, gender: gender, probability: probability}
    end
  end

end
