--Vars
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

---for skinning--
local prevtarget = nil

-----------------
--

------

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
local frame_XCord = CreateFrame("Frame",ShowUF,UIParent)
local XCordTexture = frame_XCord:CreateTexture()
XCordTexture:SetPoint("TOPLEFT", relativeframe,0,1)
XCordTexture:SetSize(10,10)
XCordTexture:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
frame_XCord.texture = XCordTexture
XCordTexture:SetVertexColor(0,0,0)
frame_XCord:SetSize(256,64)
frame_XCord:Show()

local frame_XDesiCord = CreateFrame("Frame",ShowUF,UIParent)
local XDesiCordTexture = frame_XDesiCord:CreateTexture()
XDesiCordTexture:SetPoint("TOPLEFT", relativeframe,0,2)
XDesiCordTexture:SetSize(1,1)
XDesiCordTexture:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
frame_XDesiCord.texture = XDesiCordTexture
XDesiCordTexture:SetVertexColor(0,0,0)
frame_XDesiCord:SetSize(256,64)
frame_XDesiCord:Show()

local frame_YCord = CreateFrame("Frame",ShowUF,UIParent)
local YCordTexture = frame_YCord:CreateTexture()
YCordTexture:SetPoint("TOPLEFT", relativeframe,0,1)
YCordTexture:SetSize(1,1)
YCordTexture:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
frame_YCord.texture = YCordTexture
YCordTexture:SetVertexColor(0,0,0)
frame_YCord:SetSize(256,64)
frame_YCord:Show()

local frame_YDesiCord = CreateFrame("Frame",ShowUF,UIParent)
local YDesiCordTexture = frame_YDesiCord:CreateTexture()
YDesiCordTexture:SetPoint("TOPLEFT", relativeframe,0,2)
YDesiCordTexture:SetSize(1,1)
YDesiCordTexture:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
frame_YDesiCord.texture = YDesiCordTexture
YDesiCordTexture:SetVertexColor(0,0,0)
frame_YDesiCord:SetSize(256,64)
frame_YDesiCord:Show()


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

