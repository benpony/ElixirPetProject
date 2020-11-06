defmodule ElixirJsonRestfulApi.UserEndpoint do
  @moduledoc """
  User Model :
  ```
    {
      "username": "",
      "password": "",
      "lastName": "",
      "firstName": "",
      "email": "",
    }
  ```

  User endpoints :
  - /users : get all users (GET)
  - /user-by-email : find user by email (POST)
  - /user-by-user-name : find user by username (POST)
  - /add-user : add a new user (POST)
  - /delete-user : delete an existing user (POST)
  - /update-user-email : update an existing user by email (POST)
  - /update-update-user-name : update an existing user by username (POST)

  """
  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:
  # Using Plug.Logger for logging request information
  plug(Plug.Logger)

  # responsible for matching routes
  plug(:match)

  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  # responsible for dispatching responses
  plug(:dispatch)

  alias ElixirJsonRestfullApi.UserWriter
  alias ElixirJsonRestfullApi.UserReader
  alias ElixirJsonRestfullApi.ServiceUtils

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  # Get all users
  get "/users" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{response: "This a test message !"}))
  end

  get "/dbtest" do
    UserWriter.add_user(%{
      "username" => "user-#{:rand.uniform(100)}",
      "password" => "secret-#{:rand.uniform(100)}",
      "firstName" => "test-#{:rand.uniform(100)}",
      "lastName" => "test-#{:rand.uniform(100)}",
      "email" => "text@#{:rand.uniform(100)}.com"
    })

    # Gets an enumerable cursor for the results
    users = ServiceUtils.endpoint_success(
      UserReader.find_all_users()
    )

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200,users)
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "Unknown request :( !")
  end
end
