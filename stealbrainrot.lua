-- Steal a Brainrot – Full Utility Script (Cleaned)
-- Bypass Anti‑Kick
local str = game:HttpGet("https://rawscripts.net/raw/Steal-a-Brainrot-Anti-Kick-Bypass-41960")
loadstring(str)()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Replicated = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localplr = Players.LocalPlayer

getgenv().deletewhendupefound = true
local on = true

-- Load GUI Library
local lib = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Lib-18698"))()
lib.makelib("Steal a Brainrot (2AreYouMental110, Too overpowered?)")

-- Internal state
local tableofconnections = {}
local posgoto, gotoplace = nil, nil
local sbase, ipp, jp, tptb = false, false, false, false
local pbt, antiragdoll = false, false
local pp, donetools = {}, {}
local gotobase = nil
local loopclick = false
local lastcfr = nil

-- Selection box for base
local sbox = Instance.new("SelectionBox")
sbox.Parent = game:GetService("CoreGui")
sbox.Transparency = 1

-- Main UI
local main = lib.maketab("Main")
lib.makelabel("VERY good anticheat! Click base then goto base below.", main)
lib.makelabel("Turn on Auto Steal *before* stealing their pets", main)

lib.maketoggle("Auto Steal", main, function(v) autosteal = v end)
lib.maketoggle("Spam Tools", main, function(v) pbt = v end)
lib.maketoggle("Anti Ragdoll/Freeze", main, function(v) antiragdoll = v end)
lib.maketoggle("Select Base", main, function(v)
    sbase = v
    sbox.Transparency = sbase and 0 or 1
end)

lib.makebutton("Goto Base (WILL OOF YOU)", main, function()
    if gotobase and not lib.busy then
        lib.busy = true
        pcall(function()
            gotoplace = gotobase.AnimalPodiums["1"]:GetPivot() + Vector3.new(0, 3.5, 0)
            localplr.Character.Humanoid.Health = -1
            task.wait(3.5)
            gotoplace = nil
        end)
        lib.busy = false
    end
end)

lib.makebutton("Goto Base (Second Floor, WILL OOF YOU)", main, function()
    if gotobase and not lib.busy then
        lib.busy = true
        pcall(function()
            gotoplace = gotobase.AnimalPodiums["11"]:GetPivot() + Vector3.new(0, 3.5, 0)
            localplr.Character.Humanoid.Health = -1
            task.wait(3.5)
            gotoplace = nil
        end)
        lib.busy = false
    end
end)

lib.makelabel("", main)

-- Proximity Prompts helper
local function dop(p)
    if p.Base.Spawn.PromptAttachment:FindFirstChild("ProximityPrompt") then
        table.insert(pp, p.Base.Spawn.PromptAttachment.ProximityPrompt)
        if ipp then p.Base.Spawn.PromptAttachment.ProximityPrompt.HoldDuration = 0 end
    end

    table.insert(tableofconnections, p.Base.Spawn.PromptAttachment.ChildAdded:Connect(function(c)
        if c:IsA("ProximityPrompt") then
            table.insert(pp, c)
            if ipp then c.HoldDuration = 0 end
        end
    end))
end

for _, v in pairs(Workspace.Plots:GetChildren()) do
    if v:FindFirstChild("AnimalPodiums") then
        for _, pod in pairs(v.AnimalPodiums:GetChildren()) do
            dop(pod)
        end
        table.insert(tableofconnections, v.AnimalPodiums.ChildAdded:Connect(dop))
    end
end

lib.maketoggle("Instant Proximity Prompts", main, function(v)
    ipp = v
    if ipp then for _, pr in pairs(pp) do pr.HoldDuration = 0 end end
end)

lib.makelabel("", main)

lib.maketoggle("Gravity (better)", main, function(v)
    jp = v
    local hum = localplr.Character and localplr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        if not jp then
            Workspace.Gravity = 196.2
            hum.JumpPower = 50
        end
    end
end)

