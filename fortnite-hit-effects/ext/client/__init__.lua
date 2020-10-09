Events:Subscribe('Extension:Loaded', function()
  WebUI:Init()
end)

NetEvents:Subscribe('hit', function(damage, isHeadshot)
  WebUI:ExecuteJS(string.format('addHit(%d, %s)', math.floor(damage), tostring(isHeadshot)))
end)

-- util to get current position
Events:Subscribe('Player:UpdateInput', function()
  if InputManager:WentKeyDown(InputDeviceKeys.IDK_F9) then
    local player = PlayerManager:GetLocalPlayer()
    if player == nil or player.soldier == nil then
      return
    end

    print(player.soldier.transform.trans)
  end
end)
