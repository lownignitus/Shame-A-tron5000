CF = CreateFrame
local addon_name = "Shame-A-tron5000"

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
	elseif IsInGroup() then
		print("In a Group")
	else
		print("Either solo, or fucked up party detection...")
	end
end

function satEvents_table.eventFrame:ZONE_CHANGED()
	print("Zone Changed")
end

function satEvents_table.eventFrame:ZONE_CHANGED_NEW_AREA()
	print("Zone Changed New Area")
end