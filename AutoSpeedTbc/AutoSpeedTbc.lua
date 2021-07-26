if not AutoCarrotDB then
    AutoCarrotDB = { enabled = true, ridingGloves = true, mithrilSpurs = true, swimBelt = true, swimHelm = true, button = false, buttonScale = 1.0 }
end

local f = CreateFrame("Frame")
f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('BAG_UPDATE')
f:RegisterEvent('ADDON_LOADED')
f:SetScript("OnUpdate", function()
    if(not AutoCarrotDB.enabled or InCombatLockdown() or UnitIsDeadOrGhost("player")) then return end
    if(IsMounted() and not UnitOnTaxi("player")) then
        local itemId = GetInventoryItemID("player", 13) -- trinket slot 1
        if(itemId) then
            if(itemId ~= 25653) then -- 25653 is 'Riding Crop', 11122 is "Carrot on a Stick"
                AutoCarrotDB.trinketId = itemId
                EquipItemByName(25653, 13)
            end
        else
            AutoCarrotDB.trinketId = nil
            EquipItemByName(25653, 13)
        end
        if(AutoCarrotDB.ridingGloves and AutoCarrotDB.enchantHandsLink) then
            itemLink = GetInventoryItemLink("player", 10) -- hands
            if(itemLink) then
                local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                if(enchantId ~= "930") then
                    AutoCarrotDB.handsLink = "item:"..itemId..":"..enchantId..":"
                    EquipItemByName(AutoCarrotDB.enchantHandsLink, 10)
                end
            else
                AutoCarrotDB.handsLink = nil
                EquipItemByName(AutoCarrotDB.enchantHandsLink, 10)
            end
        end
        if(AutoCarrotDB.mithrilSpurs and AutoCarrotDB.enchantBootsLink) then    
            itemLink = GetInventoryItemLink("player", 8) -- feet
            if(itemLink) then
                local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                if(enchantId ~= "464") then
                    AutoCarrotDB.bootsLink = "item:"..itemId..":"..enchantId..":"
                    EquipItemByName(AutoCarrotDB.enchantBootsLink, 8)
                end
            else
                AutoCarrotDB.bootsLink = nil
                EquipItemByName(AutoCarrotDB.enchantBootsLink, 8)
            end
        end
    else
        local itemId = GetInventoryItemID("player", 13) -- trinket
        if(itemId) then
            if(itemId ~= 25653) then
                AutoCarrotDB.trinketId = itemId
            elseif(AutoCarrotDB.trinketId) then
                EquipItemByName(AutoCarrotDB.trinketId, 13)
            end
        else
            AutoCarrotDB.trinketId = nil
        end
        if(AutoCarrotDB.ridingGloves and AutoCarrotDB.enchantHandsLink) then
            itemLink = GetInventoryItemLink("player", 10) -- hands
            if(itemLink) then
                local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                if(enchantId ~= "930") then
                    AutoCarrotDB.handsLink = "item:"..itemId..":"..enchantId..":"
                elseif(AutoCarrotDB.handsLink) then
                    EquipItemByName(AutoCarrotDB.handsLink, 10)
                end
            else
                AutoCarrotDB.handsLink = nil
            end
        end
        if(AutoCarrotDB.mithrilSpurs and AutoCarrotDB.enchantBootsLink) then 
            itemLink = GetInventoryItemLink("player", 8) -- feet
            if(itemLink) then
                local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                if(enchantId ~= "464") then
                    AutoCarrotDB.bootsLink = "item:"..itemId..":"..enchantId..":"
                elseif(AutoCarrotDB.bootsLink) then
                    EquipItemByName(AutoCarrotDB.bootsLink, 8)
                end
            else
                AutoCarrotDB.bootsLink = nil
            end
        end    
    end
    if(IsSwimming() and AutoCarrotDB.swimBelt) then
        local itemId = GetInventoryItemID("player", 6) -- waist
        if(itemId) then
            if(itemId ~= 7052) then
                AutoCarrotDB.beltId = itemId
                EquipItemByName(7052, 6)
            end
        else
            AutoCarrotDB.beltId = nil
            EquipItemByName(7052, 6)
        end
    else
        local itemId = GetInventoryItemID("player", 6) -- waist
        if(itemId) then
            if(itemId ~= 7052) then
                AutoCarrotDB.beltId = itemId
            elseif(AutoCarrotDB.beltId) then
                EquipItemByName(AutoCarrotDB.beltId, 6)
            end
        else
            AutoCarrotDB.beltId = nil
        end
    end
    if(IsSubmerged() and AutoCarrotDB.swimHelm) then
        local itemId = GetInventoryItemID("player", 1) -- head
        if(itemId) then
            if(itemId ~= 10506) then
                AutoCarrotDB.headId = itemId
                EquipItemByName(10506, 1)
            end
        else
            AutoCarrotDB.headId = nil
            EquipItemByName(10506, 1)
        end
    else
        local itemId = GetInventoryItemID("player", 1) -- head
        if(itemId) then
            if(itemId ~= 10506) then
                AutoCarrotDB.headId = itemId
            elseif(AutoCarrotDB.headId) then
                EquipItemByName(AutoCarrotDB.headId, 1)
            end
        else
            AutoCarrotDB.headId = nil
        end
    end
end)
f:SetScript('OnEvent', function(self, event, ...)
    if event == 'ADDON_LOADED' then 
    	local addon = ...
    	if addon == 'AutoCarrot' then
        	AutoCarrot_OnLoad()
        end
    else
        for bag = 0, NUM_BAG_SLOTS do
            for slot = 0, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if(link) then
                    local itemId, enchantId = link:match("item:(%d+):(%d+)")
                    if(enchantId == "930") then -- riding gloves
                        AutoCarrotDB.enchantHandsLink = "item:"..itemId..":930:"
                    elseif(enchantId == "464") then -- mithril spurs
                        AutoCarrotDB.enchantBootsLink = "item:"..itemId..":464:"
                    end
                end
            end
        end
    end
end)

