defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """
  defstruct [:left, :right]
  
  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    # First add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end
  
    # Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end
  
  # @doc """
  # Pushes data to the given direction in the `portal`.
  # """
  def push(portal, direction) do
    portals = [portal.left, portal.right]
    portals = 
      case direction do
        :left -> Enum.reverse(portals)
        :right -> portals 
      end

    case Portal.Door.pop(List.first(portals)) do
      :error   -> :ok
      {:ok, h} -> Portal.Door.push(List.last(portals), h)
    end
    portal
  end

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door  = inspect(left)
    right_door = inspect(right)

    left_data = 
      left 
        |> Portal.Door.get 
        |> Enum.reverse 
        |> inspect

    right_data = 
      right 
        |> Portal.Door.get 
        |> inspect

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.pad_leading(left_door, max)} <=> #{right_door}
      #{String.pad_leading(left_data, max)} <=> #{right_data}
    >
    """
  end
end