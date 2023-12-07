local m_Setting = SettingsManager:GetSetting("Enabled") or SettingsManager:DeclareBool("Enabled", true, { displayName = "Enabled", showInUi = true })
local m_SoundSetting = SettingsManager:GetSetting("Sound") or SettingsManager:DeclareBool("Sound", false, { displayName = "Headshot Sound Enabled", showInUi = true })

Events:Subscribe('Extension:Loaded', function()
  WebUI:Init()
  WebUI:ExecuteJS(string.format('enableSound(%s)', tostring(m_SoundSetting.value)))
end)

NetEvents:Subscribe('hit', function(damage, isHeadshot)
  if m_Setting.value then
    WebUI:ExecuteJS(string.format('addHit(%d, %s)', math.floor(damage), tostring(isHeadshot)))
  end
end)

Events:Subscribe('SettingsManager:SettingsChanged', function()
  WebUI:ExecuteJS(string.format('enableSound(%s)', tostring(m_SoundSetting.value)))
end)
