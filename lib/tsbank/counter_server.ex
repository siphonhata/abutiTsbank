defmodule Tsbank.CounterServer do
  use GenServer

  # Callbacks

  def handle_call(:increment, _from, state) do
    {:reply, :ok, state + 1}
  end

  def handle_call(:decrement, _from, state) do
    {:reply, :ok, state - 1}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def start_link(init_value \\ 0) do
    GenServer.start_link(__MODULE__, init_value, name: __MODULE__)
  end

  # Client API

  def increment do
    GenServer.call(__MODULE__, :increment)
  end

  def decrement do
    GenServer.call(__MODULE__, :decrement)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def init(init_arg) do
    {:ok, init_arg}
    #start_link(0)
  end
end
