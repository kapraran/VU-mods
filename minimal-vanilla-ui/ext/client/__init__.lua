require('config')
require('ui-disabling')

Events:Subscribe('Partition:Loaded', function(partition)
  for _, instance in pairs(partition.instances) do
    -- disables snapping of 3d icons around the screen
    if instance:Is('UI3dIconCompData') then
      local ui3d = UI3dIconCompData(instance)

      -- workaround cause .snapIcons doesn't work for all UI3dIconCompData
      ui3d:MakeWritable()
      ui3d.trackerHudRadiusX = 20
      ui3d.trackerHudRadiusY = 20
      ui3d.circularSnap = true
    end

    -- nametags
    if instance:Is('UINametagCompData') then
      local nametag = UINametagCompData(instance)

      nametag:MakeWritable()
      nametag.drawDistance = g_Config.nametagDrawDistance

      -- fade
      nametag.maxCloseFade = 0.1
      nametag.maxFarFade = 0.5
      nametag.fadeDistance = g_Config.nametagFadeDistance * 0.25
      nametag.fadeEndDistance = g_Config.nametagFadeDistance

      -- scale
      nametag.scaleDistance = g_Config.nametagFadeDistance
      nametag.maxScaleMod = 0.2

      -- minimize appearance
      nametag.healthBarSize = 8
      nametag.nameFontSize = 0
      nametag.nameGlowSize = 0
      nametag.iconSize = 0

      nametag.tooltipCooldown = 0.001
      -- nametag.maxXRotation = 1
      -- nametag.maxYRotation = 1
      nametag.showLabelRange = 10
    end

    -- flagtags
    if instance:Is('UICapturepointtagCompData') then
      local flagtag = UICapturepointtagCompData(instance)

      flagtag:MakeWritable()
      flagtag.drawDistance = 10000

      -- snap when in flag radius
      flagtag.shrinkSnapAnimationTime = 0.1
      flagtag.snapCenterYOffset = 0.06

      -- fade
      flagtag.maxCloseFade = 0
      flagtag.maxFarFade = g_Config.flagtagFarOpacity
      flagtag.fadeDistance = 0.75 * g_Config.flagtagFadeDistance
      flagtag.fadeEndDistance = g_Config.flagtagFadeDistance

      -- scale
      flagtag.scaleDistance = g_Config.flagtagFadeDistance
      flagtag.maxScaleMod = 0.4

      -- flagtag.iconSize = 20
      -- flagtag.showLabelRange = 128
      -- flagtag.snapSafeZone = 1
      -- flagtag.verticalOffsetMaxOffset = 0
    end
  
    if instance:Is('UIMapmarkertagCompData') then
      local mapMarker = UIMapmarkertagCompData(instance)

      mapMarker:MakeWritable()
      mapMarker.iconSize = 10
      mapMarker.maxFarFade = 0.16
      mapMarker.fadeEndDistance = 100
    end
  end
end)
