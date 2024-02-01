local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local Balls = workspace:WaitForChild("Balls", 9e9)
local typeof = typeof
local os = os
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

--Bypass
loadstring(game:HttpGet("https://raw.githubusercontent.com/OWLXS/partytime/main/bypass.lua"))()
warn("Security was destroyed...")

local function VerifyBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true
end

local function IsTarget()
    return (Player.Character and Player.Character:FindFirstChild("Highlight"))
end

local function Parry()
    Remotes:WaitForChild("ParryButtonPress"):Fire()
end

Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then
        return
    end
    
    local minDistance = 15
    local parryWindow = 0.7

    local OldPosition = Ball.Position
    local OldClock = os.clock()

    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then
            local PlayerPos = Player.Character.HumanoidRootPart.Position
            local Distance = (Ball.Position - PlayerPos).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude
            
            local timeToCollision = Distance / Velocity
            if timeToCollision <= minDistance and (os.clock() - OldClock) <= parryWindow then
                Parry()
            end
        end
        OldClock = os.clock()
        OldPosition = Ball.Position
    end)
end)

print("I'm here mommy.")
