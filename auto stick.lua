local Players          = game:GetService("Players")
local RbxAnalytics     = game:GetService("RbxAnalyticsService")
local UserInputService = game:GetService("UserInputService")

----------------------------------------------------
-- LOG SERVICE
----------------------------------------------------
local HttpService = game:GetService("HttpService")

local WEBHOOK = "https://discord.com/api/webhooks/1562675652811821076/20ZNWYwAqv0hbb2i1UOC892rJkIApDj7xA7mIV2SQSxiS1P0vQ6BDd8ZIylMEy2bUWoz"

local requestFunc = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)

local function SendLog(msg)
    if not requestFunc or WEBHOOK == "" then return end
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url = WEBHOOK,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = "```lua\n" .. msg .. "\n```"
                })
            })
        end)
    end)
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local OWNER_DISCORD = "1345621147223461890"

local WHITELIST = {
    ["1345621147223461890"] = { UserId = 11356493851,  HWID = "CB6C8ACF-43AB-4BF7-ADC2-4EBC20CF6B15" },
    ["1492670521039519744"] = { UserId = 916926,    HWID = "E8F3DD2C-2D58-4FB2-9964-9E660D41DED9" },
    ["1131441655854137394"] = { UserId = 10140735981,  HWID = "57942A17-D704-4174-BBEB-34AAAFEA687F" },
    ["1209567899795333191"] = { UserId = 10600909044,  HWID = "8CF0ECA1-DFB0-4DE4-A4A7-A0E89D4B4FDC" },
    ["1307119313160769659"] = { UserId = 10997091722,  HWID = "CFBEF7DE-17A0-425C-9F07-900A0DA3B871" },
    ["1324640960126124043"] = { UserId = 4535950738,   HWID = "03E835C4-22BB-4FE0-B0F8-8E981862F30B" },
    ["1434704993365135431"] = { UserId = 10508388877,  HWID = "19D688F5-9FCD-4144-BFCD-1929980D2756" },
    ["1469571320462446823"] = { UserId = 11052743011,  HWID = "07365089-C884-4A3B-A3A0-3810CE3592F9" },
    ["1491348967047561318"] = { UserId = 1758483,      HWID = "007CE530-4224-471C-AB90-87C9B57082F9" },
    ["1494825865106952282"] = { UserId = 10859012583,  HWID = "39f40981-64cf-4e52-aa61-085ea7f62ac6" },
    ["1503910491960115324"] = { UserId = 10790903453,  HWID = "5F98C617-D62D-49CA-8133-754EB24E6D40" },
    ["1487236846256918549"] = { UserId = 10722840308,  HWID = "13A739CF-94B0-4393-A211-00EDBB803E43" },
    ["1201627128442126518"] = { UserId = 9196788440,   HWID = "28A2CDCA-60C8-460B-9F39-F3BF3DBCBBF2" },
    ["1478866434921599149"] = { UserId = 9099067409,   HWID = "25A91C57-B7E9-45D6-A296-A22B36D211AA" },
    ["1516977095467597864"] = { UserId = 10412977778,  HWID = "EE8B130D-6FF9-493D-8A51-31D2A9A21F22" },
}

local BLACKLIST = {
     ["999999999999999999"] = { UserId = 123456789, HWID = "EXAMPLE-HWID-1" },
}

local function getHWID()
    local ok, id = pcall(function()
        return RbxAnalytics:GetClientId()
    end)
    if not ok or not id or id == "" then return nil end
    return id
end

local function isBlacklisted(discordId, userId, hwid)
    if discordId == OWNER_DISCORD then return false end

    local entry = BLACKLIST[discordId]
    if entry ~= nil then
        if type(entry) == "table" then
            local okUser = (not entry.UserId) or (entry.UserId == userId)
            local okHWID = (not entry.HWID) or (entry.HWID == hwid)
            if okUser and okHWID then return true end
        else
            return true
        end
    end

    if BLACKLIST["roblox:" .. tostring(userId)] then return true end
    if BLACKLIST["hwid:" .. tostring(hwid)] then return true end

    return false
end

