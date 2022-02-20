require Logger

defmodule Servy.Handler do

  @moduledoc "Handles HTTP requests"

  @doc "Transforms oyur request into a response"

  @pages_path Path.expand("../../pages", __DIR__)

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  # Status

  def emojify(%{status: 200, resp_body: resp_body} = conv) do

    %{ conv | resp_body: "☺️" <> resp_body <> "☺️"}

  end

  def emojify(conv), do: conv

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  @doc "Logs the requests"
  def track(conv), do: conv

  # Paths

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  # def rewrite_path(%{path: "/wildlife"} = conv) do
  #   %{ conv | path: "/wildthings" }
  # end

  def rewrite_path(conv), do: conv

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv


  # Log

  def log(conv) do

    IO.inspect conv
    Logger.info("#{inspect(conv)}\n")

    conv

  end


  # Request

  def parse(request) do

    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil
    }
  end

  # Function Clauses
  def route(%{ method: "GET", path: "/wildthings" } = conv ) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tirgers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Da Bears" }
  end

  def route(%{ method: "GET", path: "/bears/new" } = conv) do

    Path.expand("../../pages", __DIR__)
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{ method: "DELETE", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id} deleted" }
  end

  # File Reads

  def route(%{ method: "GET", path: "/about" } = conv) do

      Path.expand("../../pages", __DIR__)
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  # Omega Capture

  def route(%{ method: "GET", path: "/pages/" <> id } = conv) do
    @pages_path
    |> Path.join("#{id}" <> ".html")
    |> File.read
    |> handle_file(conv)
  end

  # Path

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end

  def handle_file( {:ok, content}, conv) do

    %{ conv | status: 200, resp_body: content}

  end

  def handle_file( {:error, :enoent}, conv) do

    %{ conv | status: 404, resp_body: "File not found!" }

  end

  def handle_file( {:error, reason}, conv) do

    %{ conv | stauts: 500, resp_body: "File error: #{reason} "}

  end




  def format_response(conv) do

    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  # Private
  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Inernal Server Error"
    }[code]
  end
end

# request = """
# GET /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response


# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response

# request = """
# GET /bigfoot HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response

# request = """
# GET /wildlife HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response

# request = """
# DELETE /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response


# request = """
# GET /bears?id=1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response

# request = """
# GET /bears?id=2 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response


# request = """
# GET /about HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response


# request = """
# GET /bears/new HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts response

request = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response


request = """
GET /pages/coolguy HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response
