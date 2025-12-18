-- Niks Hub V3: Combat Warriors Ultra Edition (Safe + AutoLook)
local _S = string.char
local _G_ = game
local _GS = _G_.GetService

local _P = _GS(_G_, _S(80,108,97,121,101,114,115)) -- Players
local _LP = _P.LocalPlayer
local _RS = _GS(_G_, _S(82,117,110,83,101,114,118,105,99,101)) -- RunService
local _VIM = _GS(_G_, _S(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114)) -- VirtualInputManager
local _W = workspace
local _C = _W.CurrentCamera

local _K = {
    [_S(70)] = Enum.KeyCode.F,
    [_S(65,99,116,105,111,110)] = Enum.AnimationPriority.Action,
    [_S(65,99,116,105,111,110,50)] = Enum.AnimationPriority.Action2
}

local _SET = {
    DIST = 12, -- Дистанция
    CHANCE = 95, -- Повысил шанс до 95% для лучшей защиты
    LOOK = true -- Включил авто-поворот
}

-- Функция поворота к цели
local function _FACE(_targetPos)
    if _SET.LOOK and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
        local _root = _LP.Character.HumanoidRootPart
        local _newPos = Vector3.new(_targetPos.X, _root.Position.Y, _targetPos.Z)
        _root.CFrame = CFrame.new(_root.Position, _newPos)
    end
end

-- Функция парирования
local function _X1(_pos)
    -- Быстрая реакция для ближнего боя
    local _wait = math.random(7, 12) / 100 
    _FACE(_pos) -- Поворачиваемся перед блоком
    task.wait(_wait)
    
    _VIM:SendKeyEvent(true, _K[_S(70)], false, _G_)
    task.wait(0.01)
    _VIM:SendKeyEvent(false, _K[_S(70)], false, _G_)
end

_RS.Stepped:Connect(function()
    local _char = _LP.Character
    if not _char or not _char:FindFirstChild(_S(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116)) then return end
    
    local _hum = _char:FindFirstChildOfClass(_S(72,117,109,97,110,111,105,100))
    if _hum and _hum:GetState() == Enum.HumanoidStateType.Dead then return end

    for _, _e in pairs(_P:GetPlayers()) do
        if _e ~= _LP and _e.Character and _e.Character:FindFirstChild(_S(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116)) then
            local _ec = _e.Character
            local _er = _ec.HumanoidRootPart
            local _mr = _char.HumanoidRootPart
            
            local _dist = (_mr.Position - _er.Position).Magnitude
            
            if _dist <= _SET.DIST then
                if math.random(1, 100) > _SET.CHANCE then return end

                local _anim = _ec:FindFirstChildOfClass(_S(72,117,109,97,110,111,105,100)):FindFirstChildOfClass(_S(65,110,105,109,97,116,111,114))
                if _anim then
                    for _, _t in pairs(_anim:GetPlayingAnimationTracks()) do
                        -- Проверка на атакующее действие
                        if _t.Priority == _K[_S(65,99,116,105,111,110)] or _t.Priority == _K[_S(65,99,116,105,111,110,50)] then
                            if _t.Speed > 0.4 and _t.TimePosition < 0.18 then
                                -- Проверка направления атаки врага
                                local _dot = (_mr.Position - _er.Position).Unit:Dot(_er.CFrame.LookVector)
                                if _dot > 0.35 then
                                    _X1(_er.Position)
                                    -- Адаптивный кулдаун: если враг в упоре, ждем меньше
                                    task.wait(_dist < 6 and 0.25 or 0.45)
                                    return 
                                end
                            end
                        end
                    end
                end
                
                -- Резервная проверка по звуку
                local _h = _ec:FindFirstChild("Head")
                if _h then
                    for _, _s in pairs(_h:GetChildren()) do
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
