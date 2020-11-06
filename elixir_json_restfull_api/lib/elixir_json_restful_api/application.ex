defmodule ElixirJsonRestfulApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Starts an pooled connection
    # Mongo.start_link(
    #   url:
    #     Application.get_env(
    #       :elixir_json_restful_api,
    #       :db
    #     )[:conn_str],
    #   pool_size: 3
    # )

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
      ),
      worker(Mongo, [
        [
          url:
            Application.get_env(
              :elixir_json_restful_api,
              :db
            )[:conn_str],
          name: :mongo,
          database:
            Application.get_env(
              :elixir_json_restful_api,
              :db
            )[:database],
          pool_size:
            Application.get_env(
              :elixir_json_restful_api,
              :db
            )[:pool_size]
        ]
      ])
    ]

    opts = [
      strategy: :one_for_one,
      name: ElixirJsonRestfulApi.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
