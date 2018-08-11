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

    -- Session storage
    _G.kln_profiles  = _G.kln_profiles or {}
    _G.kln_character = _G.kln_character or {}

    -- Initialize events
    ns.events = ns.lib.EventHandler:New()

    -- Initialize profile management
    ns.profiles = ns.lib.ProfileManager:New(kln_profiles, kln_character)
    if not ns.profiles:Current() then
      character, realm = UnitName('player')
      ns.profiles:Load(character)
    end

  end
end)