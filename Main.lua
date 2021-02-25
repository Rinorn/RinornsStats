--Vars
local OKColor = "#00B000"
local OK_R = .55
local OK_G = .69
local OK_B = 15

local Not_OKColor = "#000000"
local Not_OK_R = 0
local Not_OK_G = 0
local Not_OK_B = 0
--

------
local frame_Target = CreateFrame("Frame",ShowUF,UIParent)
local ufTexture = frame_Target:CreateTexture()
ufTexture:SetPoint("TOPLEFT", relativeframe)
ufTexture:SetSize(4,4)
ufTexture:SetTexture("Interface\\AddOns\\WoWUI\\Background\\NaTUI")
frame_Target.texture = ufTexture
ufTexture:SetVertexColor(0,0,0)
frame_Target:SetSize(256,64)
frame_Target:Show()


local frame_Combat = CreateFrame("Frame",ShowUF,UIParent)

local ufTexture = frame_Combat:CreateTexture()
ufTexture:SetPoint("TOPLEFT", relativeframe,4,0)
ufTexture:SetSize(4,4)
ufTexture:SetTexture("Interface\\AddOns\\WoWUI\\RinornsStats\\BG.png")
frame_Combat.texture = ufTexture
ufTexture:SetVertexColor(0,0,0)
frame_Combat:SetSize(256,64)
frame_Combat:Show()

------
local frame = CreateFrame("FRAME", "FooAddonFrame");
local TestFrame = CreateFrame("FRAME", "FooAddonFrame");
local screenWidth = GetScreenWidth()
print(screenWidth);
--Events
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("UNIT_HEALTH");
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
--target--
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
--target--

frame:SetScript("OnEvent", function(self, event)
	if(event == "PLAYER_ENTERING_WORLD") then
		print("Hello World! Hello " .. event..UnitName("Player"));
	end
	if(event == "UNIT_HEALTH") then
		print(event.. "Current Health " ..UnitHealth("player"));
	end
	if(event == "PLAYER_REGEN_DISABLED") then
		print("Entered combat" .. event);
	end
	if(event == "PLAYER_REGEN_ENABLED") then
		print("Left combat" .. event);
	end
	
	--TARGET Functionality
	if(event == "PLAYER_TARGET_CHANGED") then
		--if target exists
		if(UnitExists("target")) then
			print("Changed target to " ..UnitName("target"));
			--if the target is killable target	
			if not(UnitIsFriend("Player","target")) then 
				--if target is alive
				if not(UnitIsDead("target")) then
					frame_Target.texture = ufTexture
					ufTexture:SetVertexColor(OK_R,OK_G,OK_B)
					frame_Target:Show()
				else --target is lootable/skinnable 
					frame_Target.texture = ufTexture
					ufTexture:SetVertexColor(.35,.55,.80)
					frame_Target:Show()	
				end
			end	
		else 
			frame_Target.texture = ufTexture
			ufTexture:SetVertexColor(Not_OK_R,Not_OK_G,Not_OK_B)
			frame_Target:Show()
		end
	end
	
end)





