NetEvents:Subscribe('player:move', function (player, position)
  if player == nil or player.soldier == nil then
    return
  end

  player.soldier:SetPosition(position)
end)
