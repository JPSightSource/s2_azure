defmodule S2Azure do
  @moduledoc File.read!("#{__DIR__}/../README.md")
  use Application

  alias S2Azure.{
    Server,
    Utils,
  }

  def defaults(config) do
    config
    |> Keyword.put_new(:account   , Application.get_env(:s2_azure, :account   ))
    |> Keyword.put_new(:access_key, Application.get_env(:s2_azure, :access_key))
  end

  def config do
    GenServer.call(Server, :config)
  end

  def client do
    GenServer.call(Server, :client)
  end

  @spec request(atom) :: {:ok, term} | {:error, term}
  @spec request(atom, Keyword.t) ::  {:ok, term} | {:error, term}
  @spec request(atom, Keyword.t, Keyword.t) ::  {:ok, term} | {:error, term}
  def request(action, args \\ [], opts \\ []) do
    try do
      {:ok, do_request(action, args, opts)}
    rescue error ->
      {:error, error}
    end
  end

  @spec request!(atom) :: {:ok, term} | {:error, term}
  @spec request!(atom, Keyword.t) ::  {:ok, term} | {:error, term}
  @spec request!(atom, Keyword.t, Keyword.t) ::  {:ok, term} | {:error, term}
  def request!(action, args \\ [], opts \\ []) do
    do_request(action, args, opts)
  end

  defp do_request(action, args, opts) when is_atom(action) do
    args = args |> Utils.normalize_to_charlist

    client = opts |> Keyword.get(:client, client())
    apply(:erlazure, action, [client] ++ args)
    |> parse_response
  end

  defp parse_response({:error, _} = response), do: response
  defp parse_response({:ok   , _} = response), do: response
  defp parse_response({body, headers}) do
    %{ body: body, headers: headers }
  end

  @doc false
  def start(_type, _args) do
    # import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # supervisor(:erlazure_sup, []),
      {S2Azure.Server, []},
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: S2Azure.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(_state) do
    :ok
  end
end
