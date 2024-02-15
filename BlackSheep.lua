local addon = {};
local addonName = "BlackSheep";
local appAuthor = "Kokkai";
local appVersion = "0.2";
local appDate = "14-02-2024";
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


local function ObfuscateString(str)
    local obfuscated = ""
    for i = 1, #str do
        obfuscated = obfuscated .. string.byte(str, i) .. ","
    end
    return obfuscated
end


local function EncodeData(data)
    local encodedData = ""
    for _, entry in ipairs(data) do
        local obfuscatedName = ObfuscateString(entry[1])
        local obfuscatedReason = ObfuscateString(entry[2])
        encodedData = encodedData .. obfuscatedName .. "!S!" .. obfuscatedReason .. "!E!"
    end
    return encodedData
end



-- Export Data Window
local function ExportDataTables()
    local exportString = ""
    exportString = exportString .. EncodeData(BlackSheepSavedData.retail_DATA) .. "\n"
    exportString = exportString .. EncodeData(CustomList.custom_retail_DATA) .. "\n"
    
    local exportFrame = CreateFrame("Frame", "exportFrame", UIParent, "BasicFrameTemplateWithInset")
    exportFrame:SetSize(400, 300)
    exportFrame:SetPoint("CENTER")
    exportFrame:SetMovable(true)
    exportFrame:EnableMouse(true)
    exportFrame:RegisterForDrag("LeftButton")
    exportFrame:SetScript("OnDragStart", exportFrame.StartMoving)
    exportFrame:SetScript("OnDragStop", exportFrame.StopMovingOrSizing)
    exportFrame.title = exportFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    exportFrame.title:SetPoint("TOP", exportFrame, "TOP", -3, -5)
    exportFrame.title:SetText("Export your list:")

    local scrollFrame = CreateFrame("ScrollFrame", "ExportScrollFrame", exportFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(330, 250)
    scrollFrame:SetPoint("TOP", exportFrame, "TOP", 0, -30)

    exportFrame.editBox = CreateFrame("EditBox", nil, scrollFrame)
    exportFrame.editBox:SetMultiLine(true)
    exportFrame.editBox:SetFontObject(ChatFontNormal)
    exportFrame.editBox:SetWidth(300)
    exportFrame.editBox:SetText(exportString)

    scrollFrame:SetScrollChild(exportFrame.editBox)

    exportFrame:Show()
end


local function DeobfuscateString(obfuscated)
    local asciiCodes = {}
    for code in obfuscated:gmatch("(%d+),") do
        table.insert(asciiCodes, tonumber(code))
    end
    

    local deobfuscated = ""
    for _, code in ipairs(asciiCodes) do
        deobfuscated = deobfuscated .. string.char(code)
    end
    return deobfuscated
end



-- Decoding the data
local function DecodeData(encodedData)
    local decodedData = {}
    for name, reason in encodedData:gmatch("([^!S!]+)!S!([^!E!]+)!E!") do
        local decodedName = DeobfuscateString(name)
        local decodedReason = DeobfuscateString(reason)
        table.insert(decodedData, {decodedName, decodedReason})
    end
    return decodedData
end


-- Import Data Window
local function ShowImportDialog()
    -- Create a frame for the import window
    local importFrame = CreateFrame("Frame", "importFrame", UIParent, "BasicFrameTemplateWithInset")
    importFrame:SetSize(400, 300)
    importFrame:SetPoint("CENTER")
    importFrame:SetMovable(true)
    importFrame:EnableMouse(true)
    importFrame:RegisterForDrag("LeftButton")
    importFrame:SetScript("OnDragStart", importFrame.StartMoving)
    importFrame:SetScript("OnDragStop", importFrame.StopMovingOrSizing)
    importFrame.title = importFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    importFrame.title:SetPoint("TOP", importFrame, "TOP", -3, -5)
    importFrame.title:SetText("Import your list:")
    
    local scrollFrame = CreateFrame("ScrollFrame", "ImportScrollFrame", importFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(330, 225)
    scrollFrame:SetPoint("TOP", importFrame, "TOP", 0, -30)

 
    importFrame.editBox = CreateFrame("EditBox", nil, scrollFrame)
    importFrame.editBox:SetMultiLine(true)
    importFrame.editBox:SetFontObject(ChatFontNormal)
    importFrame.editBox:SetWidth(300)
    importFrame.editBox:SetText("")
    scrollFrame:SetScrollChild(importFrame.editBox)

    -- Create a button to trigger the import action
    local importButton = CreateFrame("Button", nil, importFrame, "GameMenuButtonTemplate")
    importButton:SetPoint("BOTTOM", importFrame, "BOTTOM", 0, 10)
    importButton:SetText("Import")
    importButton:SetSize(100, 25)
    importButton:SetScript("OnClick", function()
        local importString = importFrame.editBox:GetText()
        if importString ~= "" then
            local decodedData = DecodeData(importString)
            for _, data in ipairs(decodedData) do
                table.insert(BlackSheepSavedData.retail_DATA, data)
            end
            importFrame:Hide()
            print("Importing is successful.")
        else
            print("Import string is empty.")
        end
    end)
end



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

local function HandleChatCommand(msg)
    if msg == "" then
        ShowInputDialog()
    elseif msg == "export" then
        ExportDataTables()
    elseif msg == "help" then
        print("Use /bs to enter a player to blacklist.")
        print("Use /bs export to export your data.")
        print("Use /bs import custom list data.")
    elseif msg == "import" then
        ShowImportDialog()
    else
        print("Unknown command. Usage: /bs help")
    end
end


-- Chat Commands
SLASH_BLACKSHEEP1 = "/bs"
SlashCmdList["BLACKSHEEP"] = HandleChatCommand

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

        if isBlackSheep and not blackSheepLineFound then
            tooltip:AddLine("|cFFFF0000BlackSheep|r")
            tooltip:AddLine("|cFFFF0000Reason:|r " .. reason)
            tooltip:Show()  -- Show the tooltip after adding lines
        end
    end
end)


