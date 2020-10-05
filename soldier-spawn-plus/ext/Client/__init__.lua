Console:Register('spawn', 'Spawns the soldier in the specified position', function(args)
  -- check number of arguments
  if #args ~= 3 and #args ~= 0 then
    return 'Error: Specify a <x> <y> <z> position or leave it blank'
  end

  -- create the default transformation
  local player = PlayerManager:GetLocalPlayer()
  local trans = player.soldier.transform.trans
  trans.y = trans.y + 200

  -- update transformation based on user's input
  if #args == 3 then
    trans.x = tonumber(args[1])
    trans.y = tonumber(args[2])
    trans.z = tonumber(args[3])
  end

  -- check if coordinates are numeric
  if trans.x == nil or trans.y == nil or trans.z == nil then
    return 'Error: Spawn coordinates must be numeric.'
  end

  -- send event
  NetEvents:SendLocal('spawn', trans)
end)
