local config = require('__shared/config')

function isConsideredFreefall()
  local player = PlayerManager:GetLocalPlayer()

  if player == nil or player.soldier == nil then
    return false
  end

  local from = player.soldier.transform.trans
  local to = from - Vec3(0, config.minFreefallDistance, 0)
  local hit = RaycastManager:Raycast(from, to, RayCastFlags.CheckDetailMesh | RayCastFlags.DontCheckWater | RayCastFlags.DontCheckCharacter | RayCastFlags.DontCheckRagdoll)

  return hit == nil
end

function onParachuteSoundEvent(entity, entityEvent)
  if entityEvent.eventId == -1127517359 then
    if isConsideredFreefall() then
      Events:Dispatch('Player:FreefallStarted')
    end
  elseif entityEvent.eventId == -321661585 then
    Events:Dispatch('Player:ParachuteOpened')
  elseif entityEvent.eventId == -1396450457 then
    Events:Dispatch('Player:ParachuteClosed')
  end
end

Events:Subscribe('Player:Respawn', function (player)
  local it = EntityManager:GetIterator('SoundEntity')
  local entity = it:Next()

  while entity ~= nil do
    if entity.data.instanceGuid == Guid('63CDCA57-2E2C-45FF-A465-CF3EE42E5EE1') then
      entity:RegisterEventCallback(onParachuteSoundEvent)
    end

    entity = it:Next()
  end
end)
