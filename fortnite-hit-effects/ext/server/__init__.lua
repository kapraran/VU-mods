Hooks:Install('Soldier:Damage', 100, function(hookCtx, soldier, info, giverInfo)
  if info.damage <= 0.0 then return end
  if not giverInfo.giver then return end
  if giverInfo.giver.teamId == soldier.teamId then return end
  if soldier.isManDown then return end

  NetEvents:SendToLocal('hit', giverInfo.giver, info.damage, info.boneIndex == 1)
  hookCtx:Pass(soldier, info, giverInfo)
end)
