defmodule Content.RemoteFileStreamer do

  @spec stream(String.t) :: Enumerable.t
  def stream(url)do
    Stream.resource(
        fn -> build_stream(url) end,
        fn resp -> read_stream(resp) end,
        fn _resp -> :ok end
       )
  end

  defp build_stream(url)do
    HTTPoison.get!(url, [], stream_to: self(), max_body_length: 9000000)
  end# , async: :once
  # "https://cdn.busuu.com/media/resized/video/mp4/large/london_central__1543595210.mp4"
  defp read_stream(resp)do
    %HTTPoison.AsyncResponse{id: ref} = resp
    receive do
      %HTTPoison.AsyncStatus{id: ^ref} -> continue(resp)
      %HTTPoison.AsyncHeaders{id: ^ref} -> continue(resp)
      %HTTPoison.AsyncChunk{chunk: chunk, id: ^ref} ->
        # _ = stream_next(resp)
        {[chunk], resp}
      %HTTPoison.AsyncEnd{id: ^ref} -> {:halt, resp}
    end
  end

  defp continue(resp)do
    resp
    # |> stream_next()
    |> read_stream()
  end

  defp stream_next(resp)do
    {:ok, ^resp} = HTTPoison.stream_next(resp)
    resp
  end

end
