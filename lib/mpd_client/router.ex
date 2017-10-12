defmodule MpdClient.Router do
  import Logger

  def start_link(_name) do
    Logger.debug "MpdClient start(_type, _args)"
    dispatch = :cowboy_router.compile routes()
    {:ok, _} = :cowboy.start_http(
      :http, 100,
      [{:port, 4000}],
      [{:env, [{:dispatch, dispatch}]}]
    )
  end

  defp routes do
    Logger.debug "MpdClient rotues()"
    [
      {
        :_,
        [
          # TODO: 増やせごらぁ
          {"/", :cowboy_static, {:priv_file, :mpd_client, "static/index.html"}},
          {"/priv/static/js/:javascript", MpdClient.Handlers.Javascript, []},
          {"/priv/static/css/:css",       MpdClient.Handlers.Css, []},
          {"/priv/templates/:template",   MpdClient.Handlers.Template, []},
          {"/priv/static/images/[...]",
            :cowboy_static, {:priv_dir, :mpd_client, "static/images"}},
          {"/mpd_client",                 MpdClient.Handlers.MpdClient, []},
          {"/api/status",                 MpdClient.Handlers.Status, []},
        ]
      }
    ]
  end
end
