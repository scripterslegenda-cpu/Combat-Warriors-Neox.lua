-- Niks Hub | Legacy T1 (Safe Start Edition)
local _s=string.char;local _g=game;local _gs=_g.GetService;local _v=_gs(_g,_s(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114));local _r=_gs(_g,_s(82,117,110,83,101,114,118,105,99,101));local _p=_gs(_g,_s(80,108,97,121,101,114,115));local _lp=_p.LocalPlayer;local _rf=loadstring(_g:HttpGet(_s(104,116,116,112,115,58,47,47,115,105,114,105,117,115,46,109,101,110,117,47,114,97,121,102,105,101,108,100)))();

local _set = {Active = false, Dist = 15, LastPos = {}}

local _win = _rf:CreateWindow({
    Name = "Niks Hub | T1 Legacy",
    LoadingTitle = "Waiting for Activation...",
    LoadingSubtitle = "by Niks",
    ConfigurationSaving = {Enabled = true, FolderName = "NiksT1"}
})

local _tab = _win:CreateTab("Main", 4483362458)

local function _doParry(target)
    pcall(function()
        local hrp = _lp.Character and _lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Мгновенный поворот к обидчику (даже если ты лежишь)
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
        end
        _v:SendKeyEvent(true, Enum.KeyCode.F, false, _g)
        task.wait(0.01)
        _v:SendKeyEvent(false, Enum.KeyCode.F, false, _g)
    end)
end

-- Кнопка с визуальным переключением
local _toggle = _tab:CreateToggle({
    Name = "AutoParry [OFF]",
    CurrentValue = false,
    Flag = "AP",
    Callback = function(v)
        _set.Active = v
        -- Динамическое изменение текста (имитация цвета через текст)
        if v then
            print("Niks Hub: AutoParry ACTIVE (Green)")
        else
            _set.LastPos = {} -- Очищаем память при выключении
            print("Niks Hub: AutoParry DISABLED (Red)")
        end
    end
})

_tab:CreateSlider({
    Name = "Reaction Distance",
    Range = {5, 25},
    Increment = 1,
    CurrentValue = 15,
    Flag = "Dist",
    Callback = function(v) _set.Dist = v end
})

-- Оптимизированный цикл (спит, если кнопка OFF)
_r.Heartbeat:Connect(function()
    if not _set.Active then return end
    
    local myChar = _lp.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, enemy in pairs(_p:GetPlayers()) do
        if enemy ~= _lp and enemy.Character then
            pcall(function()
                local eRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local currentDist = (myRoot.Position - eRoot.Position).Magnitude
                    
                    if currentDist <= _set.Dist then
                        -- ЛОГИКА Т1: Анализ рывка (Delta Position)
                        local oldPos = _set.LastPos[enemy.Name] or eRoot.Position
                        local velocity = (oldPos - eRoot.Position).Magnitude
                        _set.LastPos[enemy.Name] = eRoot.Position

                        -- Если за 1 кадр враг переместился слишком резко к нам (атака)
                        -- или просто находится в "красной зоне" (7 студов)
                        if (velocity > 0.85) or (currentDist < 7.5) then
                            _doParry(eRoot)
                            task.wait(0.5) -- Кулдаун против спама
                        end
                    end
                end
            end)
        end
    end
end)  CurrentValue = 14,
   Flag = "T1S",
   Callback = function(v) _set.Range = v end,
})

_r.Heartbeat:Connect(function()
    if not _set.Enabled then return end
    
    local myRoot = _lp.Character and _lp.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, enemy in pairs(_p:GetPlayers()) do
        if enemy ~= _lp and enemy.Character then
            pcall(function()
                local eRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local currentDist = (myRoot.Position - eRoot.Position).Magnitude
                    
                    if currentDist <= _set.Range then
                        -- Считаем Delta (разницу между текущей и прошлой позицией)
                        local lastDist = _history[enemy.Name] or currentDist
                        local delta = lastDist - currentDist
                        _history[enemy.Name] = currentDist

                        -- Если враг "прыгнул" в твою сторону (Delta > 0.4 за один кадр)
                        -- Или он просто вплотную (Magnitude < 7)
                        if delta > 0.45 or currentDist < 7 then
                            _parry(eRoot)
                            task.wait(0.5)
                        end
                    end
                else
                    _history[enemy.Name] = nil
                end
            end)
        end
    end
end)
