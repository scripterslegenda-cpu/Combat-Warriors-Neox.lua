-- Niks CW Safe Edition: Hand Obfuscated
local _S = string.char
local _G_ = game
local _GS = _G_.GetService

local _P = _GS(_G_, _S(80,108,97,121,101,114,115)) -- Players
local _LP = _P.LocalPlayer
local _RS = _GS(_G_, _S(82,117,110,83,101,114,118,105,99,101)) -- RunService
local _VIM = _GS(_G_, _S(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114)) -- VirtualInputManager

local _K = {
    [_S(70)] = Enum.KeyCode.F, -- "F"
    [_S(65,99,116,105,111,110)] = Enum.AnimationPriority.Action, -- "Action"
    [_S(65,99,116,105,111,110,50)] = Enum.AnimationPriority.Action2 -- "Action2"
}

local _D = {
    [_S(66,68)] = 11, -- BaseDistance
    [_S(67,80)] = 85, -- ChanceToParry
}

local function _X1()
    local _wait = math.random(12, 22) / 100
    task.wait(_wait)
    _VIM:SendKeyEvent(true, _K[_S(70)], false, _G_)
    task.wait(math.random(2, 5) / 100)
    _VIM:SendKeyEvent(false, _K[_S(70)], false, _G_)
end

_RS.Stepped:Connect(function()
    local _c = _LP.Character
    if not _c or not _c:FindFirstChild(_S(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116)) then return end
    
    local _h = _c:FindFirstChildOfClass(_S(72,117,109,97,110,111,105,100))
    if _h and (_h.FloorMaterial == Enum.Material.Air or _h:GetState() == Enum.HumanoidStateType.Ragdoll) then 
        return 
    end

    for _, _e in pairs(_P:GetPlayers()) do
        if _e ~= _LP and _e.Character and _e.Character:FindFirstChild(_S(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116)) then
            local _ec = _e.Character
            local _er = _ec.HumanoidRootPart
            local _mr = _c.HumanoidRootPart
            
            local _dist = (_mr.Position - _er.Position).Magnitude
            local _dd = _D[_S(66,68)] + (math.random(-10, 10) / 10)
            
            if _dist <= _dd then
                if math.random(1, 100) > _D[_S(67,80)] then return end

                local _a = _ec:FindFirstChildOfClass(_S(72,117,109,97,110,111,105,100)):FindFirstChildOfClass(_S(101,110,105,109,97,116,111,114)) or _ec:FindFirstChildOfClass(_S(72,117,109,97,110,111,105,100)):FindFirstChildOfClass(_S(65,110,105,109,97,116,111,114))
                if _a then
                    for _, _t in pairs(_a:GetPlayingAnimationTracks()) do
                        if _t.Priority == _K[_S(65,99,116,105,111,110)] or _t.Priority == _K[_S(65,99,116,105,111,110,50)] then
                            if _t.Speed > 0.5 and _t.TimePosition < 0.15 then
                                local _dot = (_mr.Position - _er.Position).Unit:Dot(_er.CFrame.LookVector)
                                if _dot > 0.45 then
                                    _X1()
                                    task.wait(0.6 + (math.random(1, 5)/10))
                                    return 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)