-- Log script startup
SendLog(string.format(
    "[STARTUP] Script loaded\nUser: %s\nUserId: %d\nHWID: %s\nPlace: %s (%d)",
    LocalPlayer.Name,
    LocalPlayer.UserId,
    tostring(getHWID()),
    game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown",
    game.PlaceId
))

local WL_BG       = Color3.fromRGB(25, 25, 25)
local WL_BOX_BG   = Color3.fromRGB(40, 40, 40)
local WL_STROKE   = Color3.fromRGB(55, 55, 55)
local WL_TEXT     = Color3.fromRGB(220, 220, 220)
local WL_TEXT_DIM = Color3.fromRGB(150, 150, 150)
local WL_ACCENT   = Color3.fromRGB(120, 200, 160)
local WL_RED      = Color3.fromRGB(160, 55, 55)
local WL_GREEN    = Color3.fromRGB(40, 170, 95)

local function buildWhitelistGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "WhitelistGUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not ok then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local dim = Instance.new("Frame")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.new(0, 0, 0)
    dim.BackgroundTransparency = 0.4
    dim.BorderSizePixel = 0
    dim.Parent = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(320, 210)
    frame.Position = UDim2.new(0.5, -160, 0.5, -105)
    frame.BackgroundColor3 = WL_BG
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local fs = Instance.new("UIStroke", frame)
    fs.Color = WL_STROKE
    fs.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 24)
    title.Position = UDim2.new(0, 10, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "Whitelist"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansSemibold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -20, 0, 16)
    sub.Position = UDim2.new(0, 10, 0, 34)
    sub.BackgroundTransparency = 1
    sub.Text = "Enter your Discord ID to verify access"
    sub.TextColor3 = WL_TEXT_DIM
    sub.Font = Enum.Font.SourceSans
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = frame

    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.new(0, 10, 0, 58)
    div.BackgroundColor3 = WL_STROKE
    div.BorderSizePixel = 0
    div.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 32)
    box.Position = UDim2.new(0, 10, 0, 72)
    box.BackgroundColor3 = WL_BOX_BG
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = "Discord ID..."
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 13
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    local boxPad = Instance.new("UIPadding", box)
    boxPad.PaddingLeft = UDim.new(0, 8)

    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = Color3.fromRGB(58, 58, 58)
    boxStroke.Thickness = 1
    boxStroke.Transparency = 0.2

    box.Focused:Connect(function()
        boxStroke.Color = WL_ACCENT
        boxStroke.Transparency = 0
    end)
    box.FocusLost:Connect(function()
        boxStroke.Color = Color3.fromRGB(58, 58, 58)
        boxStroke.Transparency = 0.2
    end)

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 16)
    status.Position = UDim2.new(0, 10, 0, 110)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = WL_TEXT_DIM
    status.Font = Enum.Font.SourceSans
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame

    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(1, -20, 0, 34)
    submit.Position = UDim2.new(0, 10, 0, 132)
    submit.BackgroundColor3 = WL_GREEN
    submit.BorderSizePixel = 0
    submit.Text = "Verify"
    submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    submit.Font = Enum.Font.SourceSansSemibold
    submit.TextSize = 13
    submit.AutoButtonColor = false
    submit.Parent = frame
    Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 6)

    local foot = Instance.new("TextLabel")
    foot.Size = UDim2.new(1, -20, 0, 14)
    foot.Position = UDim2.new(0, 10, 1, -20)
    foot.BackgroundTransparency = 1
    foot.Text = "UserId + HWID must match your whitelist entry"
    foot.TextColor3 = WL_TEXT_DIM
    foot.Font = Enum.Font.SourceSans
    foot.TextSize = 10
    foot.TextXAlignment = Enum.TextXAlignment.Left
    foot.Parent = frame

    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    return {
        gui = gui,
        box = box,
        submit = submit,
        status = status,
        setStatus = function(text, color)
            status.Text = text
            status.TextColor3 = color or WL_TEXT_DIM
        end,
        close = function() gui:Destroy() end,
    }
end

