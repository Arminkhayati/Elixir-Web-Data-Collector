defmodule Collector.Schema.Comments do

  alias Collector.Schema.Comment
  alias Collector.Repo

  def create_comments(comments)do
    # Comment.changeset(%Comment{}, comment)
    # |> Repo.insert
    Repo.insert_all(Comment, comments)
  end

end
