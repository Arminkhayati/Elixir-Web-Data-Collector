defmodule Collector.DataFetcher do

  require Logger
  def get(url)do
    url
    |> HTTPoison.get(follow_redirect: true)
    |> response_handler()
  end

  def post(url, body, header)do
    HTTPoison.post(url, body, header)
    |> response_handler()
  end

  defp response_handler({:error, %{reason: :timeout}})do
    Logger.error("TIMEOUT")
    {:error, :timeout}
  end
  defp response_handler(_data = {_, %{body: body, status_code: code}})do
    # IO.inspect(data)
    {
      code |> check_error(),
      body
    }
  end
  defp response_handler({:error, %{reason: error}})do
    Logger.error("Error #{error}")
    {:error, error}
  end

  defp check_error(200), do: :ok
  defp check_error(_), do: :error #code
end