-- Noclip Camera toggle
lib.makebutton("Noclip Camera (via Infinite Yield)", main, function()
    local sc = (debug and debug.setconstant) or setconstant
    local gc = (debug and debug.getconstants) or getconstants
    local pop = localplr.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper

    if not sc or not gc then
        return print("Incompatible Exploit")
    end

    for _, fn in pairs(getgc()) do
        if type(fn) == "function" and getfenv(fn).script == pop then
            for _, c in pairs(gc(fn)) do
                if tonumber(c) == 0.25 then sc(fn, _, 0)
                elseif tonumber(c) == 0 then sc(fn, _, 0.25)
                end
            end
        end
    end
end)

-- Mouse loop-click setup
local mouse = localplr:GetMouse()
local loopclickpart = Instance.new("Part")
loopclickpart.Anchored = true
loopclickpart.CanCollide = false
loopclickpart.Color = Color3.fromRGB(0, 255, 0)
loopclickpart.Shape = Enum.PartType.Ball
loopclickpart.Size = Vector3.new(2, 2, 2)
loopclickpart.Transparency = 1
loopclickpart.Material = Enum.Material.SmoothPlastic
loopclickpart.Parent = Workspace

lib.maketoggle("Select Click Position", main, function(v)
    loopclick = v
end)

table.insert(tableofconnections, mouse.Button1Down:Connect(function()
    if loopclick then
        local hit = (mouse.hit.Position + Vector3.new(0, localplr.Character.HumanoidRootPart.Size.Y * 1.5, 0))
        loopclickpart.CFrame = CFrame.new(hit)
        loopclickpart.Transparency = 0
        posgoto = CFrame.new(hit)
    elseif sbase and mouse.Target then
        gotobase = nil
        for _, v in pairs(Workspace.Plots:GetChildren()) do
            if mouse.Target:IsDescendantOf(v) then gotobase = v end
        end
        if gotobase then sbox.Adornee = gotobase end
    end
end))

-- Loop-to click position
table.insert(tableofconnections, lib.makebutton("Loop goto click position", main, function(v)
    if posgoto and v then
        loopclick = false
        loopclickpart.Transparency = 1
        lib.updatelabel(tostring("Approach time: " .. math.floor((localplr.Character:GetPivot().Position - posgoto.Position).Magnitude / 12)) .. "s", precentagetext)
        coroutine.wrap(function()
            while v do
                task.wait()
                localplr.Character.HumanoidRootPart.CFrame = posgoto
            end
        end)()
    end
end))

local precentagetext = lib.makelabel("??? Seconds Left", main)

