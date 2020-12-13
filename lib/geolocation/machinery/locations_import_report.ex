defmodule Geolocation.Machinery.LocationsImportReport do
  defstruct accepted: 0, discarded: 0, noop: 0

  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def report_accepted(quantity \\ 1), do: update(:accepted, quantity)
  def report_discarded(quantity \\ 1), do: update(:discarded, quantity)
  def report_noop(quantity \\ 1), do: update(:noop, quantity)

  def get_report do
    Agent.get(__MODULE__, & &1)
  end

  def clear_report do
    Agent.update(__MODULE__, fn _ -> %__MODULE__{} end)
  end

  defp update(field, quantity) do
    Agent.update(__MODULE__, fn machine_state ->
      Map.update!(machine_state, field, fn current -> current + quantity end)
    end)
  end
end
