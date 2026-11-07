-- Roleplaying Helper - WoW Forever port
-- Development checkpoint. The original 1.12 implementation depends on APIs removed
-- from Mainline; functionality is being migrated incrementally.

local addonName = ...
local RPH = CreateFrame("Frame")
_G.RPHForever = RPH

local defaults = {
    enabled = true,
    delay = 8,
    chance = 0.03,
    emoteChance = 0.25,
}

local function InitDB()
    if type(RPHForeverDB) ~= "table" then
        RPHForeverDB = {}
    end
    for k, v in pairs(defaults) do
        if RPHForeverDB[k] == nil then
            RPHForeverDB[k] = v
        end
    end
end

local function Say(message, chatType)
    if not message or message == "" then return end
    if chatType then
        SendChatMessage(message, chatType)
    else
        SendChatMessage(message, "SAY")
    end
end

function RPH:Toggle()
    InitDB()
    RPHForeverDB.enabled = not RPHForeverDB.enabled
    print(("Roleplaying Helper: %s"):format(RPHForeverDB.enabled and "enabled" or "disabled"))
end

function RPH:Status()
    InitDB()
    print(("Roleplaying Helper is %s | chance %.0f%% | delay %.1fs"):format(
        RPHForeverDB.enabled and "enabled" or "disabled",
        RPHForeverDB.chance * 100,
        RPHForeverDB.delay
    ))
end

SLASH_RPHFOREVER1 = "/rp"
SLASH_RPHFOREVER2 = "/rph"
SlashCmdList.RPHFOREVER = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")
    InitDB()
    if msg == "on" then
        RPHForeverDB.enabled = true
        print("Roleplaying Helper enabled.")
    elseif msg == "off" then
        RPHForeverDB.enabled = false
        print("Roleplaying Helper disabled.")
    elseif msg == "toggle" then
        RPH:Toggle()
    elseif msg == "status" then
        RPH:Status()
    elseif msg == "help" then
        print("/rp on | off | toggle | status")
    else
        if RPH.options then
            if RPH.options:IsShown() then RPH.options:Hide() else RPH.options:Show() end
        else
            RPH:Status()
        end
    end
end

RPH:RegisterEvent("PLAYER_LOGIN")
RPH:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        InitDB()
        self:UnregisterEvent("PLAYER_LOGIN")
        print("Roleplaying Helper (Forever) loaded. /rp help")
    end
end)
