function string.indexOf(str, substr)
  return string.find(str, substr, 1, true)
end

Events:Subscribe('Partition:Loaded', function(partition)
  if partition.guid ~= Guid('8A1B5CE5-A537-49C6-9C44-0DA048162C94') then
    return
  end

  for _, instance in pairs(partition.instances) do
    if instance:Is('ReferenceObjectData') then
      local refObjData = ReferenceObjectData(instance)

      -- check if blueprint exists
      if refObjData.blueprint == nil then
        return
      end

      -- check if blueprint name contains the 'Dynamic_VehicleSpawners' string and exclude it
      local name = refObjData.blueprint.name
      if string.indexOf(name, 'Dynamic_VehicleSpawners') ~= nil then
        refObjData:MakeWritable()
        refObjData.excluded = true
      end
    end
  end
end)
