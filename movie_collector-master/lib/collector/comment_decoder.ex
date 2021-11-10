defmodule Collector.CommentDecoder do

  require Logger
  import Floki

  def decode(html)do
    post_id = html |> get_post_id()
    html
    |> get_root_comments_id()
    # [%{id: "198684", parent: "0"}]
    |> Enum.map(&get_comment(&1, post_id))
    |> Enum.map(&get_comments_id/1)
    |> List.flatten()
    |> read_more(post_id, [])
  end

  def read_more([], _post_id, result), do: result
  def read_more([comment | tail], post_id, result)do
    Logger.info("READ MORE comment #{comment.id}")
    url = "http://mydiba.site/wp-admin/admin-ajax.php"
    headers = %{"Content-type" => "application/x-www-form-urlencoded"}
    data = {:form, [action: "readMore", commentId: comment.id, postId: post_id]}
    case Collector.DataFetcher.post(url,data, headers)do
      {:ok, body} ->
        comment_text = body |> Poison.decode!() |> Map.get("message") |> text()
        read_more(tail, post_id,
          [%{comment_id: comment.id, comment: comment_text,
          parent: comment.parent, movie_id: post_id,
          author: comment.author, like: comment.like,
          dislike: comment.dislike} | result]
          )
      {:error, :timeout} ->
        Logger.error("********************* ERROR timeout commentID: #{comment.id},  postID: #{post_id}")
        read_more([comment | tail],post_id, result)
      error ->
        Logger.error("**** Error in read more comment in #{__MODULE__} ****\n with this page : #{url} \n #{inspect(error)}")
        :error
    end
  end


  def get_comment(comment, post_id)do
    url = "http://mydiba.site/wp-admin/admin-ajax.php"
    headers = %{"Content-type" => "application/x-www-form-urlencoded"}
    data = {:form, [action: "wpdiscuzShowReplies", commentId: comment.id , postId: post_id]}
    case Collector.DataFetcher.post(url,data, headers)do
      {:ok, body} ->
        Logger.warn("********************* Got COMMENT FOR commentID: #{comment.id},  postID: #{post_id}")
        body |> Poison.decode!() |> Map.get("data")
      {:error, :timeout} ->
        Logger.error("********************* ERROR timeout commentID: #{comment.id},  postID: #{post_id}")
        get_comment(comment, post_id)
      error ->
        Logger.error("**** Error in getting comment in #{__MODULE__} ****\n with this page : #{url} \n #{inspect(error)}")
        :error

    end
  end

  def set_username(id, html)do
    # id = "wc-comm-#{id}_#{parent}"
    html
    |> find("div[id=#{id}]")
    |> find("div.wc-comment-right, div.wc-comment-header, div.wc-comment-author")
    |> find("a")
    |> text(sep: ",")
    |> String.split(",")
    |> List.first()
  end

  def get_post_id(html)do
    html
    |> find("span.sl-wrapper")
    |> find("a.sl-button")
    |> attribute("href")
    |> text()
    |> URI.decode_query()
    |> Map.get("post_id")
  end

  def get_root_comments_id(html)do
    html
    |> find("div.comments-area")
    |> get_comments_id()
  end

  def get_comments_id(html)do
    html
    |> find("div")
    |> attribute("id")
    |> Enum.filter(fn id -> Regex.match?(~r{wc-comm-[0-9]*_[0-9]*}, id) end)
    |> Enum.map(fn id ->
          [comment_id, parent_id] = String.split(id, ~r{[^0-9]}, trim: true)
          %{id: comment_id, parent: parent_id, author: set_username(id, html), like: get_comment_like(id, html), dislike: get_comment_dislike(id, html)}
        end)
  end

  def get_comment_like(id, html)do
    html
    |> find("div[id=#{id}]")
    |> find("span.wc-vote-result-like")
    |> text(sep: ",")
    |> String.split(",")
    |> List.first()
  end
  def get_comment_dislike(id, html)do
    html
    |> find("div[id=#{id}]")
    |> find("span.wc-vote-result-dislike")
    |> text(sep: ",")
    |> String.split(",")
    |> List.first()
  end

end
