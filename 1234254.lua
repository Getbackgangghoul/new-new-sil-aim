if getgenv().GhoulAimHacks then return getgenv().GhoulAimHacks end

-- // Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

-- // Vars
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Optimisation Vars (ugly)
local Drawingnew = Drawing.new
local Color3fromRGB = Color3.fromRGB
local Vector2new = Vector2.new
local GetGuiInset = GuiService.GetGuiInset
local Randomnew = Random.new
local mathfloor = math.floor
local CharacterAdded = LocalPlayer.CharacterAdded
local CharacterAddedWait = CharacterAdded.Wait
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local RaycastParamsnew = RaycastParams.new
local EnumRaycastFilterTypeBlacklist = Enum.RaycastFilterType.Blacklist
local Raycast = Workspace.Raycast
local GetPlayers = Players.GetPlayers
local Instancenew = Instance.new
local IsDescendantOf = Instancenew("Part").IsDescendantOf
local FindFirstChildWhichIsA = Instancenew("Part").FindFirstChildWhichIsA
local FindFirstChild = Instancenew("Part").FindFirstChild

-- // Silent Aim Vars
getgenv().GhoultAimHacks = {
    SilentAimEnabled = true,
    ShowFOV = true,
    FOVSides = 12,
    VisibleCheck = true,
    TeamCheck = true,
    FOV = 60,
    HitChance = 100,
    Selected = LocalPlayer,
    SelectedPart = nil,
    TargetPart = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"},
    BlacklistedTeams = {
        {
            Team = LocalPlayer.Team,
            TeamColor = LocalPlayer.TeamColor,
        },
    },
    BlacklistedPlayers = {LocalPlayer},
    WhitelistedPUIDs = {91318356},
}
local GhoulAimHacks = getgenv().GhoulAimHacks

-- // Show FOV
local circle = Drawingnew("Circle")
circle.Transparency = 1
circle.Thickness = 2
circle.Color = Color3fromRGB(231, 84, 128)
circle.Filled = false
function GhoulAimHacks.updateCircle()
    if (circle) then
        -- // Set Circle Properties
        circle.Visible = GhoulAimHacks.ShowFOV
        circle.Radius = (GhoulAimHacks.FOV * 3)
        circle.Position = Vector2new(Mouse.X, Mouse.Y + GetGuiInset(GuiService).Y)
        circle.NumSides = GhoulAimHacks.FOVSides

        -- // Return circle
        return circle
    end
end

-- // Custom Functions
local calcChance = function(percentage)
    percentage = mathfloor(percentage)
    local chance = mathfloor(Randomnew().NextNumber(Randomnew(), 0, 1) * 100) / 100
    return chance <= percentage / 100
end

-- // Customisable Checking Functions: Is a part visible
function GhoulAimHacks.isPartVisible(Part, PartDescendant)
    -- // Vars
    local Character = LocalPlayer.Character or CharacterAddedWait(CharacterAdded)
    local Origin = CurrentCamera.CFrame.Position
    local _, OnScreen = WorldToViewportPoint(CurrentCamera, Part.Position)

    -- // If Part is on the screen
    if (OnScreen) then
        -- // Vars: Calculating if is visible
        local raycastParams = RaycastParamsnew()
        raycastParams.FilterType = EnumRaycastFilterTypeBlacklist
        raycastParams.FilterDescendantsInstances = {Character, CurrentCamera}

        local Result = Raycast(Workspace, Origin, Part.Position - Origin, raycastParams)
        if (Result) then
            local PartHit = Result.Instance
            local Visible = (not PartHit or IsDescendantOf(PartHit, PartDescendant))

            -- // Return
            return Visible
        end
    end

    -- // Return
    return false
end

-- // Check teams
function GhoulAimHacks.checkTeam(targetPlayerA, targetPlayerB)
    -- // If player is not on your team
    if (targetPlayerA.Team ~= targetPlayerB.Team) then

        -- // Check if team is blacklisted
        for i = 1, #GhoulAimHacks.BlacklistedTeams do
            local v = GhoulAimHacks.BlacklistedTeams

            if (targetPlayerA.Team ~= v.Team and targetPlayerA.TeamColor ~= v.TeamColor) then
                return true
            end
        end
    end

    -- // Return
    return false
end

-- // Check if player is blacklisted
function GhoulAimHacks.checkPlayer(targetPlayer)
    for i = 1, #GhoulAimHacks.BlacklistedPlayers do
        local v = GhoulAimHacks.BlacklistedPlayers[i]

        if (v ~= targetPlayer) then
            return true
        end
    end

    -- // Return
    return false