lib.maketextbox("Proximity Prompt Range", main, function(txt)
    for _, v in pairs(Workspace.Plots:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.MaxActivationDistance = tonumber(txt) or v.MaxActivationDistance
        end
    end
end)

lib.makeslider("HipHeight (not effective)", main, 1, 100, function(n)
    local hum = localplr.Character and localplr.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.HipHeight = n end
end)

lib.maketoggle("Show Hitboxes", main, function(v)
    for _, plot in pairs(Workspace.Plots:GetChildren()) do
        if plot:FindFirstChild("InvisibleWalls") then
            for _, wall in pairs(plot.InvisibleWalls:GetChildren()) do
                if wall:FindFirstChild("Mesh") then
                    wall.Mesh:Destroy()
                end
                wall.Transparency = v and 0.5 or 1
            end
        end
        if plot:FindFirstChild("LaserHitbox") then
            for _, laser in pairs(plot.LaserHitbox:GetChildren()) do
                if laser:FindFirstChild("Mesh") then laser.Mesh:Destroy() end
                laser.Transparency = v and 0.5 or 1
            end
        end
    end
end)

lib.maketoggle("Noclip Hitboxes", main, function(v)
    for _, plot in pairs(Workspace.Plots:GetChildren()) do
        if plot:FindFirstChild("InvisibleWalls") then
            for _, wall in pairs(plot.InvisibleWalls:GetChildren()) do
                wall.CanCollide = not v
            end
        end
        if plot:FindFirstChild("LaserHitbox") then
            for _, laser in pairs(plot.LaserHitbox:GetChildren()) do
                laser.CanCollide = not v
            end
        end
    end
end)

lib.makebutton("Tween To Base (not effective)", main, function()
    local base = nil
    for _, v in pairs(Workspace.Plots:GetChildren()) do
        if v:FindFirstChild("YourBase", true) and v:FindFirstChild("YourBase", true).Enabled then
            base = v.DeliveryHitbox
        end
    end
    if base then
        local pos = localplr.Character.HumanoidRootPart.Position
        local target = Vector3.new(base.Position.X, pos.Y, base.Position.Z)
        local tween = game:GetService("TweenService"):Create(
            localplr.Character.HumanoidRootPart,
            TweenInfo.new((target - pos).Magnitude / localplr.Character.Humanoid.WalkSpeed, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(target)}
        )
        tween:Play()
    end
end)

lib.maketoggle("TP To Base", main, function(v)
    tptb = v
end)

lib.maketoggle("Anti Teleport", main, function(v)
    lib.antitp = v
end)

-- Tool / descendant handling
local function dotool(tool)
    if tool:IsA("Tool") and not donetools[tool] then
        donetools[tool] = true
        coroutine.wrap(function()
            while on do task.wait()
                if pbt and (tool.Parent == localplr.Character or tool.Parent == localplr.Backpack) then
                    tool.Parent = localplr.Character
                    tool:Activate()
                end
            end
        end)()
    elseif tool:IsA("BasePart") then
        table.insert(tableofconnections, tool:GetPropertyChangedSignal("Anchored"):Connect(function()
            if tool.Anchored and antiragdoll then tool.Anchored = false end
        end))
        table.insert(tableofconnections, tool.ChildAdded:Connect(function(c)
            if (c:IsA("BallSocketConstraint") or c.Name == "Attachment" or v:IsA("HingeConstraint")) then
                c:Destroy()
                -- restore neck and collisions if needed
                local parent = tool.Parent
                if parent and parent:FindFirstChild("Head") then
                    parent.Head.Neck.Enabled = true
                end
                if parent and parent:FindFirstChild("HumanoidRootPart") then
                    parent.HumanoidRootPart.CanCollide = true
                end
                for _, v2 in ipairs(tool:GetChildren()) do
                    if v2:IsA("Motor6D") and v2.Name ~= "Attachment" then
                        v2.Enabled = true
                    end
                end
                for i=1,10 do task.wait() tool.Velocity = Vector3.new(0,0,0) end
            end
        end))
    elseif tool:IsA("Humanoid") then
        table.insert(tableofconnections, tool.StateChanged:Connect(function(state)
            if antiragdoll and (state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll) then
                tool:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end))
    end
end

local function onCharacter(c)
    for _, v in ipairs(c:GetDescendants()) do dotool(v) end
    c.DescendantAdded:Connect(dotool)
end

table.insert(tableofconnections, localplr.CharacterAdded:Connect(onCharacter))
if localplr.Character then onCharacter(localplr.Character) end

-- Render loop for teleport, antitp, jp
RunService.RenderStepped:Connect(function()
    local hrp = localplr.Character and localplr.Character:FindFirstChild("HumanoidRootPart")
    if tptb and gotoplace and hrp then
        hrp.CFrame = gotoplace
    end
    if lib.antitp and hrp and lastcfr then
        local dist = (hrp.CFrame.Position - lastcfr.Position).Magnitude
        if dist > 1 then hrp.CFrame = lastcfr end
    end
    if jp then Workspace.Gravity = 50 end
    if hrp then lastcfr = hrp.CFrame end
end)

-- Cleanup on destroy
lib.ondestroyedfunc = function()
    for _, conn in ipairs(tableofconnections) do conn:Disconnect() end
    if loopclickpart then loopclickpart:Destroy() end
    if sbox then sbox:Destroy() end
    on = false; pbt = false; antiragdoll = false; tptb = false
end
