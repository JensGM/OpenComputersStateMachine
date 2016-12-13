local robot = require("robot")
local sequence = require("sequence")
local state = require("state")
local pathToSequence = require("pathToSequence")
local map = require("map")()

-- Helper functions
local function ifInventoryIsFull() return InventoryIsFull() end
local function currentLocation() return ... end
--

-- Locations
local idol -- Inventory Dropoff Location
local csl -- Charging Station Localion
local wl -- Work Location
--

local miningSequence = sequence()
miningSequence.add(robot.forward)
miningSequence.add(map.record)
miningSequence.add(robot.swing)
miningSequence.add(robot.down)
miningSequence.add(map.record)
miningSequence.add(robot.swing)
miningSequence.add(robot.up)

local mining = state()
mining.loop(miningSequence)
mining.onExit(function() wl = currentLocation() end)
mining.transitionTo(emptyInventory, ifInventoryIsFull)
-- mining.transitionTo(charging, ifBatteryIsLow)

local startMiningSequence = nil
local startMining = state()
startMining.onEnter(
  function()
    local path = map.path(currentLocation(), wl)
    startMiningSequence = pathToSequence(path)
  end)
startMining.exec(startMiningSequence)
startMining.transitionTo(mining, startMiningSequence.isFinished)

local emptyInventorySequence = nil
local emptyInventory = state()
emptyInventory.onEnter(
  function()
    local path = map.path(currentLocation(), idol)
    emptyInventorySequence = pathToSequence(path)
  end)
emptyInventory.exec(emptyInventorySequence)
emptyInventory.transitionTo(startMining, emptyInventorySequence.ifFinished)