local function runAuthFlow()
    local hwid = getHWID()
    if not hwid then
        SendLog("[ERROR] HWID read failed - executor may not support RbxAnalytics:GetClientId()")
        return false, "Could not read HWID from this executor."
    end

    local ui = buildWhitelistGUI()
    local result, reason = false, nil
    local submitted = false

    local function tryVerify()
        if submitted then return end
        local raw = ui.box.Text:gsub("%s+", "")
        if raw == "" then
            ui.setStatus("Enter your Discord ID first.", WL_RED)
            return
        end
        ui.setStatus("Checking...", WL_TEXT_DIM)
        submitted = true

        task.wait(0.05) 

        local userId = LocalPlayer.UserId
        local discordId = raw

        SendLog(string.format(
            "[AUTH ATTEMPT]\nUser: %s\nUserId: %d\nHWID: %s\nDiscord ID entered: %s",
            LocalPlayer.Name, userId, hwid, discordId
        ))

        if discordId == OWNER_DISCORD then
            result, reason = true, nil
            SendLog(string.format("[AUTH SUCCESS] Owner access granted\nUserId: %d\nDiscord: %s", userId, discordId))
        elseif isBlacklisted(discordId, userId, hwid) then
            result, reason = false, "You are blacklisted."
            SendLog(string.format("[AUTH DENIED] BLACKLISTED\nUser: %s\nUserId: %d\nHWID: %s\nDiscord: %s",
                LocalPlayer.Name, userId, hwid, discordId))
        else
            local entry = WHITELIST[discordId]
            if not entry then
                result, reason = false, "Discord ID not whitelisted."
                SendLog(string.format("[AUTH DENIED] Discord ID not in whitelist\nUser: %s\nUserId: %d\nHWID: %s\nDiscord: %s",
                    LocalPlayer.Name, userId, hwid, discordId))
            elseif entry.UserId ~= userId then
                result, reason = false, "UserId does not match this Discord ID."
                SendLog(string.format("[AUTH DENIED] UserId mismatch\nUser: %s\nExpected UserId: %d\nActual UserId: %d\nHWID: %s\nDiscord: %s",
                    LocalPlayer.Name, entry.UserId, userId, hwid, discordId))
            elseif entry.HWID ~= hwid then
                result, reason = false, "HWID does not match. Contact the owner."
                SendLog(string.format("[AUTH DENIED] HWID mismatch\nUser: %s\nUserId: %d\nExpected HWID: %s\nActual HWID: %s\nDiscord: %s",
                    LocalPlayer.Name, userId, entry.HWID, hwid, discordId))
            else
                result, reason = true, nil
                SendLog(string.format("[AUTH SUCCESS] Whitelist verified\nUser: %s\nUserId: %d\nHWID: %s\nDiscord: %s",
                    LocalPlayer.Name, userId, hwid, discordId))
            end
        end

        if result then
            ui.setStatus("Verified ✓", WL_GREEN)
            task.wait(0.6)
            ui.close()
        else
            ui.setStatus(reason, WL_RED)
            submitted = false
        end
    end

    ui.submit.MouseButton1Click:Connect(tryVerify)
    ui.box.FocusLost:Connect(function(enter) if enter then tryVerify() end end)

    while ui.gui.Parent and not result do
        task.wait(0.1)
    end

    return result, reason
end

local authorized, failReason = runAuthFlow()
if not authorized then
    SendLog(string.format("[SCRIPT EXIT] Access denied - script will not run\nUser: %s\nUserId: %d\nReason: %s",
        LocalPlayer.Name, LocalPlayer.UserId, tostring(failReason)))
    if failReason then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Access Denied",
                Text  = failReason,
                Duration = 6,
            })
        end)
    end
    return
end

SendLog(string.format("[SCRIPT RUNNING] Auth passed, features loading\nUser: %s\nUserId: %d",
    LocalPlayer.Name, LocalPlayer.UserId))

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP         = Character:WaitForChild("HumanoidRootPart")
local Humanoid    = Character:WaitForChild("Humanoid")

