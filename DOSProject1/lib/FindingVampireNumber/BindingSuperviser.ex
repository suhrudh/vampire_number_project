defmodule FindingVampireNumber.BindingSupervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__,[])
  end

  def init(_) do
    # IO.puts "entered supervisor"
    children = [{FindingVampireNumber.BossCall,[]},
                {Task.Supervisor, name: FindingVampireNumber.ChunkSupervisor, restart: :transient},
                {FindingVampireNumber.Holder, []}
              ]
    Supervisor.init(children, strategy: :one_for_one, shutdown: :infinity)
  end
end
