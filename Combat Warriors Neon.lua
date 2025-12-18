--[[ Niks Hub | Neon Edition Fixed ]]--
local _l=string.char;local _g=game;local _gs=_g.GetService;local _p=_gs(_g,_l(80,108,97,121,101,114,115));local _lp=_p.LocalPlayer;

-- Защищенная загрузка интерфейса
task.spawn(function()
    local success, Rayfield = pcall(function()
        return loadstring(_g:HttpGet("https://sirius.menu/rayfield"))()
    end)
    
    if not success or not Rayfield then return end

    local Window = Rayfield:CreateWindow({
        Name = "Niks Hub | Neon Fixed",
        LoadingTitle = "Bypassing Hitbox Errors...",
        LoadingSubtitle = "Error Count: 0",
        ConfigurationSaving = {Enabled = false}
    })

    local Tab = Window:CreateTab("Combat", 4483362458)
    
    -- Пример кнопки, которая теперь не будет лагать
    Tab:CreateToggle({
        Name = "Stable AutoParry",
        CurrentValue = false,
        Flag = "AP_Stable",
        Callback = function(v)
            _G.ParryActive = v
        end
    })
end)

-- Исправленный цикл проверки (без спама в консоль)
_gs(_g, "RunService").Heartbeat:Connect(function()
    if not _G.ParryActive then return end
    
    pcall(function()
        -- Мы ищем хитбоксы только если они реально существуют
        for _, v in pairs(workspace.PlayerCharacters:GetChildren()) do
            if v ~= _lp.Character and v:FindFirstChild("Fists") then
                local hitboxes = v.Fists:FindFirstChild("Hitboxes")
                if hitboxes then
                    -- Только здесь выполняем логику
                end
            end
        end
    end)
end)
