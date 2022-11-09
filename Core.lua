
---@diagnostic disable: deprecated
TwitchEmotes_Flow&Friends = LibStub("AceAddon-3.0"):NewAddon("TwitchEmotes_Flow&Friends", "AceConsole-3.0", "AceEvent-3.0")
local AddonName = ...

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local _ = nil

local default_db = {
    profile = {
        minimap = {
            hide = true,
        },
        features = {
            autocomplete = {
                enabled = true,
                with_tab = false, -- TODO
            }
        }
    }
}

-- Create minimap button
local minimapHeadingColor = "|cFFFFFFFF"
local minimapIconRegistered = false

local TES_LDB = LDB:NewDataObject("TwitchEmotes_Flow&Friends", {
    type = "data source",
    text = "Twitch Emotes Flow&Friends",
    icon = "Interface\\AddOns\\TwitchEmotes_Flow&Friends\\logo",
    OnClick = function(_, buttonPressed)
        if buttonPressed == "RightButton" then
            TwitchEmotes_Flow&Friends:ToggleMinimapLock()
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then
            return
        end
        tooltip:AddLine(minimapHeadingColor .. "Twitch Emotes Flow&Friends|r")
        --tooltip:AddLine("Click to toggle AddOn Window")
        tooltip:AddLine(" ")
        tooltip:AddLine("Right-click to lock Minimap Button")
        tooltip:AddLine("To toggle minimap button, type /tes minimap")
        tooltip:AddLine("More features to come in the future!")
    end
})

--Init
function TwitchEmotes_Flow&Friends:OnInitialize()
    --Register DB
    TwitchEmotes_Flow&Friends:RegisterDatabase()

    LDBIcon:Register("TwitchEmotes_Flow&Friends", TES_LDB, self.db.profile.minimap)

    --Register UI Options
    TwitchEmotes_Flow&Friends:RegisterOptions()

    --Load Features
    TwitchEmotes_Flow&Friends:ToggleMinimapButton()
    TwitchEmotes_Flow&Friends:SetAutoComplete(self.db.profile.features.autocomplete.enabled)

    --Register chat commands
    TwitchEmotes_Flow&Friends:RegisterChatCommand("tes", "SlashCommand")
	TwitchEmotes_Flow&Friends:RegisterChatCommand("twitchemotesFlow&Friends", "SlashCommand")
end

function TwitchEmotes_Flow&Friends:SlashCommand(msg)
    if not msg or msg:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end

    if msg == "minimap" then
        TwitchEmotes_Flow&Friends:ToggleMinimapButton(_, self.db.profile.minimap.hide)
    end
end

function TwitchEmotes_Flow&Friends:RegisterDatabase()
    self.db = LibStub("AceDB-3.0"):New("TwitchEmotes_Flow&Friends_Settings", default_db, true)
end


function TwitchEmotes_Flow&Friends:RegisterOptions()
    local options = {
        name = "Twitch Emotes Flow&Friends",
        handler = TwitchEmotes_Flow&Friends,
        type = "group",
        args = {
            enable = {
                type = 'toggle',
                name = "Enable Minimap Button",
                desc = "If the Minimap Button is enabled",
                get = "IsMinimapButtonShown",
                set = "ToggleMinimapButton",
                order = 1,
                width = "full"
            },
            locked = {
                type = 'toggle',
                name = "Lock Minimap Button",
                desc = "If the Minimap Button is locked",
                get = "IsMinimapLocked",
                set = "ToggleMinimapLock",
                order = 2,
                width = "full"
            }
        }
    }

    AC:RegisterOptionsTable("TwitchEmotes_Flow&Friends_options", options)
    self.optionsFrame = ACD:AddToBlizOptions("TwitchEmotes_Flow&Friends_options", "TwitchEmotes_Flow&Friends")
end

function TwitchEmotes_Flow&Friends:IsMinimapButtonShown(info)
    return not self.db.profile.minimap.hide
end

function TwitchEmotes_Flow&Friends:ToggleMinimapButton(_,toggle)
    if (toggle ~= nil) then
        self.db.profile.minimap.hide = not toggle
    end

    if(self.db.profile.minimap.hide) then
        LDBIcon:Hide("TwitchEmotes_Flow&Friends")
    else
        LDBIcon:Show("TwitchEmotes_Flow&Friends")
    end
end

function TwitchEmotes_Flow&Friends:IsMinimapLocked(info)
    return self.db.profile.minimap.lock
end

function TwitchEmotes_Flow&Friends:ToggleMinimapLock(info)
    if(self.db.profile.minimap.lock) then
        LDBIcon:Unlock("TwitchEmotes_Flow&Friends")
    else
        LDBIcon:Lock("TwitchEmotes_Flow&Friends")
    end

end
