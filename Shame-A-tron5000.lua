CF = CreateFrame
local addon_name = "Shame-A-tron5000"
 
local numMembers = 0
local errorCount = 0
local groupType, i, name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole, fullName, isInstance, instanceType, zoneName
local satDisplayFrameData = {}
satDisplayFrameData.name = {}
satDisplayFrameData.guid = {}
satDisplayFrameData.level = {}
satDisplayFrameData.fileName = {}
satDisplayFrameData.shame = {}

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
		--print("In a Raid")
		groupType = "Raid"
		satGroupNum(groupType)
	elseif IsInGroup() then
		--print("In a Group")
		groupType = "Party"
		satGroupNum(groupType)
	else
		print("Solo, or left groupm, ")
	end
end

function satGroupNum(groupType)
	numMembers = GetNumGroupMembers()
	print("numMembers: " .. numMembers)
	satRosterInfo(numMembers, groupType)
end

function satRosterInfo(numMembers, groupType)
	i = 1
	for i = 1, numMembers do
		--[[name(name w/ server), rank(2= Raid Lead 1= Assistant 0=otherwise), subgroup(raid group in # = group#, if 
		offline = 0), class(localized class name), fileName(English class name), zone(value of GetRealZoneText()), 
		online(1= online nil=off), isDead(1=dead nil=alive), role(role in raid ie "miantank" or "mainassist"), 
		isML(1=master loot, nil=otherwise), combatRole(spec role if selected "DAMAGER" "TANK" "HEALER" or 
		"NONE" if not assigned)]] 
		name, _, _, level, _, fileName, _, _, _, _, _, _ = GetRaidRosterInfo(i)
		if name == nil then
			errorCount = errorCount + 1
			print("group phasing error .. name reported as nil .. errorCount: " .. errorCount)
			if errorCount < 5 then
				if i == 1 then
					i = 1
				elseif i > 1 then
					i = i - 1
				end
			elseif errorCount > 5 then
				errorCount = 0
			end
		elseif name ~= nil then
			--print("raidIndex: " .. i .. ", name: " .. name .. ", fileName: " .. fileName .. ", zone: " .. zone .. ".")
			satDisplayFrameData.name[i] = name
			satDisplayFrameData.guid[i] = UnitGUID(groupType .. i)
			satDisplayFrameData.level[i] = level
			satDisplayFrameData.fileName[i] = fileName
			print("satDisplayFrameData saves: name: " .. satDisplayFrameData.name[i])
		end
	end
end

function satDisplayFrame( ... )
	-- body
end

function satEvents_table.eventFrame:ZONE_CHANGED()
	print("Zone Changed")
end

function satEvents_table.eventFrame:ZONE_CHANGED_NEW_AREA()
	--print("Zone Changed New Area")
	isInstance, instanceType = IsInInstance()
	if isInstance == true then
		zoneName = GetZoneText()
		local ZoneName = GetRealZoneText()
		print(zoneName .. ", " .. ZoneName)
		satGroupNum(instanceType)
	end
end