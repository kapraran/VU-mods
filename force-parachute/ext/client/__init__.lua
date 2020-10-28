local config = require('__shared/config')
require('parachute-events')

local isChecking = false
local sinceLastCheck = 0

function startChecking()
  isChecking = true
end

function stopChecking()
  isChecking = false
end

Events:Subscribe('Player:FreefallBegin', startChecking)
Events:Subscribe('Player:ParachuteBegin', stopChecking)
Events:Subscribe('Player:ParachuteEnd', stopChecking)

Events:Subscribe('Engine:Update', function(deltaTime, simulationDeltaTime)
  sinceLastCheck = sinceLastCheck + deltaTime

  -- skip if not enough time has passed
  if not isChecking or sinceLastCheck < config.raycastEverySec then
    return
  end

  local player = PlayerManager:GetLocalPlayer()

  -- stop checking if player disappeared
  if player == nil or player.soldier == nil then
    stopChecking()
    return
  end

  -- reset timer
  sinceLastCheck = 0

  -- raycast to check if soldier is at <= min height from the ground
  local from = player.soldier.transform.trans
  local to = from - Vec3(0, config.parachuteOpenDistance, 0)
  local hit = RaycastManager:Raycast(from, to, RayCastFlags.CheckDetailMesh | RayCastFlags.DontCheckWater | RayCastFlags.DontCheckCharacter | RayCastFlags.DontCheckRagdoll)

  -- if there's a hit then open the parachute
  if hit ~= nil then
    NetEvents:SendLocal('OpenParachute')
  end
end)
