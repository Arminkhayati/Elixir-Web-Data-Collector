defmodule Collector.Server.URLCollector do
  use GenServer, restart: :transient
  alias Collector.URLCollector
  alias Collector.Server.StateSaver
  require Logger

  @server __MODULE__

  ######client api########

  def get_url_list()do
    GenServer.call(@server, :next)
  end

  ##############
  def start_link(_)do
    GenServer.start_link(__MODULE__, :no_arg, name: __MODULE__)
  end

  def init(_)do
    init_arg = StateSaver.get_current_page()
    Logger.warn("Initializing URL Collector")
    {:ok, init_arg}
  end

  def handle_call(:next, _from, current_page)do
    case URLCollector.collect(current_page) do
      {url_list, []} ->
        Logger.info("#{current_page} collected successfuly")
        Logger.warn("URL Collector Server Will terminate successfuly")
        { :stop, :normal, {:last, url_list}, current_page }
      {url_list, next_page} ->
        Logger.info("#{current_page} collected successfuly")
        {:reply, {:continues, url_list}, next_page}
      :error ->
        {:reply, [], current_page}
    end
  end

  def terminate(_reason, state) do
    StateSaver.update_page(state)
    Logger.warn("Terminating URL Collector")
  end

end