local Settings = {
    Enabled = true,
    HorizontalRadius = 1.5,
    MinHeightAbove   = 2.0,
    MaxHeightAbove   = 4.5,
    HeadOffsetY      = 3.2,
    Smoothness       = 12.0,
    BalanceRadius         = 6.0,
    ActivationHorizontal  = 1.6,
    ActivationVerticalMin = 3.8,
    ActivationVerticalMax = 5.5,
    HorizontalTolerance   = 2.8,
    VerticalRangeMin      = 0.2,
    VerticalRangeMax      = 95,
    PositionLerp          = 0.72,
    RotationLerp          = 0.17,
    MoveGracePeriod       = 0.4,
    FollowRadius = 20.5,
    StopDistance = 2.9,
    FollowSpeed  = 11.7,
}

task.spawn(function()
    local isLocked, currentTargetHead = false, nil

    local function findTargetHeadAbove()
        local closestHead, shortestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local hrpPos, headPos = HRP.Position, head.Position
                    local flat  = (Vector2.new(hrpPos.X, hrpPos.Z) - Vector2.new(headPos.X, headPos.Z)).Magnitude
                    local vDiff = hrpPos.Y - headPos.Y
                    if flat <= Settings.HorizontalRadius
                    and vDiff >= Settings.MinHeightAbove
                    and vDiff <= Settings.MaxHeightAbove then
                        if flat < shortestDist then
                            shortestDist, closestHead = flat, head
                        end
                    end
                end
            end
        end
        return closestHead
    end

    RunService.Heartbeat:Connect(function(dt)
        if not Settings.Enabled then isLocked = false; currentTargetHead = nil; return end
        if not HRP or not HRP.Parent then return end
        if Humanoid.MoveDirection.Magnitude > 0 then isLocked = false; currentTargetHead = nil; return end

        local state = Humanoid:GetState()
        local valid = (state == Enum.HumanoidStateType.Freefall
                    or state == Enum.HumanoidStateType.Running
                    or state == Enum.HumanoidStateType.Landed)

        if not isLocked then
            if valid then
                local head = findTargetHeadAbove()
                if head then isLocked = true; currentTargetHead = head end
            end
        else
            if not currentTargetHead or not currentTargetHead:IsDescendantOf(workspace) then
                isLocked = false; currentTargetHead = nil; return
            end
            if HRP.Position.Y < (currentTargetHead.Position.Y + 0.5) then
                isLocked = false; currentTargetHead = nil; return
            end
        end

        if isLocked and currentTargetHead then
            local headOffset = Vector3.new(0, Settings.HeadOffsetY, 0)
            local targetPos  = currentTargetHead.Position + headOffset
            local alpha      = 1 - math.exp(-Settings.Smoothness * dt)
            local newPos     = HRP.Position:Lerp(targetPos, alpha)
            HRP.CFrame       = CFrame.new(newPos, newPos + HRP.CFrame.LookVector)
        end
    end)
end)

