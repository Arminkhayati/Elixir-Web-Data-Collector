defmodule Collector.Server.StateSaver do
  use GenServer
  # @dynamic_sup Collector.DynamicSupervisor
  @me __MODULE__

  require Logger

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end
  def get_current_page() do
    GenServer.call(@me, { :get_current_page })
  end
  def get_url_lists() do
    GenServer.call(@me, { :get_url_lists })
  end
  def update_page(new_page) do
    GenServer.cast(@me, { :update_page, new_page })
  end
  def update_url_lists(url_lists) do
    GenServer.cast(@me, { :update_url_lists, url_lists })
  end
  #####################################

  def init(initial_state) do
    # Process.send_after(self(), :kickoff, 0)
    { :ok, initial_state }
  end

  # def handle_info(:kickoff, state)do
  #   1..state.collectors
  #   |> Enum.each(fn _ ->
  #           DynamicSupervisor.start_child(@dynamic_sup, Collector.Server.MovieCollector)
  #         end)
  #   { :noreply, state }
  # end

  def handle_call({ :get_url_lists }, _from, state = %{urls: urls} ) do
    { :reply, urls, state}
  end
  def handle_call({ :get_current_page }, _from, state = %{page: page} ) do
    { :reply, page, state}
  end

  def handle_cast({ :update_page, new_page }, state) do
    { :noreply, %{state | page: new_page} }
  end
  def handle_cast({ :update_url_lists, url_lists }, state) do
    { :noreply, %{state | urls: url_lists} }
  end

  def handle_cast(:done, %{collectors: 1}) do
    Logger.info("***** FINISHED *****")
    System.halt(0)
  end
  def handle_cast(:done, state = %{collectors: count}) do
    Logger.info("***** One Collector Down.")
    { :noreply, %{state | collectors: count - 1} }
  end

end
