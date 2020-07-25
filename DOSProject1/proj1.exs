[a, b] = Enum.map(System.argv(), fn x -> String.to_integer(x) end)

FindingVampireNumber.BindingSupervisor.start_link #Initializing the BindingSupervisor
# FindingVampireNumber.BossCall.start_link
FindingVampireNumber.BossCall.startProcedure(a,b)
FindingVampireNumber.BossCall.printVampireData()
