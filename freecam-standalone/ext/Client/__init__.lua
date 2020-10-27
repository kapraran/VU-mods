local FreeCam = require('Freecam')

local isFreeCamEnabled = false

function toggleFreecam()
  isFreeCamEnabled = not isFreeCamEnabled

  if isFreeCamEnabled then
    FreeCam:Enable()
  else
    FreeCam:Disable()
  end
end

-- move player where the freecam is
function movePlayer()
  if(FreeCam.m_CameraData ~= nil) then
    local player = PlayerManager:GetLocalPlayer()

    if player == nil or player.soldier == nil then
      return
    end

    local cameraPos = FreeCam.m_CameraData.transform.trans
    local from = cameraPos
    local to = cameraPos - Vec3(0, 200, 0)
    local hit = RaycastManager:Raycast(from, to, RayCastFlags.CheckDetailMesh | RayCastFlags.DontCheckWater | RayCastFlags.DontCheckCharacter | RayCastFlags.DontCheckRagdoll)

    if hit ~= nil then
      NetEvents:SendLocal('player:move', hit.position + Vec3(0, 3, 0))
    end
  end
end

Events:Subscribe('Client:UpdateInput', function(p_Delta)
  FreeCam:OnUpdateInput(p_Delta)
end)

Hooks:Install('Input:PreUpdate', 200, function (p_Hook, p_Cache, p_DeltaTime)
  FreeCam:OnUpdateInputHook(p_Hook, p_Cache, p_DeltaTime)
end)

Events:Subscribe('Player:UpdateInput', function()
  if InputManager:WentKeyDown(InputDeviceKeys.IDK_F5) and not circleStarted then
    toggleFreecam()
  end

  if InputManager:WentKeyDown(InputDeviceKeys.IDK_F6) and not circleStarted then
    movePlayer()
  end
end)
