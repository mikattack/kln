---------------------------------------------------------------------
-- Addon startup
---------------------------------------------------------------------

local _, ns = ...

ns.onload = CreateFrame("Frame", nil, UIParent)
ns.onload:RegisterEvent("ADDON_LOADED")
ns.onload:SetScript("OnEvent", function (self, event, addon, ...)
  if addon ~= ns.addon_name then return end
  if event == "ADDON_LOADED" then
    -- Only need to set up once
    self:UnregisterEvent('ADDON_LOADED')
    self:SetScript("OnEvent", nil)

    -- Create persistent variables if they don't exist
    if not _G["kln_profiles"] then _G["kln_profiles"] = {} end
    if not _G["kln_character"] then
      _G["kln_character"] = { profile=nil }
    end

    -- Ensure there's a default profile, even if it's empty
    if not kln_profiles.default then
      kln_profiles.default = {}
    end

    -- Load appropriate profile for the character
    if not kln_character.profile then
      character, realm = UnitName('player')
      ns.profiles:Load(character)
    else
      ns.profiles:Load(kln_character.profile)
    end

  end
end)