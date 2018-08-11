---------------------------------------------------------------------
-- Profile management
---------------------------------------------------------------------

local _, ns = ...
ns.profiles = {}

--Profile Management ------------------------------------------------

--[[
A "profile" is just a table whose data are settings for a
collection of addons that depend on klnCore. It may be given
a name that has semantic meaning to end users, but has little
bearing on how it's treated internally.

By default when a player logs in, their character has a profile
automatically created for it and set as the current profile.

At any time, the current profile may be switched to another
existing profile. This allows several characters to share a
single profile. They could all have individual profiles as well.

Creating a new profile just means the current profile's values
are copied to a new one. Then the current profile is set to the
new profile.

A "default" profile is always present, in an attempt ensure that
addons always have a set of fallback values for any profile.
Be aware that this creates an edge case wherein new defaults of
an addon will not be present in existing profiles. This is
generally handled by a sensible configuration system.
--]]

---------------------------------------------------------------------

-- 
-- Ensures that the current profile has every value from the
-- default profile. Missing values are copied.
-- 
local function UpdateProfileDefaults(mgr, name)
  -- Profiles must exist prior to calling this function.
  if not mgr.profileDB[name] then return end
  for key, value in pairs(mgr.profileDB["default"]) do
    if not mgr.profileDB[name][key] then
      mgr.profileDB[name][key] = ns.deep_copy(value)
    end
  end
end


-- 
-- Sets the current profile.
-- 
local function SetCurrent(mgr, name)
  -- Profiles must exist prior to calling this function.
  if not mgr.profileDB[name] then return false end
  mgr.current.name = name
  mgr.current.data = mgr.profileDB[name]
  mgr.characterDB.profile = name
  UpdateProfileDefaults(mgr, name)
  ns.events:Trigger("profile_update", name, mgr.current.data)
  return true
end

-- Public API -------------------------------------------------------

ns.lib.ProfileManager = {}
local ProfileManager = ns.lib.ProfileManager

function ProfileManager:New(profileDB, characterDB)
  pm = {
    current     = { name=nil, data=nil },
    profileDB   = profileDB,
    characterDB = characterDB,
  }
  setmetatable(pm, self)
  self.__index = self

  -- Attempt to load a profile stored in the characterDB
  local profile = pm.characterDB.profile
  if profile and pm.profileDB[profile] then
    pm:Load(profile)
  end

  return pm
end


-- 
-- Returns the name and values of the current profile.
-- 
function ProfileManager:Current()
  if self.current.name == nil then
    return nil, nil
  else
    return self.current.name, self.current.data
  end
end


-- 
-- Returns a list of profiles, sorted alphabetically.
-- 
function ProfileManager:List()
  list = {}
  for name, _ in pairs(self.profileDB) do
    table.insert(list, name)
  end
  table.sort(list)
  return list
end


-- 
-- Loads an existing profile as the current profile.
-- 
-- If the requested profile does not exist, it is
-- created from the "default" profile.
-- 
function ProfileManager:Load(name)
  if name == self.current.name then return end
  if not self.profileDB[name] then
    ns:print("klnCore: Cannot find profile '%s'", name)
    self.profileDB[name] = ns.deep_copy(self.profileDB.default)
    ns:print("klnCore: Created '%s' from the default profile", name)
  end
  return SetCurrent(self, name)
end


-- 
-- Copies one profile to another.
-- 
-- If the source profile does not exist, no copy is performed.
-- 
-- If the destination profile does not exist, it is created.
-- 
function ProfileManager:Copy(src, dst)
  if not self.profileDB[src] then return end
  self.profileDB[dst] = ns.deep_copy(self.profileDB[src])
end


-- 
-- Removes a profile entirely from the database.
-- 
-- The current profile cannot be deleted.
-- 
-- Returns: boolean
-- 
function ProfileManager:Delete(name)
  if self.current.name == name then
    ns:print("klnCore: Cannot delete current profile")
    return false
  else
    self.profileDB[name] = nil
    return true
  end
end


-- 
-- Allows an addon to register a set of defaults for itself.
-- 
function ProfileManager:RegisterDefaults(addon, values)
  -- Ensure there's a default profile, even if it's empty
  if not self.profileDB.default then
    self.profileDB.default = {}
  end

  self.profileDB.default[addon] = values
end
