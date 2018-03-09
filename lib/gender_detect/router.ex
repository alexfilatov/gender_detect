defmodule GenderDetect.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Parsers, parsers: [:json], pass:  ["application/json"], json_decoder: Jason

  plug :match
  plug :dispatch

  get "/detect" do
    result = get_gender(conn.query_params) |> Jason.encode!()

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, result)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end


  defp get_gender(%{"name" => name}) do
    GenderDetect.Lookup.by_name(name)
  end

  defp get_gender(_), do: "not_found"

end
