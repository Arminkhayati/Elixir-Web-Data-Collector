defmodule Content.DataFetcher do

  def fetch(url)do
    url
    |> HTTPoison.get()
    |> response_handler()
    # |> write_json()
  end
  # def write_json({_,content}), do: File.write!("#{__DIR__}/a.json", Poison.encode!(content))
  # def response_handler({:error, %{id: nil, reason: reason}})do
  #   {:error, reason}
  # end
  def response_handler({_, %{body: body, status_code: code}})do
    {
      code |> check_error(),
      body |> Poison.Parser.parse!(%{})
    }
  end

  def check_error(200), do: :ok
  def check_error(_), do: :error
end
