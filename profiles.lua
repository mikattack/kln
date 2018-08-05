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


--[[
The following globals are used as saved variables to persist
profile data between play sessions. They MUST NOT be
referenced prior to their proper initialization in "onload".
     kln_profiles    Collection of profiles
     kln_character   Character-specific data
--]]

local manager = ns.profiles
local current = { name=nil, data=nil}

-- 
-- Ensures that the current profile has every value from the
-- default profile. Missing values are copied.
-- 
local function UpdateProfileDefaults(name)
  -- Profiles must exist prior to calling this function.
  if not kln_profiles[name] then return end
  for key, value in pairs(kln_profiles["default"]) do
    if not kln_profiles[name][key] then
      kln_profiles[name][key] = ns.deep_copy(value)
    end
  end
end


-- 
-- Sets the current profile.
-- 
local function SetCurrent(name)
  -- Profiles must exist prior to calling this function.
  if not kln_profiles[name] then return false end
  current.name = name
  current.data = kln_profiles[name]
  kln_character.profile = name
  UpdateProfileDefaults(name)
  ns.events:Trigger("profile_update", name, current.data)
  return true
end


-- 
-- Returns a list of profile, sorted alphabetically.
-- 
function manager:List()
  list = {}
  for name, _ in pairs(kln_profiles) do
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
function manager:Load(name)
  if name == current.name then return end
  if not kln_profiles[name] then
    ns:print("klnCore: Cannot find profile '%s'", name)
    kln_profiles[name] = ns.deep_copy(kln_profiles.default)
    ns:print("klnCore: Created '%s' from the default profile", name)
  end
  SetCurrent(name)
end


-- 
-- Copies one profile to another.
-- 
-- If the source profile does not exist, no copy is performed.
-- 
-- If the destination profile does not exist, it is created.
-- 
function manager:Copy(src, dst)
  if not kln_profiles[src] then return end
  kln_profiles[dst] = ns.deep_copy(kln_profiles[src])
end


-- 
-- Removes a global profile entirely.
-- 
-- The player's current profile cannot be deleted.
-- 
-- Returns: boolean
-- 
function manager:Delete(name)
  if current.name == name then
    ns:print("klnCore: Cannot delete current profile")
    return false
  else
    kln_profiles[name] = nil
    return true
  end
end


-- 
-- Allows an addon to register a set of defaults for itself.
-- 
function manager:RegisterDefaults(addon, values)
  kln_profiles.default[addon] = values
end