function AutoCarrot_EquipNormalSet()
    if(InCombatLockdown() or UnitIsDeadOrGhost("player")) then return end

    if(AutoCarrotDB.trinketId) then
        EquipItemByName(AutoCarrotDB.trinketId, 13)
    end
    if(AutoCarrotDB.handsLink) then
        EquipItemByName(AutoCarrotDB.handsLink, 10)
    end
    if(AutoCarrotDB.bootsLink) then
        EquipItemByName(AutoCarrotDB.bootsLink, 8)
    end
    if(AutoCarrotDB.beltId) then
        EquipItemByName(AutoCarrotDB.beltId, 6)
    end
    if(AutoCarrotDB.headId) then
        EquipItemByName(AutoCarrotDB.headId, 1)
    end
end

-- Print handler
function AutoCarrot_Print(msg)
	print("|cff00ff00Auto|cffed9121Carrot|r: "..(msg or ""))
end

function AutoCarrot_OnLoad()
    if AutoCarrotDB.enabled then
        autoSpeedButton.overlay:SetColorTexture(0, 1, 0, 0.3)
    else
        autoSpeedButton.overlay:SetColorTexture(1, 0, 0, 0.5)
    end
    if AutoCarrotDB.button then 
        autoSpeedButton:Show() 
    else
        autoSpeedButton:Hide() 
    end
    
    autoSpeedButton:SetScale(AutoCarrotDB.buttonScale or 1)
end

