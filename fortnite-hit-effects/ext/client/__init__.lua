Events:Subscribe('Extension:Loaded', function()
  WebUI:Init()
end)

NetEvents:Subscribe('hit', function(damage, isHeadshot)
  WebUI:ExecuteJS(string.format('addHit(%d, %s)', math.floor(damage), tostring(isHeadshot)))
end)
