defmodule GenderDetect.Supervisor do
    use Supervisor

    def start_link() do
        Supervisor.start_link(__MODULE__, %{}, name: __MODULE__)
    end

    def init(_arg) do
        children = [
            Plug.Adapters.Cowboy.child_spec(:http, GenderDetect.Router, [], [port: String.to_integer(System.get_env("PORT") || "4001")]),
            {GenderDetect.Loader, []}
        ]

        Supervisor.init(children, strategy: :one_for_one)
    end
end
