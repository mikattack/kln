---------------------------------------------------------------------
-- Convenience event API
---------------------------------------------------------------------

local _, ns = ...
ns.events = {}

local events = ns.events

--[[
This API is ONLY used for synthetic events. That is, it will not
recognize game events, nor pass any game event information by default.
It is used only for triggering events pertinent to "kln" addons.
--]]

function events:Register(event, fn)
  if string.find(event, ",") then
    ns:print("klnCore: Cannot register event '%s'", event)
    return
  end
  if not events[event] then
    self[event] = {}
  end
  self[event][#events + 1] = fn
end


function events:Unregister(event, fn)
  if not self[event] then return end
  for k, v in pairs(self[event]) do
    if v == fn then
      self[event][k] = nil
    end
  end
end


function events:UnregisterAll(event)
  if self[event] then
    self[event] = nil
  end
end


function events:Trigger(event, ...)
  if not self[event] then return end
  for _, fn in pairs(self[event]) do
    fn(...)
  end
end
