-- Transitions
local transition = {}
transition.__index = transition

setmetatable(transition, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function transition:_init(st, pred)
  self.st = st
  self.predicate = pred
end

function transition:state()
  return self.st
end

function transition:test()
  return self.predicate()
end
--

-- States
local state = {}
state.__index = state

setmetatable(state, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function state:_init(...)
  self.running = false
  self.onEnterCallback = nil
  self.onExitCallback = nil
  self.sequence = nil
  self.transitions = {}
end

function state:loop(sequence)
  self.sequence = sequence
  self.sequence:setLooping(true)
end

function state:exec(sequence)
  self.sequence = sequence
  self.sequence:setLooping(false)
end

function state:transitionTo(st, pred)
  table.insert(self.transitions, transition(st, pred))
end

function state:enter()
  self.running = true
  if self.onEnterCallback then self.onEnterCallback() end
  return self:_main()
end

function state:exit()
  self.running = false
  if self.onExitCallback then self.onExitCallback() end
end

function state:onEnter(callback)
  self.onEnterCallback = callback
end

function state:onExit(callback)
  self.onExitCallback = callback
end

function state:_main()
  local nextState = nil

  while self.running do
    -- Check transitions
    for i,v in ipairs(self.transitions) do
      if v:test() then
        nextState = v:state()
        self.running = false
        break
      end
    end
    if not self.running then break end

    -- Step current
    if self.sequence:isFinished() then
      self.running = false
      break;
    else
      self.sequence:step()
    end
  end

  self:exit()
  return nextState
end
--

return state
