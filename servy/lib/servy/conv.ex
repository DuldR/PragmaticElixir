defmodule Servy.Conv do
  defstruct [method: "", path: "", resp_body: "", status: nil]

  def full_status(conv) do
    "#{conv.status}"
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