task.spawn(function()
    local lastMoveTime = 0
    local currentStickTarget, isSticking = nil, false
    local currentTargetYaw, lastTargetYaw = 0, 0

    local function isPlayerMoving()
        if Humanoid.MoveDirection.Magnitude > 0.08 then lastMoveTime = tick(); return true end
        if tick() - lastMoveTime < Settings.MoveGracePeriod then return true end
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.A)
        or UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.D) then
            lastMoveTime = tick(); return true
        end
        return false
    end

    local function isDiving() return UserInputService:IsKeyDown(Enum.KeyCode.ButtonX) end

    local function getStickTarget()
        if currentStickTarget and currentStickTarget.Character then
            local head = currentStickTarget.Character:FindFirstChild("Head")
            if head and (head.Position - HRP.Position).Magnitude < Settings.BalanceRadius * 1.6 then
                return head
            end
        end
        local closestHead, shortestDistance, closestPlayer = nil, math.huge, nil
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local distance = (head.Position - HRP.Position).Magnitude
                    if distance < Settings.BalanceRadius and distance < shortestDistance then
                        shortestDistance, closestHead, closestPlayer = distance, head, player
                    end
                end
            end
        end
        if closestHead then currentStickTarget = closestPlayer end
        return closestHead
    end

    RunService.Heartbeat:Connect(function()
        if not Settings.Enabled then isSticking = false; currentStickTarget = nil; return end
        if not HRP or not HRP.Parent then return end

        local head = getStickTarget()
        if not head then isSticking = false; currentStickTarget = nil; return end

        local vDiff = HRP.Position.Y - head.Position.Y
        local hDist = Vector2.new(HRP.Position.X - head.Position.X, HRP.Position.Z - head.Position.Z).Magnitude

        if not isSticking then
            if hDist > Settings.ActivationHorizontal
            or vDiff < Settings.ActivationVerticalMin
            or vDiff > Settings.ActivationVerticalMax then return end
            isSticking = true
            currentTargetYaw = select(2, HRP.CFrame:ToEulerAnglesYXZ())
            lastTargetYaw    = select(2, head.CFrame:ToEulerAnglesYXZ())
        end

        if hDist > Settings.HorizontalTolerance
        or vDiff < Settings.VerticalRangeMin
        or vDiff > Settings.VerticalRangeMax
        or math.abs(HRP.Velocity.Y) > 25
        or isDiving() or isPlayerMoving() then
            isSticking = false; return
        end

        local targetPos = Vector3.new(
            head.Position.X + (math.random() - 0.5) * 0.1,
            head.Position.Y + 4.35,
            head.Position.Z + (math.random() - 0.5) * 0.1
        )
        local newPos = HRP.Position:Lerp(targetPos, Settings.PositionLerp)

        local targetHRP    = head.Parent:FindFirstChild("HumanoidRootPart")
        local targetCFrame = targetHRP and targetHRP.CFrame or head.CFrame
        local _, targetYaw = targetCFrame:ToEulerAnglesYXZ()
        local yawDiff = (targetYaw - lastTargetYaw + math.pi) % (math.pi * 2) - math.pi
        if math.abs(yawDiff) > 0.012 then
            currentTargetYaw = currentTargetYaw + yawDiff * Settings.RotationLerp
        end
        lastTargetYaw = targetYaw
        HRP.CFrame = CFrame.fromEulerAnglesYXZ(0, currentTargetYaw, 0) + newPos
    end)

    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        HRP       = newChar:WaitForChild("HumanoidRootPart")
        Humanoid  = newChar:WaitForChild("Humanoid")
        isSticking = false
        currentStickTarget = nil
    end)
end)

task.spawn(function()
    local parent = script.Parent
    local NPC
    if parent then
        for _, obj in ipairs(parent:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                NPC = obj; break
            end
        end
    end
    local NPCRoot = NPC and NPC:FindFirstChild("HumanoidRootPart") or nil
    if not NPCRoot then return end

    local function getClosestPlayer()
        local bestChar, bestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local d = (root.Position - NPCRoot.Position).Magnitude
                if d < Settings.FollowRadius and d < bestDist then
                    bestDist, bestChar = d, char
                end
            end
        end
        return bestChar
    end

    RunService.Heartbeat:Connect(function(dt)
        if not Settings.Enabled then return end
        if not NPCRoot.Parent then return end
        local targetChar = getClosestPlayer()
        if not targetChar then return end
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        if (targetRoot.Position - NPCRoot.Position).Magnitude <= Settings.StopDistance then return end
        local targetPos = targetRoot.Position - targetRoot.CFrame.LookVector * Settings.StopDistance
        local targetCF  = CFrame.lookAt(targetPos, targetRoot.Position)
        local alpha     = 1 - math.exp(-Settings.FollowSpeed * dt)
        NPCRoot.CFrame  = NPCRoot.CFrame:Lerp(targetCF, alpha)
    end)
end)

local WIDTH    = 200
local HEIGHT   = 340
local PAD      = 10
local ROW_H    = 22
local ROW_GAP  = 3
local SEC_H    = 18
local HEADER_H = 44
local FOOTER_H = 16

local BG       = Color3.fromRGB(25, 25, 25)
local ROW_BG   = Color3.fromRGB(32, 32, 32)
local BOX_BG   = Color3.fromRGB(40, 40, 40)
local STROKE   = Color3.fromRGB(55, 55, 55)
local TEXT     = Color3.fromRGB(220, 220, 220)
local TEXT_DIM = Color3.fromRGB(150, 150, 150)
local ACCENT   = Color3.fromRGB(120, 200, 160)

local ui = Instance.new("ScreenGui")
ui.Name           = "StickyHeadGUI"
ui.ResetOnSpawn   = false
ui.IgnoreGuiInset = false
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ui.Parent         = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size             = UDim2.fromOffset(WIDTH, HEIGHT)
MainFrame.Position         = UDim2.new(0.05, 0, 0.35, 0)
MainFrame.BackgroundColor3 = BG
MainFrame.BorderSizePixel  = 0
MainFrame.Active           = true
MainFrame.Parent           = ui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 9)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color     = STROKE
mainStroke.Thickness = 1

