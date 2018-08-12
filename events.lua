---------------------------------------------------------------------
-- Convenience event API
---------------------------------------------------------------------

local _, ns = ...
ns.lib.EventHandler = {}
local EventHandler = ns.lib.EventHandler

--[[
This API is ONLY used for synthetic events. That is, it will not
recognize game events, nor pass any game event information by default.
It is used only for triggering events pertinent to "kln" addons.
--]]

function EventHandler:New()
  handlers = {}
  setmetatable(handlers, self)
  self.__index = self
  return handlers
end


function EventHandler:Register(event, fn)
  if string.find(event, ",") then
    ns:print("klnCore: Cannot register event '%s'", event)
    return
  end
  if not self[event] then
    self[event] = {}
  end
  self[event][#self[event] + 1] = fn
end


function EventHandler:Unregister(event, fn)
  if not self[event] then return end
  for k, v in pairs(self[event]) do
    if v == fn then
      self[event][k] = nil
    end
  end
end


function EventHandler:UnregisterAll(event)
  if not self[event] then return end
  for k, v in pairs(self[event]) do
    self[event][k] = nil
  end
end


function EventHandler:Trigger(event, ...)
  if not self[event] then return end
  for _, fn in pairs(self[event]) do
    if type(fn) == "function" then fn(...) end
  end
end
