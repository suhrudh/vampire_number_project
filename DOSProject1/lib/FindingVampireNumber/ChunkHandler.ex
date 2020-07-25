defmodule FindingVampireNumber.ChunkHandler do
 use Task , restart: :transient

 def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
 end

 def processChunk(x,y) do
    l=Enum.filter(Enum.map(x..y,fn number -> FindingVampireNumber.Vamp.start(number) end),& !is_nil(&1))

    Enum.map(l, fn x-> Enum.join(x," ") end)
 end
end
