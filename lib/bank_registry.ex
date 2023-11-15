defmodule BankRegistry do
  # Starts the unique registry for BankAccounts
  def start_link do
    Registry.start_link(keys: :unique, name: BankRegistry)
  end

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
