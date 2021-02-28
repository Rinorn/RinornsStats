-----Vars-----
local OKColor = "#00B000"
local OK_R = .55
local OK_G = .69
local OK_B = 15

local Not_OKColor = "#000000"
local Not_OK_R = 0
local Not_OK_G = 0
local Not_OK_B = 0

local Var1_Color = "008C00"
local Var1_R = .35
local Var1_G = .55
local Var1_B = .80



-----Vars-----

-----Functions-----
function ResetCordPixels()
	for i=0, 100, 1 do
		_G["XCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["XDesiCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["YCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["YDesiCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["facingTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
	end
end

function UpdateCordPixels(cordX, cordXDesi, cordY, cordYDesi, face)
	cordX = cordX:match("0*(%d+)")
	cordXDesi = cordXDesi:match("0*(%d+)")
	cordY = cordY:match("0*(%d+)")
	cordYDesi = cordYDesi:match("0*(%d+)")
	face = face:match("0*(%d+)")
	--print(cordX)
	--print(cordXDesi)
	--print(cordY)
	--print(cordYDesi)
	_G["XCordTexture"..cordX]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["XDesiCordTexture"..cordXDesi]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["YCordTexture"..cordY]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["YDesiCordTexture"..cordYDesi]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["facingTexture"..face]:SetVertexColor(OK_R,OK_G,OK_B)
	
end

-----Functions-----

local frame_Combat = CreateFrame("Frame",ShowUF,UIParent)
local CombatTexture = frame_Combat:CreateTexture()
CombatTexture:SetPoint("TOPLEFT", relativeframe)--set til 1,0 isteden for 4,0
CombatTexture:SetSize(1,1)-- sett til 1,1 istedenfor 4,4
CombatTexture:SetTexture("Interface\\AddOns\\WoWUI\\RinornsStats\\BG.png")
frame_Combat.texture = CombatTexture
CombatTexture:SetVertexColor(0,0,0)
frame_Combat:SetSize(256,64)
frame_Combat:Show()

local frame_Target = CreateFrame("Frame",ShowUF,UIParent)
local TargetTexture = frame_Target:CreateTexture()
TargetTexture:SetPoint("TOPLEFT", relativeframe,1,0)
TargetTexture:SetSize(1,1)
TargetTexture:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
frame_Target.texture = TargetTexture
TargetTexture:SetVertexColor(0,0,0)
frame_Target:SetSize(256,64)
frame_Target:Show()

local frame_Range = CreateFrame("Frame",ShowUF,UIParent)
local RangeTexture = frame_Range:CreateTexture()
RangeTexture:SetPoint("TOPLEFT", relativeframe,2,0)
RangeTexture:SetSize(1,1)
RangeTexture:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
frame_Range.texture = RangeTexture
RangeTexture:SetVertexColor(0,0,0)
frame_Range:SetSize(256,64)
frame_Range:Show()

-------------//MovementCordPixels//----------
for i=0, 100, 1 do
    _G["frame_XCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["XCordTexture"..i] = _G["frame_XCord"..i]:CreateTexture()
	_G["XCordTexture"..i]:SetPoint("TOPLEFT", relativeframe,i,-1)
	_G["XCordTexture"..i]:SetSize(1,1)
	_G["XCordTexture"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame_XCord"..i].texture = _G["XCordTexture"..i]
	_G["XCordTexture"..i]:SetVertexColor(0,0,0)
	_G["frame_XCord"..i]:SetSize(1,1)
	_G["frame_XCord"..i]:Show()	
end

for i=0, 100, 1 do
    _G["frame_XDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["XDesiCordTexture"..i] = _G["frame_XDesiCord"..i]:CreateTexture()
	_G["XDesiCordTexture"..i]:SetPoint("TOPLEFT", relativeframe,i,-2)
	_G["XDesiCordTexture"..i]:SetSize(1,1)
	_G["XDesiCordTexture"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame_XDesiCord"..i].texture = _G["XDesiCordTexture"..i]
	_G["XDesiCordTexture"..i]:SetVertexColor(0,0,0)
	_G["frame_XDesiCord"..i]:SetSize(256,64)
	_G["frame_XDesiCord"..i]:Show()	
end
---xCORDDeci---
---yCORD---
for i=0, 100, 1 do
    _G["frame_YCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YCordTexture"..i] = _G["frame_YCord"..i]:CreateTexture()
	
	_G["YCordTexture"..i]:SetPoint("TOPLEFT", relativeframe,i,-3)
	_G["YCordTexture"..i]:SetSize(1,1)
	_G["YCordTexture"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame_YCord"..i].texture = _G["YCordTexture"..i]
	_G["YCordTexture"..i]:SetVertexColor(0,0,0)
	_G["frame_YCord"..i]:SetSize(1,1)
	_G["frame_YCord"..i]:Show()	
end
---yCORD---
---yCordDesi---
for i=0, 100, 1 do
    _G["frame_YDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YDesiCordTexture"..i] = _G["frame_YDesiCord"..i]:CreateTexture()
	
	_G["YDesiCordTexture"..i]:SetPoint("TOPLEFT", relativeframe,i,-4)
	_G["YDesiCordTexture"..i]:SetSize(1,1)
	_G["YDesiCordTexture"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame_YDesiCord"..i].texture = _G["YDesiCordTexture"..i]
	_G["YDesiCordTexture"..i]:SetVertexColor(0,0,0)
	_G["frame_YDesiCord"..i]:SetSize(1,1)
	_G["frame_YDesiCord"..i]:Show()	
end
---yCordDesi---
---Facing---
for i=0, 100, 1 do
    _G["frame_facing"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["facingTexture"..i] = _G["frame_facing"..i]:CreateTexture()
	
	_G["facingTexture"..i]:SetPoint("TOPLEFT", relativeframe,i,-5)
	_G["facingTexture"..i]:SetSize(1,1)
	_G["facingTexture"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame_facing"..i].texture = _G["facingTexture"..i]
	_G["facingTexture"..i]:SetVertexColor(0,0,0)
	_G["frame_facing"..i]:SetSize(1,1)
	_G["frame_facing"..i]:Show()	
end
---facing---

-------------//MovementCordPixels//----------

local frameUpdate = CreateFrame('Frame')
local timer = 0
local facing = 0;

frameUpdate:SetScript('OnUpdate', function(self, elapsed)
    timer = timer + elapsed
	if(timer > 1) then
		local map = C_Map.GetBestMapForUnit("player")
		local position = C_Map.GetPlayerMapPosition(map, "player")
		local testString1, testString2 = position:GetXY()
		local xCord = strsub(testString1,3,4)
		local xCordDesi = strsub(testString1,5,6)
		local yCord = strsub(testString2,3,4)
		local yCordDesi = strsub(testString2,5,6)
		
		facing = GetPlayerFacing()/6.2832
		local newface = strsub(facing,3,4)
		print(newface)
		
		ResetCordPixels()
		UpdateCordPixels(xCord,xCordDesi,yCord,yCordDesi,newface)		
	
		timer = 0
	end
end)


-------------//MovementCordPixels//----------

------
local frame = CreateFrame("FRAME", "FooAddonFrame");
local TestFrame = CreateFrame("FRAME", "FooAddonFrame");
local screenWidth = GetScreenWidth()
print(screenWidth);
--Events
frame:RegisterEvent("UNIT_HEALTH");
frame:RegisterEvent("UNIT_COMBAT");
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
--target--
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
--target--

frame:SetScript("OnEvent", function(self, event)
	if(event == "UNIT_HEALTH") then
		print(event.. "Current Health " ..UnitHealth("player"));
	end
	if(event == "UNIT_COMBAT") then
		if(IsActionInRange(12)) then
			RangeTexture:SetVertexColor(OK_R,OK_G,OK_B)
		elseif(IsActionInRange(11))	then
			RangeTexture:SetVertexColor(Var1_R,Var1_G,Var1_B)
		end
	end		
	--COMBAT--
	if(event == "PLAYER_REGEN_DISABLED") then
		frame_Combat.texture = CombatTexture
		CombatTexture:SetVertexColor(OK_R,OK_G,OK_B)
		frame_Combat:Show()
	end
	if(event == "PLAYER_REGEN_ENABLED") then
		CombatTexture:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		RangeTexture:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
	end
	--COMBAT--
	--TARGET Functionality
	if(event == "PLAYER_TARGET_CHANGED") then
		--if target exists
		if(UnitExists("target")) then
			myTarget = "target"
			print("Changed target to " ..UnitName("target"));
			--if the target is killable target	
			if not(UnitIsFriend("Player","target")) then 
				--if target is alive
				if not(UnitIsDead("target")) then
					TargetTexture:SetVertexColor(OK_R,OK_G,OK_B)
					if(IsActionInRange(12)) then
						RangeTexture:SetVertexColor(OK_R,OK_G,OK_B)
					elseif(IsActionInRange(11) and CheckInteractDistance("target", 1))	then
						RangeTexture:SetVertexColor(Var1_R,Var1_G,Var1_B)
					else
						RangeTexture:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
					end
				else --target is lootable/skinnable 
					TargetTexture:SetVertexColor(.35,.55,.80)
				end
			end	
		else 
			frame_Target.texture = TargetTexture
			TargetTexture:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
			frame_Target:Show()
		end
	end
end)

