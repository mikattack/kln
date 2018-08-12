--[[
# Utility Functions

Grab bag of general-use functions useful to all addons.
--]]

---------------------------------------------------------------------

local _, ns = ...


-- 
-- Solid debugger.
-- 
function ns:print(pattern, ...)
  print(format(pattern, ...))
end

-- 
-- Formats a integer with English-style commas.
-- Always returns a string.
-- 
-- Example: 2500 -> 2,500
-- 
function ns.format_commas(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if k == 0 then break end
  end
  return formatted
end

-- 
-- Basic rounding function.
-- 
function ns.round(num, idp)
  local mult = 10 ^ (idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- 
-- Convenience function for checking whether a given value
-- in a table.
-- 
function ns.in_table (element, table)
  for _, v in pairs(table) do
    if v == element then return true end
  end
  return false
end

-- 
-- Recursive table deep copy.
-- WARNING: Not suitable for very large tables.
-- 
-- From: http://lua-users.org/wiki/CopyTable
-- 
function ns.deep_copy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[ns.deep_copy(orig_key)] = ns.deep_copy(orig_value)
    end
    setmetatable(copy, ns.deep_copy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end


-- 
-- Integer shortening (for easy-to-read number readouts).
-- 
-- Returns shortened string (ex. 1,000,000 is "1m").
-- If "true" is passed as the second argument, the
-- value is also returned.
-- 
function ns.si(value, ...)
  if not value then return "" end
  local absvalue = abs(value)
  local str, val

  if absvalue >= 1e10 then
    str, val = "%.0fb", value / 1e9
  elseif absvalue >= 1e9 then
    str, val = "%.1fb", value / 1e9
  elseif absvalue >= 1e7 then
    str, val = "%.1fm", value / 1e6
  elseif absvalue >= 1e6 then
    str, val = "%.2fm", value / 1e6
  elseif absvalue >= 1e5 then
    str, val = "%.0fk", value / 1e3
  elseif absvalue >= 1e3 then
    str, val = "%.1fk", value / 1e3
  else
    str, val = "%d", value
  end

  local raw = select(1, ...)
  if raw then
    return str, val
  else
    return format(str, val)
  end
end