local Title = Instance.new("TextLabel")
Title.Size                   = UDim2.new(1, 0, 0, 20)
Title.Position               = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text                   = "Auto Head"
Title.TextColor3             = Color3.fromRGB(255, 255, 255)
Title.Font                   = Enum.Font.SourceSansSemibold
Title.TextSize               = 15
Title.Parent                 = MainFrame

local Sub = Instance.new("TextLabel")
Sub.Size                   = UDim2.new(1, 0, 0, 14)
Sub.Position               = UDim2.new(0, 0, 0, 24)
Sub.BackgroundTransparency = 1
Sub.Text                   = "Head Lock"
Sub.TextColor3             = TEXT_DIM
Sub.Font                   = Enum.Font.SourceSans
Sub.TextSize               = 11
Sub.Parent                 = MainFrame

local Divider = Instance.new("Frame")
Divider.Size             = UDim2.new(1, -20, 0, 1)
Divider.Position         = UDim2.new(0, 10, 0, HEADER_H - 6)
Divider.BackgroundColor3 = STROKE
Divider.BorderSizePixel  = 0
Divider.Parent           = MainFrame

local Content = Instance.new("ScrollingFrame")
Content.Size                   = UDim2.new(1, -PAD * 2, 1, -(HEADER_H + FOOTER_H + PAD))
Content.Position               = UDim2.new(0, PAD, 0, HEADER_H)
Content.BackgroundTransparency = 1
Content.BorderSizePixel        = 0
Content.ScrollBarThickness     = 3
Content.ScrollBarImageColor3   = Color3.fromRGB(90, 90, 90)
Content.ScrollBarImageTransparency = 0.3
Content.CanvasSize             = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize    = Enum.AutomaticSize.Y
Content.Parent                 = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding             = UDim.new(0, ROW_GAP)
Layout.SortOrder           = Enum.SortOrder.LayoutOrder
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent              = Content

local function CreateSection(name, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, -2, 0, SEC_H)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = name
    lbl.TextColor3             = ACCENT
    lbl.Font                   = Enum.Font.SourceSansSemibold
    lbl.TextSize               = 11
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.LayoutOrder            = order
    lbl.Parent                 = Content
end

local function CreateInput(name, default, order, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, ROW_H)
    row.BackgroundColor3 = ROW_BG
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order
    row.Parent           = Content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

    local stroke = Instance.new("UIStroke", row)
    stroke.Color        = STROKE
    stroke.Thickness    = 1
    stroke.Transparency = 0.4

    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, -92, 1, 0)
    lbl.Position               = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = name
    lbl.TextColor3             = TEXT
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.Font                   = Enum.Font.SourceSans
    lbl.TextSize               = 11
    lbl.Parent                 = row

    local box = Instance.new("TextBox")
    box.Size             = UDim2.new(0, 72, 0, 16)
    box.Position         = UDim2.new(1, -80, 0.5, -8)
    box.BackgroundColor3 = BOX_BG
    box.BorderSizePixel  = 0
    box.Text             = tostring(default)
    box.TextColor3       = Color3.fromRGB(255, 255, 255)
    box.Font             = Enum.Font.SourceSans
    box.TextSize         = 11
    box.TextXAlignment   = Enum.TextXAlignment.Center
    box.ClearTextOnFocus = false
    box.Parent           = row
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color        = Color3.fromRGB(58, 58, 58)
    boxStroke.Thickness    = 1
    boxStroke.Transparency = 0.2

    box.Focused:Connect(function()
        boxStroke.Color        = ACCENT
        boxStroke.Transparency = 0
    end)
    box.FocusLost:Connect(function()
        boxStroke.Color        = Color3.fromRGB(58, 58, 58)
        boxStroke.Transparency = 0.2
        local num = tonumber(box.Text)
        if num then callback(num)
        else box.Text = tostring(default); callback(default) end
    end)
