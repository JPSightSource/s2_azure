defmodule S2Azure.ServerTest do
  use ExUnit.Case

  @module S2Azure.Server

  test "get config from state" do
    config = GenServer.call(@module, :config)

    assert config[:access_key] == Application.get_env(:s2_azure, :access_key)
    assert config[:account]    == Application.get_env(:s2_azure, :account)
  end

  test "get client pid from state" do
    assert Application.get_application(:erlazure) == :erlazure
    assert Application.ensure_started(:s2_azure) == :ok

    assert is_pid(GenServer.call(@module, :client))
  end
end
