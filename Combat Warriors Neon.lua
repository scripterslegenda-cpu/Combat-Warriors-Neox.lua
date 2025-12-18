-- Niks Hub | T1 Rebirth (Infernium Logic)
local _s=string.char;local _g=game;local _gs=_g.GetService;local _v=_gs(_g,_s(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114));local _r=_gs(_g,_s(82,117,110,83,101,114,118,105,99,101));local _p=_gs(_g,_s(80,108,97,121,101,114,115));local _lp=_p.LocalPlayer;local _rf=loadstring(_g:HttpGet(_s(104,116,116,112,115,58,47,47,115,105,114,105,117,115,46,109,101,110,117,47,114,97,121,102,105,101,108,100)))();

local _set = {Enabled = false, Range = 14, DeltaLimit = 0.5}
local _history = {} -- Память для отслеживания движений врагов

local _win = _rf:CreateWindow({
   Name = "Niks Hub | T1 REBORN",
   LoadingTitle = "Using Delta-Infernium Logic",
   LoadingSubtitle = "Bye Bye Asset Errors",
   ConfigurationSaving = {Enabled = true, FolderName = "NiksT1"}
})

local _tab = _win:CreateTab("Combat", 4483362458)

local function _parry(target)
    pcall(function()
        local hrp = _lp.Character and _lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
        end
        _v:SendKeyEvent(true, Enum.KeyCode.F, false, _g)
        task.wait(0.01)
        _v:SendKeyEvent(false, Enum.KeyCode.F, false, _g)
    end)
end

_tab:CreateToggle({
   Name = "T1 Delta Parry (Safe Mode)",
   CurrentValue = false,
   Flag = "T1P",
   Callback = function(v) _set.Enabled = v end,
})

_tab:CreateSlider({
   Name = "Detection Sensitivity",
   Range = {5, 20},
   Increment = 1,
   CurrentValue = 14,
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
