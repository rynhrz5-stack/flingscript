local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local existing = PlayerGui:FindFirstChild("RynScript")
if existing then
	existing:Destroy()
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "RynScript"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--------------------------------------------------
-- LOADING SCREEN
--------------------------------------------------

local Loading = Instance.new("Frame")
Loading.Name = "Loading"
Loading.Size = UDim2.fromOffset(400, 200)
Loading.Position = UDim2.fromScale(0.5, 0.5)
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.BackgroundColor3 = Color3.fromRGB(17, 17, 21)
Loading.BorderSizePixel = 0
Loading.Parent = Gui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 14)
LoadingCorner.Parent = Loading

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, -40, 0, 40)
LoadingTitle.Position = UDim2.fromOffset(20, 22)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "Ryn Script"
LoadingTitle.TextColor3 = Color3.new(1, 1, 1)
LoadingTitle.TextSize = 27
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Parent = Loading

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, -40, 0, 25)
LoadingStatus.Position = UDim2.fromOffset(20, 70)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Text = "Ryn Script Loading... 0%"
LoadingStatus.TextColor3 = Color3.fromRGB(155, 155, 165)
LoadingStatus.TextSize = 14
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.Parent = Loading

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(1, -40, 0, 8)
BarBackground.Position = UDim2.new(0, 20, 1, -45)
BarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = Loading

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Bar.BorderSizePixel = 0
Bar.Parent = BarBackground

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = Bar

--------------------------------------------------
-- LOADING ANIMATION
--------------------------------------------------

for i = 0, 100 do
	Bar.Size = UDim2.new(i / 100, 0, 1, 0)
	LoadingStatus.Text = "Ryn Script Loading... " .. i .. "%"
	task.wait(0.015)
end

LoadingStatus.Text = "Ryn Script Loaded"
task.wait(0.5)

Loading:Destroy()

--------------------------------------------------
-- MAIN MENU
--------------------------------------------------

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(450, 350)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(17, 17, 21)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

--------------------------------------------------
-- TITLE
--------------------------------------------------

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 35)
Title.Position = UDim2.fromOffset(15, 15)
Title.BackgroundTransparency = 1
Title.Text = "Ryn Script"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 25
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -30, 0, 22)
Subtitle.Position = UDim2.fromOffset(15, 48)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Player Controls"
Subtitle.TextColor3 = Color3.fromRGB(145, 145, 155)
Subtitle.TextSize = 13
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

--------------------------------------------------
-- PLAYER SELECTOR
--------------------------------------------------

local SelectedPlayer = nil

local Selector = Instance.new("TextButton")
Selector.Size = UDim2.new(1, -30, 0, 45)
Selector.Position = UDim2.fromOffset(15, 80)
Selector.BackgroundColor3 = Color3.fromRGB(29, 29, 36)
Selector.BorderSizePixel = 0
Selector.Text = "Select Player"
Selector.TextColor3 = Color3.new(1, 1, 1)
Selector.TextSize = 14
Selector.Font = Enum.Font.GothamMedium
Selector.Parent = Main

local SelectorCorner = Instance.new("UICorner")
SelectorCorner.CornerRadius = UDim.new(0, 9)
SelectorCorner.Parent = Selector

--------------------------------------------------
-- PLAYER LIST
--------------------------------------------------

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -30, 0, 125)
PlayerList.Position = UDim2.fromOffset(15, 132)
PlayerList.BackgroundColor3 = Color3.fromRGB(23, 23, 29)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Visible = false
PlayerList.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 9)
ListCorner.Parent = PlayerList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerList

--------------------------------------------------
-- REFRESH PLAYERS
--------------------------------------------------

local function RefreshPlayers()

	for _, child in ipairs(PlayerList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, target in ipairs(Players:GetPlayers()) do

		if target ~= LocalPlayer then

			local PlayerButton = Instance.new("TextButton")
			PlayerButton.Size = UDim2.new(1, -8, 0, 34)
			PlayerButton.BackgroundColor3 = Color3.fromRGB(31, 31, 38)
			PlayerButton.BorderSizePixel = 0
			PlayerButton.Text = target.DisplayName .. "  @" .. target.Name
			PlayerButton.TextColor3 = Color3.new(1, 1, 1)
			PlayerButton.TextSize = 13
			PlayerButton.Font = Enum.Font.Gotham
			PlayerButton.Parent = PlayerList

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 7)
			Corner.Parent = PlayerButton

			PlayerButton.MouseButton1Click:Connect(function()

				SelectedPlayer = target
				Selector.Text = target.DisplayName .. "  @" .. target.Name
				PlayerList.Visible = false

			end)
		end
	end

	task.wait()

	PlayerList.CanvasSize = UDim2.new(
		0,
		0,
		0,
		ListLayout.AbsoluteContentSize.Y + 8
	)
end

Selector.MouseButton1Click:Connect(function()

	RefreshPlayers()

	PlayerList.Visible = not PlayerList.Visible

end)

Players.PlayerAdded:Connect(function()
	RefreshPlayers()
end)

Players.PlayerRemoving:Connect(function(player)

	if SelectedPlayer == player then
		SelectedPlayer = nil
		Selector.Text = "Select Player"
	end

	RefreshPlayers()

end)

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------

local function CreateButton(text, position, size)

	local Button = Instance.new("TextButton")

	Button.Size = size
	Button.Position = position
	Button.BackgroundColor3 = Color3.fromRGB(29, 29, 36)
	Button.BorderSizePixel = 0
	Button.Text = text
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.TextSize = 14
	Button.Font = Enum.Font.GothamMedium
	Button.Parent = Main

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Button

	return Button
end

--------------------------------------------------
-- FLING BUTTONS
--------------------------------------------------

local FlingButton = CreateButton(
	"Fling Player",
	UDim2.new(0, 15, 1, -60),
	UDim2.new(0.5, -20, 0, 45)
)

local FlingAllButton = CreateButton(
	"Fling All",
	UDim2.new(0.5, 5, 1, -60),
	UDim2.new(0.5, -20, 0, 45)
)

--------------------------------------------------
-- REMOTE EVENT
--------------------------------------------------

local FlingEvent = ReplicatedStorage:WaitForChild("RynFling")

--------------------------------------------------
-- FLING PLAYER
--------------------------------------------------

FlingButton.MouseButton1Click:Connect(function()

	if not SelectedPlayer then
		Selector.Text = "Select a player first"

		task.delay(1, function()
			if Selector.Parent then
				Selector.Text = "Select Player"
			end
		end)

		return
	end

	if SelectedPlayer.Parent ~= Players then
		SelectedPlayer = nil
		Selector.Text = "Select Player"
		return
	end

	FlingEvent:FireServer(SelectedPlayer)

end)

--------------------------------------------------
-- FLING ALL
--------------------------------------------------

FlingAllButton.MouseButton1Click:Connect(function()
	FlingEvent:FireServer("ALL")
end)
