local m_Setting = SettingsManager:GetSetting("Enabled") or SettingsManager:DeclareBool("Enabled", true, { displayName = "Enabled", showInUi = true })

Events:Subscribe('Extension:Loaded', function()
  WebUI:Init()
end)

NetEvents:Subscribe('hit', function(damage, isHeadshot)
  if m_Setting.value then
    WebUI:ExecuteJS(string.format('addHit(%d, %s)', math.floor(damage), tostring(isHeadshot)))
  end
end)
