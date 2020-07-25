defmodule FindingVampireNumber.BossCall do
  use GenServer

  def init(state), do: {:ok, state}

  def handle_call({:start_procedure,x,y}, _from,[]) do
      # The main call by boss actor
     rangeDivideCall(x,y)
    {:reply, [], []}
  end

  def handle_call(:print_vampire_data, _from, []) do

     Enum.each(FindingVampireNumber.Holder.value, fn x-> IO.puts x end)
    {:reply, [], []}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: :newName)
  end

  def startProcedure(x,y), do: GenServer.call(:newName, {:start_procedure,x,y},300000)

  def printVampireData, do: GenServer.call(:newName, :print_vampire_data,300000)

  #THE DIVISION LOGIC
  # example : for range 100000 to 200000 (100000 elements) which is 10^5 => the smaller range size is 10^(5/2) which is 10^2
  #           This means 100000 is divided into 1000 parts with 100 elements to cover in it.
  # The advantage is this scales well, we don't need to worry if the actors are sufficient or not
  def rangeDivideCall(a1,a2) do

    # IO.puts "Boss Call check #{a1} & #{a2}"
    totalNumber = a2- a1 + 1
    temp = :math.log10(totalNumber)/1 |> Float.floor |> round
    setCount = temp/2 |> round


    intervalSize = :math.pow(10,setCount) |> round
    totalIntervals = totalNumber/intervalSize |> round

    if totalNumber <= totalIntervals do
      smallRange(totalIntervals,totalNumber,intervalSize,a1)
    else
      otherCases(totalIntervals,intervalSize,a1,a2)
    end

  end

  #Handling for small ranges where number of intervals are more than the total numbers that needs to be checked
  def smallRange(totalIntervals,totalNumber,intervalSize,a1) do
    totalIntervals = (totalNumber-1)
    intervals = Enum.map(1..totalIntervals,fn intervalNumber -> intervalBoundaries(intervalNumber,intervalSize, a1)end)
    intervals = [[a1,a1]| intervals]
    processes = Enum.map(intervals,fn [x,y] -> checkForVampireNumbers(x,y) end)
    #IO.inspect processes
    Enum.each(processes, fn x-> waitAndAppendToHolder(x) end)
  end

  # A normal case
  def otherCases(totalIntervals,intervalSize,a1,a2) do
    intervals = Enum.map(1..totalIntervals-1,fn intervalNumber -> intervalBoundaries(intervalNumber,intervalSize, a1)end)
    #IO.puts inspect(intervals)
    intervals = [[a1 + intervalSize*(totalIntervals-1) + 1, a2]|intervals]
    intervals = [[a1,a1]| intervals]
    processes = Enum.map(intervals,fn [x,y] -> checkForVampireNumbers(x,y) end)
    #IO.inspect processes
    Enum.each(processes, fn x-> waitAndAppendToHolder(x) end)
  end

  #Updating the list
  def waitAndAppendToHolder(x) do
      FindingVampireNumber.Holder.append(Task.await(x,100000000))
  end

  def intervalBoundaries(intervalNumber, intervalSize ,startNumber) do


      intervalStart = startNumber + intervalSize*(intervalNumber - 1) +1
      intervalEnd = intervalStart + intervalSize - 1

      [intervalStart , intervalEnd]
  end

  def checkForVampireNumbers(x,y) do
  # IO.puts "check vamp"
	 Task.Supervisor.async(FindingVampireNumber.ChunkSupervisor, fn ->
				FindingVampireNumber.ChunkHandler.processChunk(x,y)
			end, shutdown: :infinity)
  end
end
