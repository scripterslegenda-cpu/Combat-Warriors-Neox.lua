-- Полная очистка от старых ошибок
local _S = string.char
local _G_ = game
local _GS = _G_.GetService
local _P = _GS(_G_, _S(80,108,97,121,101,114,115))
local _LP = _P.LocalPlayer
local _RS = _GS(_G_, _S(82,117,110,83,101,114,118,105,99,101))
local _VIM = _GS(_G_, _S(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114))

-- Настройки
local _RANGE = 12
local _COOLDOWN = false

local function _DO_PARRY(_target)
    if _COOLDOWN then return end
    _COOLDOWN = true
    
    -- Авто-поворот (теперь через CFrame.lookAt для стабильности)
    if _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
        local _hrp = _LP.Character.HumanoidRootPart
        _hrp.CFrame = CFrame.lookAt(_hrp.Position, Vector3.new(_target.X, _hrp.Position.Y, _target.Z))
    end

    -- Рандомная задержка (человеческий фактор)
    task.wait(math.random(6, 11) / 100)
    
    _VIM:SendKeyEvent(true, Enum.KeyCode.F, false, _G_)
    task.wait(0.02)
    _VIM:SendKeyEvent(false, Enum.KeyCode.F, false, _G_)
    
    task.wait(0.35) -- Кулдаун блока
    _COOLDOWN = false
end

_RS.Heartbeat:Connect(function()
    local _myChar = _LP.Character
    if not _myChar or not _myChar:FindFirstChild("HumanoidRootPart") then return end

    for _, _enemy in pairs(_P:GetPlayers()) do
        if _enemy ~= _LP and _enemy.Character and _enemy.Character:FindFirstChild("HumanoidRootPart") then
            local _eChar = _enemy.Character
            local _eRoot = _eChar.HumanoidRootPart
            local _dist = (_myChar.HumanoidRootPart.Position - _eRoot.Position).Magnitude

            if _dist <= _RANGE then
                local _eHum = _eChar:FindFirstChildOfClass("Humanoid")
                if not _eHum then continue end

                -- ПРОВЕРКА ЧЕРЕЗ СОСТОЯНИЕ (Надежнее анимаций)
                -- Если враг в состоянии атаки или проигрывает активный трек
                local _animator = _eHum:FindFirstChildOfClass("Animator")
                if _animator then
                    local _tracks = _animator:GetPlayingAnimationTracks()
                    for _, _t in pairs(_tracks) do
                        -- В CW почти все атаки имеют Priority > 2 (Action/Action2)
                        if _t.Priority.Value >= 2 and _t.Speed > 0.3 then
                            -- Проверка: направлен ли враг на нас
                            local _dot = (_myChar.HumanoidRootPart.Position - _eRoot.Position).Unit:Dot(_eRoot.CFrame.LookVector)
                            
                            if _dot > 0.25 then -- Увеличили угол обзора
                                _DO_PARRY(_eRoot.Position)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)
