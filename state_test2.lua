local robot = require("robot")
local sequence = require("sequence")
local state = require("state")

count = 0

sq0 = sequence()
st0 = state()

sq0:add(robot.turnLeft)

st0:onEnter(function() print("Hello!") end)
st0:loop(sq0)
st0:onTick(function() count = count + 1 end)
st0:transitionTo(nil, function() return count >= 12 end)
st0:onExit(function() print("I am so dizy!") end)

st0:enter()
