# MpdClient

[![Travis](https://api.travis-ci.org/kokoax/mpdart.svg)](https://api.travis-ci.org/kokoax/mpdart)

Must write
``` config/config.exs
use Mix.Config
config :mpd_client,
  api_token: "Discogs API Token",
  musicdir: "/path/to/your/Musicdir",
  redis_host: "localhost",
  redis_port: 6379
```

## Dependencies
- MPD
- Redis

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mpd_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mpd_client, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mpd_client](https://hexdocs.pm/mpd_client).

