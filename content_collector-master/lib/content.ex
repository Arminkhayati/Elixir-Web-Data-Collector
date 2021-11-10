defmodule Content do
  @moduledoc """
  Documentation for Content.
  """

  def start(link)do
    link
    |> Content.DataLoader.start()
  end


  # @doc """
  # Hello world.
  #
  # ## Examples
  #
  #     iex> Content.hello()
  #     :world
  #
  # """
  # def hello do
  #   :world
  # end
end