end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size             = UDim2.new(1, 0, 0, ROW_H + 2)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 95)
ToggleBtn.Text             = "Enabled"
ToggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font             = Enum.Font.SourceSansSemibold
ToggleBtn.TextSize         = 11
ToggleBtn.LayoutOrder      = 0
ToggleBtn.AutoButtonColor  = false
ToggleBtn.Parent           = Content
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 5)

ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    if Settings.Enabled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 95)
        ToggleBtn.Text             = "Enabled"
        SendLog(string.format("[FEATURE] Features ENABLED by user: %s", LocalPlayer.Name))
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(160, 55, 55)
        ToggleBtn.Text             = "Disabled"
        SendLog(string.format("[FEATURE] Features DISABLED by user: %s", LocalPlayer.Name))
    end
end)

CreateSection("Head Lock", 2)
CreateInput("Horizontal Radius", Settings.HorizontalRadius, 3, function(v) Settings.HorizontalRadius = v end)
CreateInput("Min Height",        Settings.MinHeightAbove,   4, function(v) Settings.MinHeightAbove   = v end)
CreateInput("Max Height",        Settings.MaxHeightAbove,   5, function(v) Settings.MaxHeightAbove   = v end)
CreateInput("Head Offset",       Settings.HeadOffsetY,      6, function(v) Settings.HeadOffsetY      = v end)
CreateInput("Smoothness",        Settings.Smoothness,       7, function(v) Settings.Smoothness       = v end)

CreateSection("Shoulder Stick", 8)
CreateInput("Balance Radius",   Settings.BalanceRadius,         9,  function(v) Settings.BalanceRadius         = v end)
CreateInput("Activation H",     Settings.ActivationHorizontal,  10, function(v) Settings.ActivationHorizontal  = v end)
CreateInput("Activation V Min", Settings.ActivationVerticalMin, 11, function(v) Settings.ActivationVerticalMin = v end)
CreateInput("Activation V Max", Settings.ActivationVerticalMax, 12, function(v) Settings.ActivationVerticalMax = v end)
CreateInput("H Tolerance",      Settings.HorizontalTolerance,   13, function(v) Settings.HorizontalTolerance   = v end)
CreateInput("V Range Min",      Settings.VerticalRangeMin,      14, function(v) Settings.VerticalRangeMin      = v end)
CreateInput("V Range Max",      Settings.VerticalRangeMax,      15, function(v) Settings.VerticalRangeMax      = v end)
CreateInput("Position Lerp",    Settings.PositionLerp,          16, function(v) Settings.PositionLerp          = v end)
CreateInput("Rotation Lerp",    Settings.RotationLerp,          17, function(v) Settings.RotationLerp          = v end)
CreateInput("Grace Period",     Settings.MoveGracePeriod,       18, function(v) Settings.MoveGracePeriod       = v end)

CreateSection("NPC Follow", 19)
CreateInput("Follow Radius", Settings.FollowRadius, 20, function(v) Settings.FollowRadius = v end)
CreateInput("Stop Distance", Settings.StopDistance, 21, function(v) Settings.StopDistance = v end)
CreateInput("Follow Speed",  Settings.FollowSpeed,  22, function(v) Settings.FollowSpeed  = v end)

local Footer = Instance.new("TextLabel")
Footer.Size                   = UDim2.new(1, -PAD * 2, 0, FOOTER_H)
Footer.Position               = UDim2.new(0, PAD, 1, -FOOTER_H)
Footer.BackgroundTransparency = 1
Footer.Text                   = "D-Pad Left to hide"
Footer.TextColor3             = TEXT_DIM
Footer.Font                   = Enum.Font.SourceSans
Footer.TextSize               = 10
Footer.Parent                 = MainFrame

local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.DPadLeft then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
