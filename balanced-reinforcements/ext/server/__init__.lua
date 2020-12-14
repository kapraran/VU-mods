require('__shared/timers')

local config = require('__shared/config')
local originalTickets = 75
local prevTickets = originalTickets

-- calculate original tickets value using RCON
-- function calcOriginalTickets()
--   local modifier = 1

--   local result = RCON:SendCommand('vars.gameModeCounter')
--   if result[1] == 'OK' then
--     modifier = tonumber(result[2])/100
--   end

--   originalTickets = math.floor(75 * modifier)
-- end

-- Update the attackers' tickets
function updateTickets()
  -- calculate the number of tickets to add
  local addedTickets = config.ReinforcementsFixed
  if addedTickets < 1 then
    local prc = config.ReinforcementsPercent / 100
    addedTickets = math.floor(originalTickets * prc)
  end

  -- calculate the total number of tickets
  local totalTickets = math.min(originalTickets, prevTickets + addedTickets)

  TicketManager:SetTicketCount(1, totalTickets)
end

-- Listen for 'IncreaseReinforce' event and update the tickets
function attachListeners()
  local it = EntityManager:GetIterator('ServerLifeCounterEntity')
  local entity = it:Next()
  while entity ~= nil do
    entity:RegisterEventCallback(function(ent, entityEvent)
      if entityEvent.eventId ~= MathUtils:FNVHash('IncreaseReinforce') then
        return
      end

      prevTickets = TicketManager:GetTicketCount(1)

      -- i have to add a delay cause the engine updates 
      -- the tickets after this callback
      Timers:Timeout(0.35, updateTickets)
    end)
    entity = it:Next()
  end
end

Events:Subscribe('Level:Loaded', function()
  if SharedUtils:GetCurrentGameMode() ~= 'RushLarge0' then 
    return
  end

  -- set original tickets
  Timers:Interval(0.35, function(timer)
    local tickets = TicketManager:GetTicketCount(1)
    if tickets > 0 then
      originalTickets = tickets
      timer:Destroy()
    end
  end)

  attachListeners()
end)
