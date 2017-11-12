defmodule Mpdart.Router do
  import Logger

  def start_link(_name) do
    Logger.debug "Mpdart start(_type, _args)"
    dispatch = :cowboy_router.compile routes()
    {:ok, _} = :cowboy.start_http(
      :http, 100,
      [{:port, 4000}],
      [{:env, [{:dispatch, dispatch}]}]
    )
  end

  defp routes do
    Logger.debug "Mpdart rotues()"
    [
      {
        :_,
        [
          {"/", :cowboy_static, {:priv_file, :mpdart, "static/index.html"}},
          {"/priv/static/js/:javascript", Mpdart.Handlers.Javascript, []},
          {"/priv/static/css/:css",       Mpdart.Handlers.Css, []},
          {"/priv/templates/:template",   Mpdart.Handlers.Template, []},
          {"/priv/static/images/[...]",
            :cowboy_static, {:priv_dir, :mpdart, "static/images"}},
          {"/mpdart",                 Mpdart.Handlers.Mpdart, []},
          {"/api/status",                 Mpdart.Handlers.Status, []},
        ]
      }
    ]
  end
end