end

-- // Check if player is whitelisted
function GhoulAimHacks.checkWhitelisted(targetPlayer)
    for i = 1, #GhoulAimHacks.WhitelistedPUIDs do
        local v = GhoulAimHacks.WhitelistedPUIDs[i]

        if (targetPlayer.UserId == v) then
            return true
        end
    end

    -- // Return
    return false
end

-- // Blacklist player
function GhoAimHacks.BlacklistPlayer(Pullayer)
    local BlacklistedPlayers = GhoulAimHacks.BlacklistedPlayers

    -- // Find player in table
    for i = 1, #BlacklistedPlayers do
        local BlacklistedPlayer = BlacklistedPlayers[i]

        if (BlacklistedPlayer == Player) then
            return false
        end
    end

    -- // Blacklist player
    BlacklistedPlayers[#BlacklistedPlayers + 1] = Player
    return true
end

-- // Unblacklist Player
function GhoulAimHacks.UnblacklistPlayer(Player)
    local BlacklistedPlayers = GhoulAimHacks.BlacklistedPlayers

    -- // Find player in table
    for i = 1, #BlacklistedPlayers do
        local BlacklistedPlayer = BlacklistedPlayers[i]

        if (BlacklistedPlayer == Player) then
            table.remove(BlacklistedPlayer, i)
            return true
        end
    end

    -- //
    return false
end

-- // Whitelist player
function GhoulAimHacks.WhitelistPlayer(PlayerId)
    local WhitelistedPUIDs = GhoulHacks.WhitelistedPUIDs

    -- // Find player in table
    for i = 1, #WhitelistedPUIDs do
        local WhitelistedPUID = WhitelistedPUIDs[i]

        if (WhitelistedPUID == PlayerId) then
            return false
        end
    end

    -- // Whitelist player
    WhitelistedPUIDs[#WhitelistedPUIDs + 1] = PlayerId
    return true
end

-- // Unwhitelist Player
function GhoulAimHacks.UnwhitelistPlayer(PlayerId)
    local WhitelistedPUIDs = GhoulAimHacks.WhitelistedPUIDs

    -- // Find player in table
    for i = 1, #WhitelistedPUIDs do
        local WhitelistedPUID = WhitelistedPUIDs[i]

        if (WhitelistedPUID == PlayerId) then
            table.remove(WhitelistedPUID, i)
            return true
        end
    end

    -- //
    return false
end

-- // Get the Direction, Normal and Material
function GhoulAimHacks.findDirectionNormalMaterial(Origin, Destination, UnitMultiplier)
    if (typeof(Origin) == "Vector3" and typeof(Destination) == "Vector3") then
        -- // Handling
        if (not UnitMultiplier) then UnitMultiplier = 1 end

        -- // Vars
        local Direction = (Destination - Origin).Unit * UnitMultiplier
        local RaycastResult = Raycast(Workspace, Origin, Direction)

        if (RaycastResult ~= nil) then
            local Normal = RaycastResult.Normal
            local Material = RaycastResult.Material

            return Direction, Normal, Material
        end
    end

    -- // Return
    return nil
end

-- // Get Character
function GhoulAimHacks.getCharacter(Player)
    return Player.Character
end

-- // Check Health
function GhoulAimHacks.checkHealth(Player)
    local Character = GhoulAimHacks.getCharacter(Player)
    local Humanoid = FindFirstChildWhichIsA(Character, "Humanoid")

    local Health = (Humanoid and Humanoid.Health or 0)
    return Health > 0
end

-- // Check if silent aim can used
function GhoulAimHacks.checkSilentAim()
    return (GhoulAimHacks.SilentAimEnabled == true and GhoulAimHacks.Selected ~= LocalPlayer and GhoulAimHacks.SelectedPart ~= nil)
end

-- // Get Closest Target Part
function GhoulAimHacks.getClosestTargetPartToCursor(Character)
    local TargetParts = GhoulAimHacks.TargetPart

    -- // Vars
    local ClosestPart = nil
    local ClosestPartPosition = nil
    local ClosestPartOnScreen = false
    local ClosestPartMagnitudeFromMouse = nil
    local ShortestDistance = 1/0

    -- //
    local function checkTargetPart(TargetPartName)
        local TargetPart = FindFirstChild(Character, TargetPartName)

        if (TargetPart) then
            local PartPos, onScreen = WorldToViewportPoint(CurrentCamera, TargetPart.Position)
            local Magnitude = (Vector2new(PartPos.X, PartPos.Y) - Vector2new(Mouse.X, Mouse.Y)).Magnitude

            if (Magnitude < ShortestDistance) then
                ClosestPart = TargetPart
                ClosestPartPosition = PartPos
                ClosestPartOnScreen = onScreen
                ClosestPartMagnitudeFromMouse = Magnitude
                ShortestDistance = Magnitude
            end
        end
    end

    -- // String check
    if (typeof(TargetParts) == "string") then
        checkTargetPart(TargetParts)
    end

    -- // Loop through all target parts
    if (typeof(TargetParts) == "table") then
        for i = 1, #TargetParts do
            local TargetPartName = TargetParts[i]
            checkTargetPart(TargetPartName)
        end
    end

    -- //
    return ClosestPart, ClosestPartPosition, ClosestPartOnScreen, ClosestPartMagnitudeFromMouse
end

-- // Silent Aim Function
function GhoulAimHacks.getClosestPlayerToCursor()
    -- // Vars
    local TargetPart = nil
    local ClosestPlayer = nil
    local Chance = calcChance(GhoulAimHacks.HitChance)
    local ShortestDistance = 1/0

    -- // Chance
    if (not Chance) then
        PoopAimHacks.Selected = LocalPlayer
        PoopAimHacks.SelectedPart = nil

        return LocalPlayer
    end

    -- // Loop through all players
    local AllPlayers = GetPlayers(Players)
    for i = 1, #AllPlayers do
        local Player = AllPlayers[i]
        local Character = GhoulAimHacks.getCharacter(Player)

        if (not GhoulAimHacks.checkWhitelisted(Player) and GhoulAimHacks.checkPlayer(Player) and Character) then
              local TargetPartTemp, PartPos, onScreen, Magnitude = GhoulAimHacks.getClosestTargetPartToCursor(Character)

            if (TargetPartTemp and GhoulAimHacks.checkHealth(Player)) then
                -- // Team Check
                if (GhoulAimHacks.TeamCheck and not GhoulAimHacks.checkTeam(Player, LocalPlayer)) then continue end

                -- // Check if is in FOV
                if (circle.Radius > Magnitude and Magnitude < ShortestDistance) then
                    -- // Check if Visible
                    if (GhoulAimHacks.VisibleCheck and not GhoulAimHacks.isPartVisible(TargetPartTemp, Character)) then continue end

                    -- //
                    ClosestPlayer = Player
                    ShortestDistance = Magnitude
                    TargetPart = TargetPartTemp
                end
            end
        end
    end

    -- // End
    GhoulAimHacks.Selected = ClosestPlayer
    GhoulAimHacks.SelectedPart = TargetPart
end

-- // Heartbeat Function
Heartbeat:Connect(function()
    GhoulAimHacks.updateCircle()
    GhoulAimHacks.getClosestPlayerToCursor()
end)

return GhoulAimHacks

--[[
Examples:
--// Namecall Version // --
-- // Metatable Variables
local mt = getrawmetatable(game)
local backupindex = mt.__index
setreadonly(mt, false)
-- // Load Silent Aim
local ValiantAimHacks = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Getbackgangghoul/new-new-sil-aim/main/1234254.lua"))()
-- // Hook
mt.__namecall = newcclosure(function(...)
    -- // Vars
    local args = {...}
    local method = getnamecallmethod()
    -- // Checks
    if (method == "FireServer") then
        if (args[1].Name == "RemoteNameHere") then
            -- change args
            -- // Return changed arguments
            return backupnamecall(unpack(args))
        end
    end
    -- // Return
    return backupnamecall(...)
end)
-- // Revert Metatable readonly status
setreadonly(mt, true)
-- // Index Version // --
-- // Metatable Variables
local mt = getrawmetatable(game)
local backupindex = mt.__index
setreadonly(mt, false)
-- // Load Silent Aim
local GhoulAimHacks = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Getbackgangghoul/new-new-sil-aim/main/1234254.lua"))()
-- // Hook
mt.__index = newcclosure(function(t, k)
    -- // Check if it trying to get our mouse's hit or target
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target")) then
        -- // If we can use the silent aim
        if (GhoulAimHacks.checkSilentAim()) then
            -- // Vars
            local TargetPart = GhoulAimHacks.SelectedPart
            -- // Return modded val
            return (k == "Hit" and TargetPart.CFrame or TargetPart)
        end
    end
    -- // Return
    return backupindex(t, k)
end)
-- // Revert Metatable readonly status
setreadonly(mt, true)
]]
