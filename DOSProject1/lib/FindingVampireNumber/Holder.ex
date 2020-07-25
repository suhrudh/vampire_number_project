defmodule FindingVampireNumber.Holder do
use Agent

def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: :vampire_number_list)
  end

  def value do
    Agent.get(:vampire_number_list, & &1)
  end

  def append(list) do
    Agent.update(:vampire_number_list, &(&1 ++ list))
  end
end
