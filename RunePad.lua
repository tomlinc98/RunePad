RunePad = {
    name = "RunePad",
    maxTabs = 4,
    tabs = {},
    activeTab = 1,
    activeTabsCount = 0
}

function RunePad:Initialize()

    -- Connect UI elements
    self.window = RunePadWindow
    self.addTabButton = RunePadAddTab

    -- Set text for the "Add Tab" button
    self.addTabButton:SetText("+")

    -- Define the add tab button's behavior
    self.addTabButton:SetHandler("OnMouseUp", function() self:AddTab() end)

    -- Handle moving of the RunePad window
    self.window:SetHandler("OnMouseUp", function() self.window:SetMovable(false) end)
    self.window:SetHandler("OnMouseDown", function() self.window:SetMovable(true) end)

    -- Initialize hidden
    self.window:SetHidden(true)

    -- Add the first tab by default
    self:AddTab()

    d("RunePad initialized.")
end

function RunePad:TabClicked(tabId)
    if self.activeTab then
        self.tabs[self.activeTab].box:SetHidden(true) -- Hide previously active box
    end

    self.activeTab = tabId
    self.tabs[tabId].box:SetHidden(false) -- Show the new active box
    d("Tab " .. tabId .. " clicked.")
end

function RunePad:AddTab()
    if self.activeTabsCount < self.maxTabs then
        self.activeTabsCount = self.activeTabsCount + 1
        local newTabId = self.activeTabsCount
        self.tabs[newTabId] = {
            button = _G["RunePadTab" .. newTabId],
            box = _G["RunePadWindowTab" .. newTabId .. "Box"]
        }
        -- set text for the button
        self.tabs[newTabId].button:SetText("Tab " .. newTabId)
        self.tabs[newTabId].button:SetHandler("OnMouseUp", function() self:TabClicked(newTabId) end)
        self.tabs[newTabId].button:SetHidden(false) -- Make button visible by default
        self.tabs[newTabId].box:SetHidden(true) -- Hide box when tab is added
        if self.activeTab == newTabId then
            self:TabClicked(newTabId)
        end
    else
        d("Maximum number of tabs reached.")
    end
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