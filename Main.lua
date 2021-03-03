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

	for	i = 0, 9, 1 do
		_G["XDesiCordTexture1"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["XDesiCordTexture2"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["XDesiCordTexture3"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["XDesiCordTexture4"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["XDesiCordTexture5"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		
		_G["YDesiCordTexture1"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["YDesiCordTexture2"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["YDesiCordTexture3"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["YDesiCordTexture4"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["YDesiCordTexture5"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
	end
	
	for i=0, 100, 1 do
		_G["XCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		--_G["XDesiCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["YCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		--_G["YDesiCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["facingTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
	end
	for i=0, 1000, 1 do
		--_G["XDesiCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		--_G["YDesiCordTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
		_G["facingTexture"..i]:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
	end
end

function UpdateCordPixels(cordX, cordXDesi1,cordXDesi2,cordXDesi3,cordXDesi4,cordXDesi5, cordY, cordYDesi1,cordYDesi2,cordYDesi3,cordYDesi4,cordYDesi5, face)
	cordX = cordX:match("0*(%d+)")
	cordY = cordY:match("0*(%d+)")
	if(face == 000) then
		face = 999
	end
	
	
	face = face:match("0*(%d+)")
	--print(cordX)
	--print(cordXDesi)
	--print(cordY)
	--print(cordYDesi)
	_G["XCordTexture"..cordX]:SetVertexColor(OK_R,OK_G,OK_B)
	
	--xDesi
	_G["XDesiCordTexture1"..cordXDesi1]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["XDesiCordTexture2"..cordXDesi2]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["XDesiCordTexture3"..cordXDesi3]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["XDesiCordTexture4"..cordXDesi4]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["XDesiCordTexture5"..cordXDesi5]:SetVertexColor(OK_R,OK_G,OK_B)
	--xDesi
	_G["YCordTexture"..cordY]:SetVertexColor(OK_R,OK_G,OK_B)
	
	_G["YDesiCordTexture1"..cordYDesi1]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["YDesiCordTexture2"..cordYDesi2]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["YDesiCordTexture3"..cordYDesi3]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["YDesiCordTexture4"..cordYDesi4]:SetVertexColor(OK_R,OK_G,OK_B)
	_G["YDesiCordTexture5"..cordYDesi5]:SetVertexColor(OK_R,OK_G,OK_B)
	
	_G["facingTexture"..face]:SetVertexColor(OK_R,OK_G,OK_B)
	
end

-----Functions-----

local frame_Combat = CreateFrame("Frame",ShowUF,UIParent)
local CombatTexture = frame_Combat:CreateTexture()
CombatTexture:SetPoint("TOPLEFT", relativeframe)--set til 1,0 isteden for 4,0
CombatTexture:SetSize(0.319,0.319)-- sett til 1,1 istedenfor 4,4
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
RangeTexture:SetPoint("TOPLEFT", relativeframe,2*0.319,0)
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
---yCORD---
for i=0, 100, 1 do
    _G["frame_YCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YCordTexture"..i] = _G["frame_YCord"..i]:CreateTexture()
	
	_G["YCordTexture"..i]:SetPoint("TOPLEFT", relativeframe,i,-2)
	_G["YCordTexture"..i]:SetSize(1,1)
	_G["YCordTexture"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame_YCord"..i].texture = _G["YCordTexture"..i]
	_G["YCordTexture"..i]:SetVertexColor(0,0,0)
	_G["frame_YCord"..i]:SetSize(1,1)
	_G["frame_YCord"..i]:Show()	
end
---yCORD---

---xCORDDeci---
for i=0, 9, 1 do
    _G["frame1_XDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["XDesiCordTexture1"..i] = _G["frame1_XDesiCord"..i]:CreateTexture()
	_G["XDesiCordTexture1"..i]:SetPoint("TOPLEFT", relativeframe,i,-3)
	_G["XDesiCordTexture1"..i]:SetSize(1,1)
	_G["XDesiCordTexture1"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame1_XDesiCord"..i].texture = _G["XDesiCordTexture1"..i]
	_G["XDesiCordTexture1"..i]:SetVertexColor(0,0,0)
	_G["frame1_XDesiCord"..i]:SetSize(256,64)
	_G["frame1_XDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame2_XDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["XDesiCordTexture2"..i] = _G["frame2_XDesiCord"..i]:CreateTexture()
	_G["XDesiCordTexture2"..i]:SetPoint("TOPLEFT", relativeframe,i,-4)
	_G["XDesiCordTexture2"..i]:SetSize(1,1)
	_G["XDesiCordTexture2"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame2_XDesiCord"..i].texture = _G["XDesiCordTexture2"..i]
	_G["XDesiCordTexture2"..i]:SetVertexColor(0,0,0)
	_G["frame2_XDesiCord"..i]:SetSize(256,64)
	_G["frame2_XDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame3_XDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["XDesiCordTexture3"..i] = _G["frame3_XDesiCord"..i]:CreateTexture()
	_G["XDesiCordTexture3"..i]:SetPoint("TOPLEFT", relativeframe,i,-5)
	_G["XDesiCordTexture3"..i]:SetSize(1,1)
	_G["XDesiCordTexture3"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame3_XDesiCord"..i].texture = _G["XDesiCordTexture3"..i]
	_G["XDesiCordTexture3"..i]:SetVertexColor(0,0,0)
	_G["frame3_XDesiCord"..i]:SetSize(256,64)
	_G["frame3_XDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame4_XDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["XDesiCordTexture4"..i] = _G["frame4_XDesiCord"..i]:CreateTexture()
	_G["XDesiCordTexture4"..i]:SetPoint("TOPLEFT", relativeframe,i,-6)
	_G["XDesiCordTexture4"..i]:SetSize(1,1)
	_G["XDesiCordTexture4"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame4_XDesiCord"..i].texture = _G["XDesiCordTexture4"..i]
	_G["XDesiCordTexture4"..i]:SetVertexColor(0,0,0)
	_G["frame4_XDesiCord"..i]:SetSize(256,64)
	_G["frame4_XDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame5_XDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["XDesiCordTexture5"..i] = _G["frame5_XDesiCord"..i]:CreateTexture()
	_G["XDesiCordTexture5"..i]:SetPoint("TOPLEFT", relativeframe,i,-7)
	_G["XDesiCordTexture5"..i]:SetSize(1,1)
	_G["XDesiCordTexture5"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame5_XDesiCord"..i].texture = _G["XDesiCordTexture5"..i]
	_G["XDesiCordTexture5"..i]:SetVertexColor(0,0,0)
	_G["frame5_XDesiCord"..i]:SetSize(256,64)
	_G["frame5_XDesiCord"..i]:Show()	
end
---xCORDDeci---

---yCordDesi---
for i=0, 9, 1 do
    _G["frame1_YDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YDesiCordTexture1"..i] = _G["frame1_YDesiCord"..i]:CreateTexture()
	
	_G["YDesiCordTexture1"..i]:SetPoint("TOPLEFT", relativeframe,i,-8)
	_G["YDesiCordTexture1"..i]:SetSize(1,1)
	_G["YDesiCordTexture1"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame1_YDesiCord"..i].texture = _G["YDesiCordTexture1"..i]
	_G["YDesiCordTexture1"..i]:SetVertexColor(0,0,0)
	_G["frame1_YDesiCord"..i]:SetSize(1,1)
	_G["frame1_YDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame2_YDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YDesiCordTexture2"..i] = _G["frame2_YDesiCord"..i]:CreateTexture()
	
	_G["YDesiCordTexture2"..i]:SetPoint("TOPLEFT", relativeframe,i,-9)
	_G["YDesiCordTexture2"..i]:SetSize(1,1)
	_G["YDesiCordTexture2"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame2_YDesiCord"..i].texture = _G["YDesiCordTexture2"..i]
	_G["YDesiCordTexture2"..i]:SetVertexColor(0,0,0)
	_G["frame2_YDesiCord"..i]:SetSize(1,1)
	_G["frame2_YDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame3_YDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YDesiCordTexture3"..i] = _G["frame3_YDesiCord"..i]:CreateTexture()
	
	_G["YDesiCordTexture3"..i]:SetPoint("TOPLEFT", relativeframe,i,-10)
	_G["YDesiCordTexture3"..i]:SetSize(1,1)
	_G["YDesiCordTexture3"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame3_YDesiCord"..i].texture = _G["YDesiCordTexture3"..i]
	_G["YDesiCordTexture3"..i]:SetVertexColor(0,0,0)
	_G["frame3_YDesiCord"..i]:SetSize(1,1)
	_G["frame3_YDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame4_YDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YDesiCordTexture4"..i] = _G["frame4_YDesiCord"..i]:CreateTexture()
	
	_G["YDesiCordTexture4"..i]:SetPoint("TOPLEFT", relativeframe,i,-11)
	_G["YDesiCordTexture4"..i]:SetSize(1,1)
	_G["YDesiCordTexture4"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame4_YDesiCord"..i].texture = _G["YDesiCordTexture4"..i]
	_G["YDesiCordTexture4"..i]:SetVertexColor(0,0,0)
	_G["frame4_YDesiCord"..i]:SetSize(1,1)
	_G["frame4_YDesiCord"..i]:Show()	
end
for i=0, 9, 1 do
    _G["frame5_YDesiCord"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["YDesiCordTexture5"..i] = _G["frame5_YDesiCord"..i]:CreateTexture()
	
	_G["YDesiCordTexture5"..i]:SetPoint("TOPLEFT", relativeframe,i,-12)
	_G["YDesiCordTexture5"..i]:SetSize(1,1)
	_G["YDesiCordTexture5"..i]:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
	_G["frame5_YDesiCord"..i].texture = _G["YDesiCordTexture5"..i]
	_G["YDesiCordTexture5"..i]:SetVertexColor(0,0,0)
	_G["frame5_YDesiCord"..i]:SetSize(1,1)
	_G["frame5_YDesiCord"..i]:Show()	
end
---yCordDesi---
---Facing---
for i=0, 1000, 1 do
    _G["frame_facing"..i] = CreateFrame("Frame",ShowUF,UIParent)
	_G["facingTexture"..i] = _G["frame_facing"..i]:CreateTexture()
	
	_G["facingTexture"..i]:SetPoint("TOPLEFT", relativeframe,i,-13)
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
		
		--print(testString1)
		--print(testString2)
		
		local xCord = strsub(testString1,3,4)
		local xCordDesi = strsub(testString1,5,9)
		local yCord = strsub(testString2,3,4)
		local yCordDesi = strsub(testString2,5,9)
		
		print(xCordDesi)
		print(yCordDesi)
		
		local xCordDesi1 = strsub(testString1,5,5)
		local xCordDesi2 = strsub(testString1,6,6)
		local xCordDesi3 = strsub(testString1,7,7)
		local xCordDesi4 = strsub(testString1,8,8)
		local xCordDesi5 = strsub(testString1,9,9)
		
		local yCordDesi1 = strsub(testString2,5,5)
		local yCordDesi2 = strsub(testString2,6,6)
		local yCordDesi3 = strsub(testString2,7,7)
		local yCordDesi4 = strsub(testString2,8,8)
		local yCordDesi5 = strsub(testString2,9,9)
		
		facing = GetPlayerFacing()/6.2832
		local newface = strsub(facing,3,5)
		
		--print(facing)
		print(newface)	

		ResetCordPixels()
		UpdateCordPixels(xCord,xCordDesi1,xCordDesi2,xCordDesi3,xCordDesi4,xCordDesi5,yCord,yCordDesi1,yCordDesi2,yCordDesi3,yCordDesi4,yCordDesi5,newface)		
	
		timer = 0
	end
end)


-------------//MovementCordPixels//----------

------
local frame = CreateFrame("FRAME", "FooAddonFrame");
local TestFrame = CreateFrame("FRAME", "FooAddonFrame");
local screenWidth = GetScreenWidth()

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

