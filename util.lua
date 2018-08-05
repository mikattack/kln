---------------------------------------------------------------------
-- Utility functions
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
