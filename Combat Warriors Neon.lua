-- Niks Hub V3.1: Combat Warriors (Final Fixed & Obfuscated)
local _S = string.char
local _G_ = game
local _GS = _G_.GetService

local _P = _GS(_G_, _S(80,108,97,121,101,114,115))
local _LP = _P.LocalPlayer
local _RS = _GS(_G_, _S(82,117,110,83,101,114,118,105,99,101))
local _VIM = _GS(_G_, _S(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114))

local _K = {
    F = Enum.KeyCode.F,
    A1 = Enum.AnimationPriority.Action,
    A2 = Enum.AnimationPriority.Action2
}

local _X1 = function(_pos)
    local _wait = math.random(7, 11) / 100 
    if _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
        local _root = _LP.Character.HumanoidRootPart
        _root.CFrame = CFrame.new(_root.Position, Vector3.new(_pos.X, _root.Position.Y, _pos.Z))
    end
    task.wait(_wait)
    _VIM:SendKeyEvent(true, _K.F, false, _G_)
    task.wait(0.01)
    _VIM:SendKeyEvent(false, _K.F, false, _G_)
end

_RS.Stepped:Connect(function()
    local _c = _LP.Character
    if not _c or not _c:FindFirstChild("HumanoidRootPart") then return end
    
    for _, _e in pairs(_P:GetPlayers()) do
        if _e ~= _LP and _e.Character and _e.Character:FindFirstChild("HumanoidRootPart") then
            local _ec = _e.Character
            local _er = _ec.HumanoidRootPart
            local _mr = _c.HumanoidRootPart
            local _dist = (_mr.Position - _er.Position).Magnitude
            
            if _dist <= 12 then
                -- Безопасная проверка аниматора
                local _h = _ec:FindFirstChildOfClass("Humanoid")
                local _anim = _h and _h:FindFirstChildOfClass("Animator")
                
                if _anim then
                    for _, _t in pairs(_anim:GetPlayingAnimationTracks()) do
                        if _t.Priority == _K.A1 or _t.Priority == _K.A2 then
                            if _t.Speed > 0.4 and _t.TimePosition < 0.17 then
                                local _dot = (_mr.Position - _er.Position).Unit:Dot(_er.CFrame.LookVector)
                                if _dot > 0.3 then
                                    _X1(_er.Position)
                                    task.wait(_dist < 6 and 0.22 or 0.4)
                                    return 
                                end
                            end
                        end
                    end
                end
                
                -- Безопасная проверка звука (исправление ошибки из твоей консоли)
                local _head = _ec:FindFirstChild("Head")
                if _head then
                    for _, _s in pairs(_head:GetChildren()) do
                        if _s:IsA("Sound") and _s.Playing and (_s.Name:lower():find("swing") or _s.Name:lower():find("slash")) then
                            _X1(_er.Position)
                            task.wait(0.4)
                            return
                        end
                    end
                end
            end
        end
    end
end)
