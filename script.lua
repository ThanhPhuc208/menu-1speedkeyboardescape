local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Thanh Phuc",
   LoadingTitle = "Thanh Phuc Hub",
   LoadingSubtitle = "by Thanh Phuc",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Biến logic điều khiển game +1 Speed Keyboard Escape
local autoWinTween = false
local travelSpeed = 120
local autoRebirth = false
local removeObstacles = false
local selectedTarget = "WB32 (300M)"

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Thuật toán tìm Win Block trên map
local function getTargetWinBlock()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():match("win") or v.Name:lower():match("finish") or v.Name:lower():match("pad")) then
            return v
        end
    end
    return nil
end

-- Vòng lặp Auto Win (Tween bay mượt tránh Anticheat thay vì dịch chuyển tức thời)
task.spawn(function()
    while task.wait(0.1) do
        if autoWinTween then
            pcall(function()
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local target = getTargetWinBlock()
                
                if root and target then
                    local distance = (target.Position - root.Position).Magnitude
                    -- Tính toán thời gian di chuyển dựa trên thanh trượt Travel Speed %
                    local duration = distance / (travelSpeed * 0.5)
                    
                    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(root, tweenInfo, {CFrame = target.CFrame + Vector3.new(0, 3, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end)
        end
    end
end)

-- Vòng lặp Auto Rebirth
task.spawn(function()
    while task.wait(1) do
        if autoRebirth then
            pcall(function()
                -- Kích hoạt sự kiện Rebirth từ hệ thống Remote của game
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or game:GetService("ReplicatedStorage"):FindFirstChild("RebirthRequest")
                if remote and remote:IsA("RemoteEvent") then
                    remote:FireServer()
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- CẤU TRÚC TAB GIAO DIỆN (Y HỆT ẢNH MINH HỌA CỦA BẠN)
----------------------------------------------------------------

-- TAB 1: SPEED
local SpeedTab = Window:CreateTab("Speed", 4483362458) -- ID Icon Speed

local Section1 = SpeedTab:CreateSection("AUTO WIN")

local Toggle1 = SpeedTab:CreateToggle({
   Name = "Auto Win (tween)",
   CurrentValue = false,
   Callback = function(Value)
      autoWinTween = Value
   end,
})

local Dropdown = SpeedTab:CreateDropdown({
   Name = "Target Win Block",
   Options = {"WB1 (10M)", "WB10 (100M)", "WB32 (300M)", "Max Distance"},
   CurrentOption = {"WB32 (300M)"},
   MultipleOptions = false,
   Callback = function(Option)
      selectedTarget = Option[1]
   end,
})

local Slider = SpeedTab:CreateSlider({
   Name = "Travel speed (% WalkSpeed)",
   Increment = 10,
   Max = 300,
   Min = 10,
   CurrentValue = 120,
   Callback = function(Value)
      travelSpeed = Value
   end,
})

local Section2 = SpeedTab:CreateSection("REBIRTH")

local Toggle2 = SpeedTab:CreateToggle({
   Name = "Auto Rebirth (when eligible)",
   CurrentValue = false,
   Callback = function(Value)
      autoRebirth = Value
   end,
})

local Button1 = SpeedTab:CreateButton({
   Name = "Rebirth Now",
   Callback = function()
      pcall(function()
          local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or game:GetService("ReplicatedStorage"):FindFirstChild("RebirthRequest")
          if remote then remote:FireServer() end
      end)
   end,
})

local Section3 = SpeedTab:CreateSection("OBSTACLES & SAFETY")

local Toggle3 = SpeedTab:CreateToggle({
   Name = "Remove All Obstacles",
   CurrentValue = false,
   Callback = function(Value)
      removeObstacles = Value
      if removeObstacles then
          -- Xóa sương mù và các chướng ngại vật cản đường trên map
          for _, v in pairs(workspace:GetDescendants()) do
              if v:IsA("BasePart") and (v.Name:lower():match("kill") or v.Name:lower():match("lava") or v.Name:lower():match("obstacle")) then
                  v.CanTouch = false
                  v.Transparency = 0.8
              end
          end
      end
   end,
})

-- TAB 2: SHOP
local ShopTab = Window:CreateTab("Shop", 4483362458)
local ShopSection = ShopTab:CreateSection("Auto Buy Upgrades")

-- TAB 3: SETTINGS
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Menu Keybind")
