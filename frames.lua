---------------------------------------------------------------------
-- Frame-related tools and functionality
---------------------------------------------------------------------

local _, ns = ...
ns.frames = {}

local LSM = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
local frames = ns.frames


-- 
-- Decorate a Frame with a background and outline texture.
-- 
function frames.setBackdrop(frame)
  if not LSM then print("LibStub failed to load") return end
  if frame.background then return end

  local TEXTURE = LSM:Fetch(LSM.MediaType.STATUSBAR, "Flat")
  
  -- Background
  frame.background = frame:CreateTexture(nil, "BACKGROUND", nil, -7)
  frame.background:SetTexture(TEXTURE)
  frame.background:SetAllPoints(frame)
  frame.background:SetVertexColor(0, 0, 0, 1)
  
  -- Border
  frame.border = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
  frame.border:SetTexture(TEXTURE)
  frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
  frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
  frame.border:SetVertexColor(0, 0, 0, 1)
end
