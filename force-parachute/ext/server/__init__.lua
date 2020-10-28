local shouldOpenParachute = {}
local pending = 0

NetEvents:Subscribe('OpenParachute', function (player)
  -- add player to the map of the players that their parachute should open
  if shouldOpenParachute[player] == nil then
    shouldOpenParachute[player] = true
    pending = pending + 1
  end
end)

Events:Subscribe('Player:UpdateInput', function(player, deltaTime)
  if pending < 1 then
    return
  end

  for player, isTrue in pairs(shouldOpenParachute) do
    if isTrue then
      player.input:SetLevel(EntryInputActionEnum.EIAToggleParachute, 1.0)
      pending = pending - 1
      shouldOpenParachute[player] = nil
    end
  end
end)
