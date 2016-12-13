local sequence = {}
sequence.__index = sequence

setmetatable(sequence, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function sequence:_init(...)
  self.looping = false
  self.curStep = 1
  self.members = {}
end

function sequence:add(f)
  table.insert(self.members, f)
end

function sequence:step()
  if self.looping then
    self.curStep = (self.curStep % #self.members) + 1
  end
  if self.curStep > #self.members then return end

  self.members[self.curStep]()
  self.curStep = self.curStep + 1
end

function sequence:count()
  return #self.members
end

function sequence:currentStep()
  return self.curStep
end

function sequence:setLooping(looping)
  self.looping = looping
end

function sequence:isLooping()
  return self.looping
end

function sequence:isFinished()
  return not self:isLooping() and self:currentStep() > self:count()
end

function sequence:isFinishedPred()
  local s = self
  return function() return not s:isLooping() and s:currentStep() > s:count() end
end

return sequence
