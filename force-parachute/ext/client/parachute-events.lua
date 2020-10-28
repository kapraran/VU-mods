local config = require('__shared/config')

-- get event hashed IDs
local evHash = {
  FreefallBegin = MathUtils:FNVHash('FreefallBegin'),
  ParachuteBegin = MathUtils:FNVHash('ParachuteBegin'),
  ParachuteEnd = MathUtils:FNVHash('ParachuteEnd')
}

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
  if entityEvent.eventId == evHash.FreefallBegin then
    if isConsideredFreefall() then
      Events:Dispatch('LocalPlayer:FreefallBegin')
    end
  elseif entityEvent.eventId == evHash.ParachuteBegin then
    Events:Dispatch('LocalPlayer:ParachuteBegin')
  elseif entityEvent.eventId == evHash.ParachuteEnd then
    Events:Dispatch('LocalPlayer:ParachuteEnd')
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
