-- A timers library for Venice Unleashed
--
-- @author  Nikos Kapraras
-- @website kapraran.dev
--

-- TimerClass
local TimersClass = class('TimersClass')

function TimersClass:__init()
  self.lastId = 1
  self.activeTimers = 0
  self.timers = {}
  self.updateEvent = nil
end

function TimersClass:Update(deltaTime, simulationDeltaTime)
  for id, timer in pairs(self.timers) do
    if timer ~= nil then
      timer:Update(deltaTime)
    end
  end
end

function TimersClass:Remove(timer)
  if self.timers[timer.id] == nil then
    return
  end

  self.timers[timer.id] = nil

  -- unsubscribe from update event if needed
  self.activeTimers = self.activeTimers - 1
  if self.updateEvent ~= nil and self.activeTimers < 1 then
    self.updateEvent:Unsubscribe()
    self.updateEvent = nil
  end
end

function TimersClass:CreateTimer(delay, cycles, userData, callback)
  self.lastId = self.lastId + 1
  local timer = Timer(self, tostring(self.lastId), delay, cycles, userData, callback)
  self.timers[timer.id] = timer

  -- subscribe to update event if needed
  self.activeTimers = self.activeTimers + 1
  if self.updateEvent == nil then
    self.updateEvent = Events:Subscribe('Engine:Update', self, self.Update)
  end

  return timer
end

-- run once after the specified delay
function TimersClass:Timeout(delay, userData, callback)
  return self:CreateTimer(delay, 1, userData, callback)
end

-- run for a certain amount of times with the specified delay in between calls
function TimersClass:Sequence(delay, cycles, userData, callback)
  return self:CreateTimer(delay, cycles, userData, callback)
end

-- run forever with the specified delay in between calls
function TimersClass:Interval(delay, userData, callback)
  return self:CreateTimer(delay, 0, userData, callback)
end

-- Timer
local Timer = class('Timer')

function Timer:__init(master, id, delay, cycles, userData, callback)
  self.master = master
  self.id = id
  self.delay = delay
  self.cycles = cycles
  self.userData = userData
  self.callback = callback

  if userData ~= nil and callback == nil then
    self.userData = nil
    self.callback = userData
  end

  self.currentCycle = 0
  self.currentDelta = 0
end

-- update timer's delta
function Timer:Update(delta)
  self.currentDelta = self.currentDelta + delta

  if self.callback ~= nil and self.currentDelta > self.delay then
    -- call the callback
    if self.userData ~= nil then
      self.callback(self.userData, self)
    else
      self.callback(self)
    end

    -- move to next cycle
    local extraTime = self.currentDelta - self.delay
    if self:Next() then
      self.currentDelta = extraTime
    else
      self:Destroy()
    end
  end
end

-- move to the next cycle
function Timer:Next()
  if self.cycles == 0 then
    return true
  end

  -- increment cycle counter
  self.currentCycle = self.currentCycle + 1
  if self.currentCycle >= self.cycles then
    self.currentCycle = self.cycles
    return false
  end

  self.currentDelta = 0
  return true
end

-- destroy the timer
function Timer:Destroy()
  self.master:Remove(self)

  self.callback = nil
  self.userData = nil
end

-- 
function Timer:Elapsed()
  return self.currentCycle * self.delay + self.currentDelta
end

-- 
function Timer:Remaining()
  return 0
end

-- init Timers singleton
Timers = TimersClass()
