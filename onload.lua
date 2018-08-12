---------------------------------------------------------------------
-- Addon startup
---------------------------------------------------------------------

local _, ns = ...


local Loader = CreateFrame("Frame", nil, UIParent)
Loader:RegisterEvent("ADDON_LOADED")
Loader:SetScript("OnEvent", function(self, event, ...)
  return self[event] and self[event](self, event, ...)
end)


function Loader:ADDON_LOADED(event, addon, ...)
  if addon ~= "kln" then return end
    
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

  -- Load configuration on demand
  ns.events:Register("show_configuration", function(...)
    LoadConfiguration()
  end)

  -- Cleanup
  self:UnregisterEvent(event)
  self:SetScript("OnEvent", nil)
end


-- 
-- Load "klnConfig" addon if it hasn't been already.
-- Regardless, open the in-game addon configuration panel
-- straight to the primary pane.
-- 
function LoadConfiguration()
  if IsAddOnLoaded("klnConfig") then
    klnConfig:Open()
  end
  local loaded, reason = LoadAddOn("klnConfig")
  if not loaded then
    error("Failed to load configuration: "..reason)
  end
  klnConfig:Open()
end
