RunePad = {
    name = "RunePad",
    tabs = {},
    activeTab = nil
}

function RunePad:Initialize()

    -- Connect UI elements
    self.window = RunePadWindow
    self.tabs = {
        ["Tab1"] = {
            button = RunePadTab1,
            box = RunePadWindowTab1Box
        },
        ["Tab2"] = {
            button = RunePadTab2,
            box = RunePadWindowTab2Box
        }
    }

    -- Define the tabs' behavior
    for tabName, tab in pairs(self.tabs) do
        tab.button:SetHandler("OnMouseUp", function() self:TabClicked(tabName) end)
        tab.box:SetHidden(true) -- Hide all boxes by default
    end

    -- Show the first tab by default
    self:TabClicked("Tab1")

    -- Handle moving of the RunePad window
    self.window:SetHandler("OnMouseUp", function() self.window:SetMovable(false) end)
    self.window:SetHandler("OnMouseDown", function() self.window:SetMovable(true) end)

    -- Initialize hidden
    self.window:SetHidden(true)
    
    d("RunePad initialized.")
end

function RunePad:TabClicked(tabName)
    if self.activeTab then
        self.tabs[self.activeTab].box:SetHidden(true) -- Hide previously active box
    end

    self.activeTab = tabName
    self.tabs[tabName].box:SetHidden(false) -- Show the new active box
    d(tabName .. " clicked.")
end

function RunePad:ToggleWindow()
    local isHidden = self.window:IsHidden()
    self.window:SetHidden(not isHidden)
end

function RunePad.OnAddOnLoaded(event, addonName)
    if addonName == RunePad.name then
        RunePad:Initialize()
    end
end

-- Event handlers
EVENT_MANAGER:RegisterForEvent(RunePad.name, EVENT_ADD_ON_LOADED, RunePad.OnAddOnLoaded)

-- Slash commands
SLASH_COMMANDS["/runepad"] = function() RunePad:ToggleWindow() end
