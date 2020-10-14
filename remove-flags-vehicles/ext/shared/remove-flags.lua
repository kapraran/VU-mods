local partitionGuid = Guid('B6BD6848-37DF-463A-81C5-33A5B3D6F623')
local flagGuids = {
  A= Guid('44415363-CD27-4485-83A1-631CBCE7C5F6'),
  B= Guid('8A3675FF-BB0F-478D-8554-14912DCEEF20'),
  C= Guid('55645542-9AEC-4034-892C-14DAFDF808AD'),
  D= Guid('917C88B8-83AD-4A9D-8252-7EF68E4CEC38'),
  E= Guid('7A848B1C-CE40-4E5F-9F9A-A968F27393F4'),
  F= Guid('45A8C965-D60B-4892-A696-C40486915356'),
  G= Guid('E6BE3528-73F1-454E-B92E-C738CEB235D5')
}

for _, flagGuid in pairs(flagGuids) do
  ResourceManager:RegisterInstanceLoadHandler(partitionGuid, flagGuid, function(instance)
    local refobjInstance = ReferenceObjectData(instance)
  
    refobjInstance:MakeWritable()
    refobjInstance.excluded = true
  end)
end
