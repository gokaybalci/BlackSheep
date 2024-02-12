
local addon = {};
local addonName = "BlackSheep";
local appAuthor = "Kokkai";
local appVersion = "0.1";
local appDate = "11-02-2024";
local appName = "BlackSheep";
local appWidth, appHeight = 500, 200;
local appMargin = 20;

-- GUI

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Initialize BlackSheepSavedData if it doesn't exist
        BlackSheepSavedData = BlackSheepSavedData or {
            retail_DATA = {}
        }
    end
end)

local function ShowInputDialog()
    local dialog = CreateFrame("Frame", "BlackSheepInputDialog", UIParent, "BasicFrameTemplate")
    dialog:SetSize(250, 185)
    dialog:SetPoint("CENTER", UIParent, "CENTER")
    dialog:EnableMouse(true)
    dialog:SetMovable(true)
    dialog:RegisterForDrag("LeftButton")
    dialog:SetScript("OnDragStart", dialog.StartMoving)
    dialog:SetScript("OnDragStop", dialog.StopMovingOrSizing)

    dialog.title = dialog:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    dialog.title:SetPoint("TOP", dialog, "TOP", 0, -5)
    dialog.title:SetText("Add player to blacklist:")

    dialog.nameLabel = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.nameLabel:SetPoint("TOPLEFT", dialog, "TOPLEFT", 10, -40)
    dialog.nameLabel:SetText("Name:")

    dialog.nameEditBox = CreateFrame("EditBox", "BlackSheepNameEditBox", dialog, "InputBoxTemplate")
    dialog.nameEditBox:SetSize(200, 20)
    dialog.nameEditBox:SetPoint("TOPLEFT", dialog.nameLabel, "BOTTOMLEFT", 0, -10)
    dialog.nameEditBox:SetAutoFocus(true)

    dialog.reasonLabel = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.reasonLabel:SetPoint("TOPLEFT", dialog.nameEditBox, "BOTTOMLEFT", 0, -20)
    dialog.reasonLabel:SetText("Reason:")

    dialog.reasonEditBox = CreateFrame("EditBox", "BlackSheepReasonEditBox", dialog, "InputBoxTemplate")
    dialog.reasonEditBox:SetSize(200, 20)
    dialog.reasonEditBox:SetPoint("TOPLEFT", dialog.reasonLabel, "BOTTOMLEFT", 0, -10)

    dialog.okayButton = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
    dialog.okayButton:SetPoint("BOTTOMLEFT", dialog, "BOTTOM", 10, 10)
    dialog.okayButton:SetSize(80, 22)
    dialog.okayButton:SetText("OK")
    dialog.okayButton:SetScript("OnClick", function()
        local playerName = dialog.nameEditBox:GetText()
        local reason = dialog.reasonEditBox:GetText()
        if playerName ~= "" and reason ~= "" then
            -- Append the user input to the blacklist
            table.insert(BlackSheepSavedData.retail_DATA, {playerName, reason})
            ReloadUI() -- Reload the UI to save the changes
        end
        dialog:Hide()
    end)

    return dialog
end

-- Function to handle slash commands (/bs)
SLASH_BLACKSHEEP1 = "/bs"
SlashCmdList["BLACKSHEEP"] = function(msg)
    ShowInputDialog() -- Show input dialog as a standalone window
end


local addonLoadFrame = CreateFrame("Frame")
addonLoadFrame:RegisterEvent("ADDON_LOADED")
addonLoadFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName and not addonLoaded then
        addonLoaded = true
        print("|cff00ccffBlackSheep Version " .. appVersion .. "|r")
        print("|cff00ccffYou can type /bs to use BlackSheep.|r")
    end
end)



if not TooltipDataProcessor.AddTooltipPostCall then return end

local UnitExists = UnitExists
local UnitName = UnitName
local _G = _G

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
    if tooltip:IsForbidden() then return end

    local _, unit = tooltip:GetUnit()
    if not unit or not UnitExists(unit) then return end

    local name = UnitName(unit)
    if name then
        local isBlackSheep = false
        local reason = nil
        if BlackSheepSavedData then
            for _, data in ipairs(BlackSheepSavedData.retail_DATA) do
                if data[1] == name then
                    isBlackSheep = true
                    reason = data[2] or "" -- Get the reason for the blacklist or use an empty string if none is provided
                    break
                end
            end
        end

        local blackSheepLineFound = false
        for i = 2, tooltip:NumLines() do
            local line = _G[tooltip:GetName() .. "TextLeft" .. i]
            if line and line:GetText() == "|cFFFF0000BlackSheep|r" then
                blackSheepLineFound = true
                break
            end
        end

        -- Add "BlackSheep" line and reason if not already present
        if isBlackSheep and not blackSheepLineFound then
            tooltip:AddLine("|cFFFF0000BlackSheep|r")
            tooltip:AddLine("|cFFFF0000Reason:|r " .. reason)
            tooltip:Show()  -- Show the tooltip after adding lines
        end
    end
end)








