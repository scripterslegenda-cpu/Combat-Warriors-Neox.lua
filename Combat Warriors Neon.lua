-- Niks Hub | T1 Legacy (STABLE UI EDITION)
local _s=string.char;local _g=game;local _gs=_g.GetService;local _r=_gs(_g,_s(82,117,110,83,101,114,118,105,99,101));local _p=_gs(_g,_s(80,108,97,121,101,114,115));local _v=_gs(_g,_s(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114));local _lp=_p.LocalPlayer;

local _set = {Active = false, Dist = 15, LastPos = {}}

-- Функция парирования вынесена отдельно для стабильности
local function _doParry(target)
    pcall(function()
        local char = _lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and target then
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
            _v:SendKeyEvent(true, Enum.KeyCode.F, false, _g)
            task.wait(0.01)
            _v:SendKeyEvent(false, Enum.KeyCode.F, false, _g)
        end
    end)
end

-- Изолируем создание UI от лагов игры
task.spawn(function()
    local success, _rf = pcall(function()
        return loadstring(_g:HttpGet(_s(104,116,116,112,115,58,47,47,115,105,114,105,117,115,46,109,101,110,117,47,114,97,121,102,105,101,108,100)))()
    end)

    if not success or not _rf then return end

    local _win = _rf:CreateWindow({
        Name = "Niks Hub | V8 STABLE",
        LoadingTitle = "UI Protection Active",
        LoadingSubtitle = "by Niks",
        ConfigurationSaving = {Enabled = false}
    })

    local _tab = _win:CreateTab("Main", 4483362458)

    _tab:CreateToggle({
        Name = "AutoParry [ON/OFF]",
        CurrentValue = false,
        Flag = "AP",
        Callback = function(v)
            _set.Active = v
            _set.LastPos = {} -- Очистка кэша
        end
    })

    _tab:CreateSlider({
        Name = "Distance",
        Range = {5, 25},
        Increment = 1,
        CurrentValue = 15,
        Flag = "D",
        Callback = function(v) _set.Dist = v end
    })
end)

-- ГЛАВНЫЙ ЦИКЛ (Полностью игнорирует анимации игры)
_r.Heartbeat:Connect(function()
    if not _set.Active then return end
    
    local myRoot = _lp.Character and _lp.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, enemy in pairs(_p:GetPlayers()) do
        if enemy ~= _lp and enemy.Character then
            -- Безопасная проверка физики (Delta Velocity)
            pcall(function()
                local eRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local dist = (myRoot.Position - eRoot.Position).Magnitude
                    
                    if dist <= _set.Dist then
                        local old = _set.LastPos[enemy.Name] or eRoot.Position
                        local delta = (old - eRoot.Position).Magnitude
                        _set.LastPos[enemy.Name] = eRoot.Position

                        -- Если зафиксирован резкий рывок (атака) или враг слишком близко
                        if delta > 0.82 or dist < 7 then
                            _doParry(eRoot)
                            task.wait(0.5)
                        end
                    end
                end
            end)
        end
    end
end)
