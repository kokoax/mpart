defmodule MpdClient.Handlers.Template do
  @moduledoc """
  TODO: Add document
  """

  def init(req, opts) do
    method = :cowboy_req.method(req)
    param = :cowboy_req.binding(:javascript, req)
    {:ok, resp} = html_example(method, param, req)
    {:ok, resp, opts}
  end

  def html_example("GET", :undefined, req) do
    headers = {"content-type", "text/plain"}
    body = ""
    :cowboy_req.reply(404, [headers], body, req)
  end

  def html_example("GET", param, req) do
    headers = {"content-type", "text/plain"}
    {:ok, body} = File.read(System.cwd! <> "/priv/templates/#{param}")
    :cowboy_req.reply(200, [headers], body, req)
  end
end
