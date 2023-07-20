RunePad = {
    name = "RunePad",
    tabs = {},
    activeTab = nil
}

function RunePad:Initialize()

    -- Connect UI elements
    self.window = RunePadWindow
    self.tabs = {}

    -- Connect the "Add Tab" button and set its handler
    self.addTabButton = RunePadAddTabButton
    self.addTabButton:SetHandler("OnMouseUp", function() self:AddTab() end)

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

function RunePad:AddTab()
    -- Generate a unique tab name
    local tabName = "Tab" .. tostring(#self.tabs + 1)

    -- Create a new button for the tab
    local newTabButton = WINDOW_MANAGER:CreateControl("RunePadTab" .. tabName, RunePadWindow, CT_BUTTON)
    newTabButton:SetDimensions(100, 30)
    
    -- Position the new tab next to the last tab
    local offsetX = 10 + #self.tabs * 110 -- 110 = width of a tab + 10 for spacing
    newTabButton:SetAnchor(TOPLEFT, RunePadWindow, TOPLEFT, offsetX, 10)
    
    -- Create the text box for the new tab
    local newTextBox = WINDOW_MANAGER:CreateControlFromVirtual("RunePadWindowTab" .. tabName .. "Box", RunePadWindow, "ZO_DefaultEditForBackdrop")
    newTextBox:SetDimensions(480, 450)
    newTextBox:SetAnchor(TOPLEFT, newTabButton, BOTTOMLEFT, 0, 10)
    newTextBox:SetHidden(true)

    -- Add the new tab to the tabs table
    self.tabs[tabName] = {
        button = newTabButton,
        box = newTextBox
    }

    -- Set up the OnMouseUp handler for the new tab
    newTabButton:SetHandler("OnMouseUp", function() self:TabClicked(tabName) end)

    -- Update the position of the "Add Tab" button
    offsetX = offsetX + 110
    self.addTabButton:SetAnchor(TOPLEFT, RunePadWindow, TOPLEFT, offsetX, 10)
end

-- Event handlers
EVENT_MANAGER:RegisterForEvent(RunePad.name, EVENT_ADD_ON_LOADED, RunePad.OnAddOnLoaded)

-- Slash commands
SLASH_COMMANDS["/runepad"] = function() RunePad:ToggleWindow() end
