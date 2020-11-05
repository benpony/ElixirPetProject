defmodule ElixirJsonRestfulApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ElixirJsonRestfulApi.Worker.start_link(arg)
      # {ElixirJsonRestfulApi.Worker, arg}

      # Start HTTP server
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ElixirJsonRestfulApi.UserEndpoint,
        options:
          Application.get_env(
            :elixir_json_restful_api,
            :endPoint
          )[:port]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      name: ElixirJsonRestfulApi.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
