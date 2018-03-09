defmodule GenderDetect do
  use Application

  def start(_type, _args) do
    GenderDetect.Supervisor.start_link()
  end

end
