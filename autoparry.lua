local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local typeof = typeof
local os = os
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Balls = workspace:WaitForChild("Balls")

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
    
    local OldPosition = Ball.Position
    local OldClock = os.clock()
    
    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then
            local PlayerPos = Player.Character.HumanoidRootPart.Position
            local Distance = (Ball.Position - PlayerPos).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude
            if (Distance / Velocity) <= 32 then
                Parry()
            end
        end
        
        if (os.clock() - OldClock >= 1/160) then
            OldClock = os.clock()
            OldPosition = Ball.Position
        end
    end)
end)

warn("I'm here mommy.")
