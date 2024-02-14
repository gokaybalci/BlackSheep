
local addon = {};
local addonName = "BlackSheep";
local appAuthor = "Kokkai";
local appVersion = "0.1";
local appDate = "11-02-2024";
local appName = "BlackSheep";
local appWidth, appHeight = 500, 200;
local appMargin = 20;

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        BlackSheepSavedData = BlackSheepSavedData or {
            retail_DATA = {}
        }
        
        CustomList = CustomList or {
            custom_retail_DATA = {}
        }
        if CustomList and CustomList.custom_retail_DATA and next(CustomList.custom_retail_DATA) ~= nil then
            print("|cff00ccffBlackSheep:|r Your custom blacklist initialized successfully.")
        end
    end
end)



-- GUI Window

local function ShowInputDialog()
    local dialog = CreateFrame("Frame", "BlackSheepInputDialog", UIParent, "BasicFrameTemplateWithInset")
    dialog:SetSize(250, 185)
    dialog:SetPoint("CENTER", UIParent, "CENTER")
    dialog:EnableMouse(true)
    dialog:SetMovable(true)
    dialog:RegisterForDrag("LeftButton")
    dialog:SetScript("OnDragStart", dialog.StartMoving)
    dialog:SetScript("OnDragStop", dialog.StopMovingOrSizing)

    dialog.title = dialog:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    dialog.title:SetPoint("TOP", dialog, "TOP", -3, -5)
    dialog.title:SetText("Add player to blacklist:")

    dialog.nameLabel = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.nameLabel:SetPoint("TOPLEFT", dialog, "TOPLEFT", 15, -45)
    dialog.nameLabel:SetText("Name:")

    dialog.nameEditBox = CreateFrame("EditBox", "BlackSheepNameEditBox", dialog, "InputBoxTemplate")
    dialog.nameEditBox:SetSize(200, 20)
    dialog.nameEditBox:SetPoint("TOPLEFT", dialog.nameLabel, "LEFT", 10, -12)
    dialog.nameEditBox:SetAutoFocus(true)

    dialog.reasonLabel = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.reasonLabel:SetPoint("TOPLEFT", dialog, "BOTTOMLEFT", 15, 85)
    dialog.reasonLabel:SetText("Reason:")

    dialog.reasonEditBox = CreateFrame("EditBox", "BlackSheepReasonEditBox", dialog, "InputBoxTemplate")
    dialog.reasonEditBox:SetSize(200, 20)
    dialog.reasonEditBox:SetPoint("TOPLEFT", dialog.reasonLabel, "LEFT", 10, -12)
    dialog.reasonEditBox:SetAutoFocus(true)

    dialog.okayButton = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
    dialog.okayButton:SetPoint("BOTTOMLEFT", dialog, "BOTTOM", 20, 15)
    dialog.okayButton:SetSize(80, 22)
    dialog.okayButton:SetText("OK")
    dialog.okayButton:SetScript("OnClick", function()
        local playerName = dialog.nameEditBox:GetText()
        local reason = dialog.reasonEditBox:GetText()
        if playerName ~= "" and reason ~= "" then
            table.insert(BlackSheepSavedData.retail_DATA, {playerName, reason})
        end
        dialog:Hide()
    end)

    return dialog
end

local function OnLogout()
    SavedData = BlackSheepSavedData
end

-- Chat Commands
SLASH_BLACKSHEEP1 = "/bs"
SlashCmdList["BLACKSHEEP"] = function(msg)
    ShowInputDialog()
end

-- Login Messages
local addonLoadFrame = CreateFrame("Frame")
addonLoadFrame:RegisterEvent("ADDON_LOADED")
addonLoadFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName and not addonLoaded then
        addonLoaded = true
        print("|cff00ccffBlackSheep Version " .. appVersion .. "|r (type /bs to use)")
    end
end)


-- Tooltip Data

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

        -- Check BlackSheepSavedData
        if BlackSheepSavedData then
            for _, data in ipairs(BlackSheepSavedData.retail_DATA) do
                if data[1] == name then
                    isBlackSheep = true
                    reason = data[2] or ""
                    break
                end
            end
        end

        -- Check CustomList
        if CustomList then
            for _, data in ipairs(CustomList.custom_retail_DATA) do
                if data[1] == name then
                    isBlackSheep = true
                    reason = data[2] or ""
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









