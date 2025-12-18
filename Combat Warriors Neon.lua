-- Niks Hub V7 | PHYSICS ONLY (No Animation Checks)
local _s=string.char;local _g=game;local _gs=_g.GetService;local _v=_gs(_g,_s(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114));local _r=_gs(_g,_s(82,117,110,83,101,114,118,105,99,101));local _p=_gs(_g,_s(80,108,97,121,101,114,115));local _lp=_p.LocalPlayer;local _rf=loadstring(_g:HttpGet(_s(104,116,116,112,115,58,47,47,115,105,114,105,117,115,46,109,101,110,117,47,114,97,121,102,105,101,108,100)))();

local _set = {Enabled = false, Range = 15, Impulse = 20}

local _win = _rf:CreateWindow({
   Name = "Niks Hub | Physics V7",
   LoadingTitle = "Bypassing All Game Errors",
   LoadingSubtitle = "by Niks",
   ConfigurationSaving = {Enabled = true, FolderName = "NiksHub_V7"}
})

local _tab = _win:CreateTab("Combat", 4483362458)

local function _forceParry(target)
    pcall(function()
        local root = _lp.Character and _lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            -- Принудительный разворот (важно для регистрации блока сервером)
            root.CFrame = CFrame.lookAt(root.Position, Vector3.new(target.Position.X, root.Position.Y, target.Position.Z))
        end
        _v:SendKeyEvent(true, Enum.KeyCode.F, false, _g)
        task.wait(0.02)
        _v:SendKeyEvent(false, Enum.KeyCode.F, false, _g)
    end)
end

_tab:CreateToggle({
   Name = "Physics Detection (Anti-Lag)",
   CurrentValue = false,
   Flag = "PParry",
   Callback = function(v) _set.Enabled = v end,
})

_tab:CreateSlider({
   Name = "Danger Distance",
   Range = {5, 25},
   Increment = 1,
   CurrentValue = 15,
   Flag = "PRange",
   Callback = function(v) _set.Range = v end,
})

-- Логика детекции импульсов
_r.Heartbeat:Connect(function()
    if not _set.Enabled then return end
    
    local char = _lp.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, enemy in pairs(_p:GetPlayers()) do
        if enemy ~= _lp and enemy.Character then
            pcall(function()
                -- Берем RootPart или Torso (игнорируем ошибки отсутствия головы)
                local eRoot = enemy.Character:FindFirstChild("HumanoidRootPart") or enemy.Character:FindFirstChild("Torso")
                if eRoot then
                    local dist = (myRoot.Position - eRoot.Position).Magnitude
                    
                    if dist <= _set.Range then
                        -- Анализ скорости: Удар в CW дает резкий прирост Velocity
                        local speed = eRoot.Velocity.Magnitude
                        
                        -- Если игрок в радиусе 15 И его скорость резко подскочила (импульс удара)
                        -- Или он подошел почти вплотную (защита от невидимых атак)
                        if speed > _set.Impulse or dist < 8 then
                            _forceParry(eRoot)
                            task.wait(0.5) -- Кулдаун, чтобы не спамить блок
                        end
                    end
                end
            end)
        end
    end
end)
