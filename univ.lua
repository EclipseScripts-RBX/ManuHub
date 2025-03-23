-- v 1.2
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local player = game.Players.LocalPlayer
local Character1 = player.Character or player.CharacterAdded:Wait()
local hrp = Character1:FindFirstChild("HumanoidRootPart")
local Humanoid1 = Character1:FindFirstChildOfClass("Humanoid")
local isSpinning = false
local maxhealth = Humanoid1.MaxHealth
local savedWalkSpeed = 16
local savedJumpPower = 50
local freezeState = false


local function updateCharacterReferences()
    task.wait(0.5)
    Character1 = player.Character or player.CharacterAdded:Wait()
    hrp = Character1:FindFirstChild("HumanoidRootPart")
    Humanoid1 = Character1:FindFirstChildOfClass("Humanoid")
    maxhealth = Humanoid1.MaxHealth

    Humanoid1.WalkSpeed = savedWalkSpeed
    Humanoid1.UseJumpPower = true
    Humanoid1.JumpPower = savedJumpPower
    hrp.Anchored = freezeState
end

player.CharacterAdded:Connect(updateCharacterReferences)

local Window = Fluent:CreateWindow({
    Title = "Manu Hub",
    SubTitle = player.Name,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Info = Window:AddTab({ Title = "Info", Icon = "info" }),
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
    Character = Window:AddTab({ Title = "Character", Icon = "person-standing" }),
    Troll = Window:AddTab({ Title = "Troll", Icon = "angry" })
}

Tabs.Info:AddParagraph({
    Title = "Updated",
    Content = "Updated on 23.03.2025.\n"
})

Tabs.Info:AddButton({
    Title = "Join our discord!",
    Description = "Copy link to keyboard",
    Callback = function()
       setclipboard("https://discord.gg/BRuzAwfEUX")
       Fluent:Notify({
        Title = "Copied!",
        Content = "copied to clipboard",
        SubContent = ":)", 
        Duration = 5 
    })
    end
})

Fluent:Notify({
    Title = "Universal",
    Content = "Might be patched depending on game",
    SubContent = "Use with caution", 
    Duration = 5 
})

Tabs.Main:AddButton({
    Title = "Close script",
    Description = "Exits the script",
    Callback = function()
        Window:Dialog({
            Title = "Exit script?",
            Content = "Are you sure?",
            Buttons = {
                { 
                    Title = "Yes",
                    Callback = function()
                        Fluent:Destroy()
                    end 
                },
                { Title = "Cancel" }
            }
        })
    end
})

Window:SelectTab(1)

Tabs.Character:AddSlider("Slider", {
    Title = "WalkSpeed",
    Description = "Change your walking speed",
    Default = 16,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        savedWalkSpeed = Value
        if Humanoid1 then
            Humanoid1.WalkSpeed = Value
        end
    end
})

Tabs.Character:AddSlider("Slider", {
    Title = "Jump Power",
    Description = "Change your jump power",
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Callback = function(Value)
        savedJumpPower = Value
        if Humanoid1 then
            Humanoid1.UseJumpPower = true
            Humanoid1.JumpPower = Value
        end
    end
})

Tabs.Character:AddToggle("MyToggle", {
    Title = "Freeze Character",
    Description = "Freeze your character",
    Default = false,
    Callback = function(state)
        freezeState = state
        if hrp then
            hrp.Anchored = state
        end
    end
})

local Dropdown = Tabs.Troll:AddDropdown("Dropdown", {
    Title = "Select Player",
    Description = "Select a player",
    Values = {},
    Multi = false,
    Default = 1,
})

local function RefreshDropdown()
    local playerNames = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        table.insert(playerNames, p.Name)
    end
    Dropdown:SetValues(playerNames)
end

Tabs.Troll:AddButton({
    Title = "Refresh Player List",
    Description = "Refreshes the list of players",
    Callback = function()
        RefreshDropdown()
    end
})

Tabs.Troll:AddButton({
    Title = "Fling",
    Description = "Select player first",
    Callback = function()
        local selectedPlayerName = Dropdown.Value 
        local selectedPlayer = game.Players:FindFirstChild(selectedPlayerName)

        if selectedPlayer then
            local targetHRP = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")

            if targetHRP and hrp then
                local startTime = tick()
                local bp = Instance.new("BodyPosition", hrp)
                local ba = Instance.new("BodyAngularVelocity", hrp)

                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.Position = hrp.Position

                ba.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                ba.AngularVelocity = Vector3.new(0, 10000000, 0)

                while tick() - startTime < 5 do
                    task.wait(0.1)
                    if hrp and targetHRP then
                        hrp.CFrame = targetHRP.CFrame
                    end
                end
                
                hrp.Velocity = Vector3.new(0, 5000, 0)
                
                bp:Destroy()
                ba:Destroy()
            end
        end
    end
})

Tabs.Character:AddButton({
    Title = "Kill Character",
    Description = "Does what it says",
    Callback = function()
        if Humanoid1 then
            Humanoid1.Health = 0
        end
    end
})

Tabs.Character:AddButton({
    Title = "Heal Character",
    Description = "Heals your character",
    Callback = function()
        if Humanoid1 then
            Humanoid1.Health = maxhealth
        end
    end
})

Tabs.Main:AddButton({
    Title = "Reload",
    Description = "Reloads the script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EclipseScripts-RBX/ManuHub/refs/heads/main/Universal.lua"))()
        task.wait(1)
        Fluent:Destroy()
    end
})

local function addESP(character, teamColor)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = character

        if teamColor == "Enemy" then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        else
            highlight.FillColor = Color3.fromRGB(0, 0, 255)
        end

        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function onCharacterAdded(player)
    task.wait(1)
    if player ~= game.Players.LocalPlayer then
        local teamColor = "Friendly"
        if game.Players.LocalPlayer.Team ~= player.Team then
            teamColor = "Enemy"
        end
        addESP(player.Character, teamColor)
    end
end

local function onPlayerAdded(player)
    if player.Character then
        onCharacterAdded(player)
    end
    player.CharacterAdded:Connect(function()
        onCharacterAdded(player)
    end)
end

Tabs.Main:AddButton({
    Title = "Enable ESP",
    Description = "Adds ESP to enemy players",
    Callback = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then 
                onPlayerAdded(p)
            end
        end
        game.Players.PlayerAdded:Connect(onPlayerAdded)
    end
})
