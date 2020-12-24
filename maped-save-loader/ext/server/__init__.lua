local config = require('config')
local wasMapLoaded = false

function DecodeParams(p_Table)
  if(p_Table == nil) then
    print("No table received")
    return false
  end

  for s_Key, s_Value in pairs(p_Table) do
    if s_Key == 'transform' then
      local s_LinearTransform = LinearTransform(
      Vec3(s_Value.left.x, s_Value.left.y, s_Value.left.z),
      Vec3(s_Value.up.x, s_Value.up.y, s_Value.up.z),
      Vec3(s_Value.forward.x, s_Value.forward.y, s_Value.forward.z),
      Vec3(s_Value.trans.x, s_Value.trans.y, s_Value.trans.z))

      p_Table[s_Key] = s_LinearTransform
    elseif type(s_Value) == "table" then
      s_Value = DecodeParams(s_Value)
    end
  end

  return p_Table
end

function GetLastId()
  -- if not SQL:Open() then
  --   return
  -- end

  local row = SQL:Query("SELECT seq FROM sqlite_sequence WHERE name='project_header'")[1]
  return tonumber(row['seq'])
end

function LoadMapData(id)
  if not SQL:Open() then
    return
  end

  id = id or GetLastId()

  -- get map project headers
  local rawMapHeader = SQL:Query("SELECT * FROM 'project_header' where id = " .. tostring(id))[1]
  local mapHeader = {
    projectName = rawMapHeader['project_name'],
    mapName = rawMapHeader['map_name'],
    gameModeName = rawMapHeader['gamemode_name'],
    requiredBundles = rawMapHeader['required_bundles'],
    timeStamp = rawMapHeader['timestamp'],
    id = rawMapHeader['id']
  }

  -- get map project data
  local rawMapData = SQL:Query("SELECT * FROM 'project_data' where id = " .. tostring(id))[1]
  local mapJSON = rawMapData['save_file_json']
  local decodedData = DecodeParams(json.decode(mapJSON))

  -- send event to load the map
  Events:Dispatch('MapLoader:LoadLevel', {
    header = mapHeader,
    data = decodedData,
    vanillaOnly = false
  })
  RCON:SendCommand('mapList.restartRound')
end

Events:Subscribe('Level:Loaded', function ()
  -- load the map data (once)
  if not wasMapLoaded then
    wasMapLoaded = true
    LoadMapData()
  end
end)

Events:Subscribe('Player:Respawn', function(player)
  if player == nil or player.soldier == nil then
    return
  end

  local transform = LinearTransform()
  transform.trans = config.spawnPosition

  player.soldier:SetTransform(transform)
end)
