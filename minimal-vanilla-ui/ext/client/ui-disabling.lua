function editNodes(screen, selectedNodes, checkValue)
  checkValue = checkValue or nil

  local clone = screen:Clone(screen.instanceGuid)
  local screenClone = UIGraphAsset(clone)

  for i = #screen.nodes, 1, -1 do
    local node = screen.nodes[i]

    if node ~= nil then
      if selectedNodes[node.name] ~= checkValue then
        screenClone.nodes:erase(i)
      end
    end
  end

  return screenClone
end

function toHT(nodeNames)
  local ht = {}
  for i, name in ipairs(nodeNames) do
    ht[name] = true
  end
  return ht
end

function eraseNodes(screen, nodeNames)
  return editNodes(screen, toHT(nodeNames), nil)
end

function keepNodes(screen, nodeNames)
  return editNodes(screen, toHT(nodeNames), true)
end

Hooks:Install('UI:PushScreen', 999, function(hook, screen, graphPriority, parentGraph)
  local screen = UIGraphAsset(screen)

  if screen.name == 'UI/Flow/Screen/HudMPScreen' then
    hook:Pass(eraseNodes(screen, {
      'Ammo',
      'Health',
      'VehicleHealth',
      'SupportIconManager',
      'ScoreAggregator',
      'HudInformationMessage'
    }), graphPriority, parentGraph)
  end

  if screen.name == 'UI/Flow/Screen/HudScreen' then
    hook:Pass(eraseNodes(screen, {
      'DamageIndicator',
      'LogMessage',
      'HudSubtitleMessage',
      'ObjectiveMessage',
      'TooltipMessage',
      'AlertManager',
      'ShowObjectiveSound',
    }), graphPriority, parentGraph)
  end

  if screen.name == 'UI/Flow/Screen/HudConquestScreen' then
    hook:Pass(eraseNodes(screen, {
      'HudBackgroundWidget',
      'Compass',
      'HeadshotKillSound',
      'DefaultKillSound',
      'SquadList'
    }), graphPriority, parentGraph)
  end
end)