-- Slash handler
local function OnSlash(key, value, ...)
    if key and key ~= "" then
        if key == "enabled" then
            if value == "toggle" or tonumber(value) then
                local enable
                if value == "toggle" then
                    enable = not AutoCarrotDB.enabled
                else
                    enable = tonumber(value) == 1 and true or false
                end
                AutoCarrotDB.enabled = enable
                AutoCarrot_Print("'enabled' set: "..( enable and "true" or "false" ))
                if not enable then AutoCarrot_EquipNormalSet() end
                AutoCarrot_OnLoad()
            else
                AutoCarrot_Print("'enabled' = "..( AutoCarrotDB.enabled and "true" or "false" ))
            end
        elseif key == "ridinggloves" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.ridingGloves = enable
                AutoCarrot_Print("'ridingGloves' set: "..( enable and "true" or "false" ))
            else
                AutoCarrot_Print("'ridingGloves' = "..( AutoCarrotDB.ridingGloves and "true" or "false" ))
            end
        elseif key == "mithrilspurs" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.mithrilSpurs = enable
                AutoCarrot_Print("'mithrilSpurs' set: "..( enable and "true" or "false" ))
            else
                AutoCarrot_Print("'mithrilSpurs' = "..( AutoCarrotDB.mithrilSpurs and "true" or "false" ))
            end

        elseif key == "swimbelt" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.swimBelt = enable
                AutoCarrot_Print("'swimBelt' set: "..( enable and "true" or "false" ))
            else
                AutoCarrot_Print("'swimBelt' = "..( AutoCarrotDB.swimBelt and "true" or "false" ))
            end
        elseif key == "swimhelm" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.swimHelm = enable
                AutoCarrot_Print("'swimHelm' set: "..( enable and "true" or "false" ))
            else
                AutoCarrot_Print("'swimHelm' = "..( AutoCarrotDB.swimHelm and "true" or "false" ))
            end
        elseif key == "button" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.button = enable
                AutoCarrot_Print("'button' set: "..( enable and "true" or "false" ))
                AutoCarrot_OnLoad()
            elseif value == "reset" then
                autoSpeedButton:ClearAllPoints()
                autoSpeedButton:SetPoint("CENTER")
                AutoCarrotDB.buttonScale = 1
                AutoCarrot_OnLoad()
                AutoCarrot_Print("Button position/scale reset.")
            elseif value == "scale" then
                local arg2 = ...
                if tonumber(arg2) then
                    AutoCarrotDB.buttonScale = arg2
                    AutoCarrot_Print("'buttonScale' set: "..AutoCarrotDB.buttonScale)
                    AutoCarrot_OnLoad()
                else
                    AutoCarrot_Print("'buttonScale' = "..AutoCarrotDB.buttonScale or 1)
                    AutoCarrot_Print("Usage: /autocarrot button scale 1.0")
                end
            else
                AutoCarrot_Print("'button' = "..( AutoCarrotDB.button and "true" or "false" ))
            end   
        end
    else
        AutoCarrot_Print("Slash commands")
        AutoCarrot_Print(" - enabled 0/1/toggle ("..(AutoCarrotDB.enabled and "1" or "0")..")")
        AutoCarrot_Print(" - ridingGloves 0/1 ("..(AutoCarrotDB.ridingGloves and "1" or "0")..")")
        AutoCarrot_Print(" - mithrilSpurs 0/1 ("..(AutoCarrotDB.mithrilSpurs and "1" or "0")..")")
        AutoCarrot_Print(" - swimBelt 0/1 ("..(AutoCarrotDB.swimBelt and "1" or "0")..")")
        AutoCarrot_Print(" - swimHelm 0/1 ("..(AutoCarrotDB.swimHelm and "1" or "0")..")")
        AutoCarrot_Print(" - button 0/1/reset/scale ("..(AutoCarrotDB.button and "1" or "0")..")")
    end
end

SLASH_AUTOCARROT1 = "/autocarrot";
SLASH_AUTOCARROT2 = "/ac";
SLASH_AUTOCARROT3 = "/speed";
SlashCmdList["AUTOCARROT"] = function(msg)
    msg = string.lower(msg)
    msg = { string.split(" ", msg) }
    if #msg >= 1 then
        local exec = table.remove(msg, 1)
        OnSlash(exec, unpack(msg))
    end
end

autoSpeedButton = CreateFrame("Button", "autoSpeedButton", UIParent, "ActionButtonTemplate")
autoSpeedButton.icon:SetTexture(571558)
autoSpeedButton:SetPoint("CENTER")
autoSpeedButton.overlay = autoSpeedButton:CreateTexture(nil, "OVERLAY")
autoSpeedButton.overlay:SetAllPoints(autoSpeedButton)
autoSpeedButton:RegisterForDrag("LeftButton")
autoSpeedButton:SetMovable(true)
autoSpeedButton:SetUserPlaced(true)
autoSpeedButton:SetScript("OnDragStart", function() if IsAltKeyDown() then autoSpeedButton:StartMoving() end end)
autoSpeedButton:SetScript("OnDragStop", autoSpeedButton.StopMovingOrSizing)
autoSpeedButton:SetScript("OnClick", function()
    if AutoCarrotDB.enabled then
        autoSpeedButton.overlay:SetColorTexture(1, 0, 0, 0.5)
        AutoCarrotDB.enabled = false
        AutoCarrot_EquipNormalSet()
    else
        autoSpeedButton.overlay:SetColorTexture(0, 1, 0, 0.3)
        AutoCarrotDB.enabled = true
    end
end)
