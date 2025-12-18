-- Niks Hub | Final Zero-Animation Method
local _s = string.char
local _g = game
local _gs = _g.GetService
local _v = _gs(_g, _s(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114))
local _r = _gs(_g, _s(82,117,110,83,101,114,118,105,99,101))
local _p = _gs(_g, _s(80,108,97,121,101,114,115))
local _lp = _p.LocalPlayer
local _rf = loadstring(_g:HttpGet(_s(104,116,116,112,115,58,47,47,115,105,114,105,117,115,46,109,101,110,117,47,114,97,121,102,105,101,108,100)))()

local _set = {Enabled = false, Range = 15, Sens = 10}

local _win = _rf:CreateWindow({
   Name = "Niks Hub | Zero-Errors",
   LoadingTitle = "Physics Bypass System",
   LoadingSubtitle = "by Niks",
   ConfigurationSaving = {Enabled = true, FolderName = "NiksHub_V2"}
})

local _tab = _win:CreateTab("Combat", 4483362458)

local function _parry(targetRoot)
    pcall(function()
        local myRoot = _lp.Character and _lp.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            -- Разворот к врагу
            myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(targetRoot.Position.X, myRoot.Position.Y, targetRoot.Position.Z))
        end
        -- Нажатие блока
        _v:SendKeyEvent(true, Enum.KeyCode.F, false, _g)
        task.wait(0.01)
        _v:SendKeyEvent(false, Enum.KeyCode.F, false, _g)
    end)
end

_tab:CreateToggle({
   Name = "Physics Auto Parry (No Anims)",
   CurrentValue = false,
   Flag = "ParryToggle",
   Callback = function(v) _set.Enabled = v end,
})

_tab:CreateSlider({
   Name = "Range",
   Range = {5, 25},
   Increment = 1,
   CurrentValue = 15,
   Flag = "Range",
   Callback = function(v) _set.Range = v end,
})

-- Основной поток (только физика)
_r.Heartbeat:Connect(function()
    if not _set.Enabled then return end
    
    local char = _lp.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, enemy in pairs(_p:GetPlayers()) do
        if enemy ~= _lp and enemy.Character then
            pcall(function() -- Оборачиваем всё в pcall, чтобы ошибки консоли не тормозили цикл
                local eRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local dist = (myRoot.Position - eRoot.Position).Magnitude
                    
                    if dist <= _set.Range then
                        -- Метод относительной скорости:
                        -- Если враг движется в нашу сторону со скоростью удара
                        local relVel = (eRoot.Velocity - myRoot.Velocity).Magnitude
                        
                        -- В Combat Warriors удар всегда дает импульс скорости > 15
                        if relVel > 18 or dist < 7 then 
                            _parry(eRoot)
                            task.wait(0.5) -- Кулдаун, чтобы не спамить впустую
                        end
                    end
                end
            end)
        end
    end
end)
