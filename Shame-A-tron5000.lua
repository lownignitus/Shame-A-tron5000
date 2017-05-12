CF = CreateFrame
local addon_name = "Shame-A-tron5000"

local groupMax = 0
local numMembers = 0
local errorCount = 0
local i, name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole,fullName

-- RegisterForEvent table
local satEvents_table = {}

satEvents_table.eventFrame = CF("Frame");
satEvents_table.eventFrame:RegisterEvent("ADDON_LOADED");
satEvents_table.eventFrame:RegisterEvent("LFG_BOOT_PROPOSAL_UPDATE");
satEvents_table.eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
--satEvents_table.eventFrame:RegisterEvent("ZONE_CHANGED");
--satEvents_table.eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
satEvents_table.eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

satEvents_table.eventFrame:SetScript("OnEvent", function(self, event, ...)
	satEvents_table.eventFrame[event](self, ...);
end);

function satEvents_table.eventFrame:ADDON_LOADED(AddOn)
--	print(AddOn)
	if AddOn ~= addon_name then
		return
	end

	-- Unregister ADDON_LOADED, reduce cpu lag
	satEvents_table.eventFrame:UnregisterEvent("ADDON_LOADED")
	
	--Title Frames
	satFrame.title.text:SetText(GetAddOnMetadata(addon_name, "Title") .. " " .. GetAddOnMetadata(addon_name, "Version"))
	
	-- Defaults
	local defaults = {
		["options"] = {
			
		}
	}
	
	local function satSVCheck(src, dst)
		if type(src) ~= "table" then return {} end
		if type(dst) ~= "table" then dst = {} end
		for k, v in pairs(src) do
			if type(v) == "table" then
				dst[k] = satSVCheck(v,dst[k])
			elseif type(v) ~= type(dst[k]) then
				dst[k] = v
			end
		end
		return dst
	end

	satSettings = satSVCheck(defaults, satSettings)
	satInitialize();
end

function satInitialize()
	-- body
end

function satEvents_table.eventFrame:LFG_BOOT_PROPOSAL_UPDATE()
	print("Boot Proposal Updated")
end

function satEvents_table.eventFrame:GROUP_ROSTER_UPDATE()
	print("Group Roster Updated")
	if IsInRaid() then
		print("In a Raid")
		groupMax = 40
		satGroupNum()
	elseif IsInGroup() then
		print("In a Group")
		groupMax = 5
		satGroupNum()
	else
		print("Either solo, or fucked up party detection...")
	end
end

function satGroupNum()
	numMembers = GetNumGroupMembers()
	print("numMembers: " .. numMembers)
	satRosterInfo(numMembers)
end

function satRosterInfo(numMembers)
	i = 1
	while i < (numMembers + 1) do
		--[[name w/ server, 2= Raid Lead 1= Assistant 0=otherwise, raid group in # = group#, if offline = 0, localized 
		class name, English class name, value of GetRealZoneText(), 1= online nil=off, 1=dead nil=alive, role in raid 
		ie "miantank" or "mainassist", 1=master loot, nil=otherwise, spec role if selected "DAMAGER" "TANK" "HEALER" or 
		"NONE" if not assigned]] 
		name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
		if name == nil then
			print("group phasing error")
			errorCount = errorCount + 1
			if errorCount < 5 then
				if i == 1 then
					i = 1
				elseif i > 1 then
					i = i - 1
				end
			end
		elseif name ~= nil then
			print("raidIndex: " .. i .. ", name: " .. name .. ", level: " .. level .. ", class: " .. class .. ", fileName: " .. fileName .. ", combatRole: " .. combatRole .. ".")
			i = i + 1
		end
	end
end

function satEvents_table.eventFrame:ZONE_CHANGED()
	print("Zone Changed")
end

function satEvents_table.eventFrame:ZONE_CHANGED_NEW_AREA()
	print("Zone Changed New Area")
end