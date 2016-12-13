local robot = require("robot")
local sequence = require("sequence")
local state = require("state")

sq0 = sequence()
sq1 = sequence()
st0 = state()
st1 = state()

sq0:add(robot.forward)
sq0:add(robot.turnRight)
sq0:add(robot.forward)
sq0:add(robot.turnRight)
sq0:add(robot.forward)
sq0:add(robot.turnRight)
sq0:add(robot.forward)
sq0:add(robot.turnRight)

sq1:add(robot.turnLeft)
sq1:add(robot.turnLeft)
sq1:add(robot.turnLeft)
sq1:add(robot.turnLeft)

st0:onEnter(function() print("Hello!") end)
st0:exec(sq0)
st0:transitionTo(st1, sq0:isFinishedPred())
st0:onExit(function() print("Moving on!") end)

st1:onEnter(function() print("Hello again!") end)
st1:exec(sq1)
st1:onExit(function() print("Terminate!") end)

st = st0
while st do
  st = st:enter()
end
