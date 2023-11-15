defmodule BankSupervisor do
  # Defines the BankSupervisor as a Supervisor
  use Supervisor

  # Starts the supervisor
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: :bank_supervisor)
  end

  # Initializes the supervisor with BankAccount as its child
  def init(:ok) do
    children = [
      BankRegistry,
     # {BankAccount, 1000}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end 
end
