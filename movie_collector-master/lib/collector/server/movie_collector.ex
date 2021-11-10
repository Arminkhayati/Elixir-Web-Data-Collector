defmodule Collector.Server.MovieCollector do
  use GenServer, restart: :transient
  require Logger
  alias Collector.MovieCollector

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_arg)
  end

  def init(_)do
    Process.send_after(self(), :kickoff, 0)
    { :ok, nil }
  end

  def handle_info(:kickoff, _)do
    result = MovieCollector.start()
    case result do
      :done ->
        Logger.info("** MovieCollector Done.....")
        {:stop, :normal, nil}
      response ->
        decode_response(response)
    end
  end

  def decode_response({_, %{movie: :ok, comments: :ok}})do
    send(self(), :kickoff)
    {:noreply, nil}
  end
  def decode_response({url, %{movie: err1, comments: err2}})do
    # MovieCollector.role_back_url(url)
    Logger.error("** SAVE DATA ERROR FOR #{url} DETAILS : movie:  \n #{inspect(err1)} \n comments: #{inspect(err2)}}")
    send(self(), :kickoff)
    {:noreply, nil}
  end

end
