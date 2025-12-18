-- Niks Hub V6 | Luarmor-Style Detection Logic
local _s=string.char;local _g=game;local _gs=_g.GetService;local _v=_gs(_g,_s(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114));local _r=_gs(_g,_s(82,117,110,83,101,114,118,105,99,101));local _p=_gs(_g,_s(80,108,97,121,101,114,115));local _lp=_p.LocalPlayer;local _rf=loadstring(_g:HttpGet(_s(104,116,116,112,115,58,47,47,115,105,114,105,117,115,46,109,101,110,117,47,114,97,121,102,105,101,108,100)))();

local _set = {Enabled = false, Range = 15, Prediction = 0.15}

local _win = _rf:CreateWindow({
   Name = "Niks Hub | PRO Edition",
   LoadingTitle = "Bypassing Animation Errors...",
   LoadingSubtitle = "by Niks",
   ConfigurationSaving = {Enabled = true, FolderName = "NiksHub"}
})

local _tab = _win:CreateTab("Combat", 4483362458)

local function _executeParry(target)
    if _lp.Character and _lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = _lp.Character.HumanoidRootPart
        -- Мгновенная коррекция взгляда (как в Luarmor скриптах)
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
    end
    
    _v:SendKeyEvent(true, Enum.KeyCode.F, false, _g)
    task.wait(0.02)
    _v:SendKeyEvent(false, Enum.KeyCode.F, false, _g)
end

_tab:CreateToggle({
   Name = "Pro Auto Parry (Luarmor Logic)",
   CurrentValue = false,
   Flag = "ParryToggle",
   Callback = function(v) _set.Enabled = v end,
})

_tab:CreateSlider({
   Name = "Detection Range",
   Range = {5, 30},
   Increment = 1,
   CurrentValue = 15,
   Flag = "Range",
   Callback = function(v) _set.Range = v end,
})

-- Умный цикл детекции без использования анимаций
_r.Heartbeat:Connect(function()
    if not _set.Enabled then return end
    
    local char = _lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, enemy in pairs(_p:GetPlayers()) do
        if enemy ~= _lp and enemy.Character then
            local eHrp = enemy.Character:FindFirstChild("HumanoidRootPart")
            if eHrp then
                local dist = (hrp.Position - eHrp.Position).Magnitude
                
                if dist <= _set.Range then
                    -- МЕТОД: Детекция "Вектора Ускорения"
                    -- Если враг движется к нам быстрее определенного порога (удар или рывок)
                    local velocity = eHrp.Velocity
                    local directionToMe = (hrp.Position - eHrp.Position).Unit
                    local dotProduct = velocity.Unit:Dot(directionToMe)

                    -- Если скорость высокая и направлена на нас ИЛИ враг в упоре
                    if (dotProduct > 0.8 and velocity.Magnitude > 25) or dist < 8 then
                        _executeParry(eHrp)
                        task.wait(0.4) -- Кулдаун защиты
                        break
                    end
                end
            end
        end
    end
end)
