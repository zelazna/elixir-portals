defmodule PortalTest do
  use ExUnit.Case
  doctest Portal
  # "setup" is called before each test
  setup do
    Portal.Door.start_link(:blue)
    Portal.Door.start_link(:red)
    :ok
  end

  test "transfer the datas" do
    assert Portal.transfer(:blue, :red, [1,2,3])
  end

  test "push the datas in the portals" do
    portal = Portal.transfer(:blue, :red, [1,2,3])
    Portal.push(portal, :right)
    assert Portal.Door.get(:red) == [3]
    assert Portal.Door.get(:blue) == [2,1]
    Portal.push(portal, :left)
    assert Portal.Door.get(:red) == []
    assert Portal.Door.get(:blue) == [3,2,1]
  end
end
