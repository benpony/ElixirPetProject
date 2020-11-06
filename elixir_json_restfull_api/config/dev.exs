use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.

config :elixir_json_restful_api,
       :endPoint,
       port: [port: 4000]

config :elixir_json_restful_api,
       :db,
       conn_str:
         System.get_env("ELIXIRDEMO_MONGO_URI") ||
           raise("environment variable ELIXIRDEMO_MONGO_URI is missing."),
       # db name
       database: "elixirdemo",
       # pool size
       pool_size: 3
