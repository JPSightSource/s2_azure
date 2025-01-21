# S2Azure

Azure wrapper for Elixir using [:erlazure](https://github.com/gullitmiranda/erlazure).

## Installation

1. Add [`:s2_azure`](https://hex.pm/packages/s2_azure) to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:s2_azure, "~> 0.1.0"}]
  end
  ```

2. Ensure `s2_azure` is started before your application:

  ```elixir
  def application do
    [applications: [:s2_azure]]
  end
  ```

3. By default, S2Azure using the following configuration:

  ```elixir
  config :s2_azure,
      account:    System.get_env("AZURE_ACCOUNT"),
      access_key: System.get_env("AZURE_ACCESS_KEY")
  ```

## Usage

For now, the S2Azure is a simple wrapper to make the calls to the `erlazure`.
This way, you can just use `S2Azure.request/3` or `S2Azure.request!/3`  to make the calls.

Access ["Implemented API functions"](https://github.com/dkataskin/erlazure#implemented-api-functions) in `:erlazure` to all implemented functions.

examples:

```elixir
# get a list of containers
S2Azure.request(:list_containers)
{:ok,
 %{body: [{:blob_container, 'uploads', [],
     [last_modified: 'Tue, 05 Jul 2016 17:15:12 GMT',
      etag: '"0x8D3A4F7ECC4541F"', lease_status: :unlocked,
      lease_state: :available], []}], headers: [next_marker: []]}}

# get a list of blobs in "uploads" container
S2Azure.request(:list_blobs, ["uploads"])
{:ok, %{body: [], headers: [next_marker: []]}}
```

example of errors:

```elixir
# no matched function
S2Azure.request(:list_blobs)
{:error,
 %UndefinedFunctionError{arity: 1, function: :list_blobs, module: :erlazure,
  reason: nil}}

# raised error using request!/3
S2Azure.request!(:list_blobs)
** (UndefinedFunctionError) function :erlazure.list_blobs/1 is undefined or private. Did you mean one of:

      * list_blobs/2
      * list_blobs/3
      * list_blobs/4

    (erlazure) :erlazure.list_blobs(#PID<0.134.0>)
    (s2_azure) lib/s2_azure.ex:43: S2Azure.do_request/3
```

## Test

1. Getting your `AZURE_ACCOUNT` and `AZURE_ACCESS_KEY` in ( https://portal.azure.com ) and adding to `.env` file:

  ```sh
  echo "AZURE_ACCOUNT=value" >> .env
  echo "AZURE_ACCESS_KEY=value" >> .env
  ```

  > see [`.env.sample`](./.env.sample) for example.

2. run tests

  ```sh
  azk shell -t -- mix do deps.get
  azk shell -t -- mix test
  ```

# Contributing

1. Fork it ( https://github.com/azukiapp/s2_azure/fork )
2. Create your feature branch (git checkout -b feature/new_feature_name)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin feature/new_feature_name)
5. Create a new Pull Request

# TODO

- [ ] Add more docs:
- [ ] Add clients to a syntaxe more elegant and greater flexibility:
  sample:

  ```elixir
  # use
  S2Azure.Blobs.list("uploads")
  # instead of
  S2Azure.request(:list_blobs, ["uploads"])
  ```
- [ ] Add CI
s
