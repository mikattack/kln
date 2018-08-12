--[[
# EventHandler: Simple "Observer" implementation

Creates an object capable of emitting events and registering
functions to respond to them. Only synthetic events are used.
That is, it will not recognize game events, nor pass any game
event information by default. It is used only for triggering
events pertinent to "kln" addons.

## API

New           - Creates a new EventHandler.
Register      - Adds a function handler for an event.
Unregister    - Removes a function handler for an event.
UnregisterAll - Removes all function handlers for an event.
Trigger       - Triggers an event, executing all associated event
                handlers, serially.

## Additional events

No additional events are emitted by the library automatically.
Unlike other implementations (ex: nodeJS's EventEmitter), this
will emit no events for registered handler, unregistered handler,
or errors.

## Errors

Any errors generated during a triggered event are NOT handled
specially. Use of !BugGrabber is highly encouraged here.

## Examples

```
events = EventHandler:New()
events:Register("my_event", function(data) print(data) end)
events:Trigger("my_event", "pickles")
>> pickles
```
--]]

---------------------------------------------------------------------

local _, ns = ...
ns.lib.EventHandler = {}
local EventHandler = ns.lib.EventHandler

---------------------------------------------------------------------

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
