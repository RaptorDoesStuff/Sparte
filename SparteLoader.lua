-- Init
wait(1)

-- Init > Checking for Synapse
if not syn then
    warn("Sparte currently only supports Synapse")
    return
end

-- Init > Environments
getgenv().ExploitEnv = getgenv()
ExploitEnv.RobloxEnv = getrenv()

-- Init > Services
local Service = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Lighting = game:GetService("Lighting"),
    HttpService = game:GetService("HttpService"),
    TweenService = game:GetService("TweenService")
}

-- Init > Constants
local Constant = {
    Version = "1.0",
    LocalPlayer = Service.Players.LocalPlayer
}

-- Init > Functions
ExploitEnv.CheckForProperty = function(instance,property)
    local success = pcall(function()
        local prop = instance[property]
    end)
    return success
end
ExploitEnv.CreateInstance = function(Type,Properties)
    local Inst = Instance.new(Type)
    for i, v in pairs(Properties) do
        if i ~= "Parent" then
            Inst[i] = v
        end
    end
    if CheckForProperty(Inst,"Parent") then Inst.Parent = Properties.Parent end
    return Inst
end
local TweenLabelText = function(instance,startText,goalText,waitTime)
    if instance.Text == nil then
        error("Instance does not have a text property")
        return 
    end
    startText = startText or ""
    goalTextArray = goalText:split("")
    instance.Text = startText
    for i = 1, goalText:len() do
        instance.Text ..= goalTextArray[i]
        wait(waitTime)
    end
end
ExploitEnv.DecodeJSON = function(json)
    return HttpService:JSONDecode(json)
end
ExploitEnv.EncodeJSON = function(json)
    return HttpService:JSONEncode(json)
end

-- Init > Globalizing Constants & Services
for i, v in pairs(Service) do
    ExploitEnv[i] = v
end
for i, v in pairs(Constant) do
    ExploitEnv[i] = v
end

-- Init > UI
local MainGui = {}
local SparteLoader = CreateInstance("ScreenGui",{Name = "SparteLoader",Parent = game:GetService("CoreGui").RobloxGui,ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
local MainFrame = CreateInstance("Frame",{Name = "MainFrame",Parent = SparteLoader,AnchorPoint = Vector2.new(0.5,0.5),BackgroundColor3 = Color3.fromRGB(70,70,70),BorderSizePixel = 0,Position = UDim2.new(0.5,0,-0.1,0),Size = UDim2.new(0,200,0,40)})
MainGui.UICorner = CreateInstance("UICorner",{CornerRadius = UDim.new(0,6),Parent = MainFrame})
MainGui.Label = CreateInstance("TextLabel",{Name = "Label",Parent = MainFrame,BackgroundTransparency = 1,BorderSizePixel = 0,Position = UDim2.new(0.2,0,0,0),Size = UDim2.new(0,200,0,40),Visible = false,Font = Enum.Font.Gotham,Text = "Sparte Loader",TextColor3 = Color3.fromRGB(250,250,250),TextSize = 20})
MainGui.LoadingBar = CreateInstance("Frame",{Name = "LoadingBar",Parent = MainFrame,BackgroundColor3 = Color3.fromRGB(58,161,10),BorderSizePixel = 0,Position = UDim2.new(0.149,0,0.393,0),Size = UDim2.new(0,0,0,25),Visible = false,ZIndex = 2})
MainGui.LoadingBarBack = CreateInstance("Frame",{Name = "LoadingBarBack",Parent = MainFrame,BackgroundColor3 = Color3.fromRGB(255,255,255),BorderColor3 = Color3.fromRGB(60,60,60),BorderSizePixel = 3,Position = UDim2.new(0.149,0,0.393,0),Size = UDim2.new(0,235,0,25),Visible = false})
MainGui.LoadingBarLabel = CreateInstance("TextLabel",{Name = "LoadingBarLabel",Parent = MainFrame,BackgroundColor3 = Color3.fromRGB(255,255,255),BackgroundTransparency = 1,BorderSizePixel = 0,Position = UDim2.new(0.2,0,0.6,0),Size = UDim2.new(0,200,0,23),Visible = false,Font = Enum.Font.Gotham,TextColor3 = Color3.fromRGB(250,250,250),TextSize = 13})
local WelcomeLabel = CreateInstance("TextLabel",{Name = "WelcomeLabel",Parent = MainFrame,BackgroundTransparency = 1,BorderSizePixel = 0,Size = MainFrame.Size,Font = Enum.Font.Gotham,Text = "",TextColor3 = Color3.fromRGB(250,250,250),TextSize = 13})
MainGui.NoticeLabel = CreateInstance("TextLabel",{Name = "NoticeLabel",Parent = MainFrame,BackgroundTransparency = 1,BorderSizePixel = 0,Position = UDim2.new(0.2,0,0.819),Size = UDim2.new(0,200,0,23),Visible = false,Font = Enum.Font.Gotham,Text = "<i>UI design takes inspiration from EzHub</i>",TextColor3 = Color3.fromRGB(250,250,250),TextSize = 9,RichText = true})

-- Loading

-- Loading > Welcome
TweenService:Create(MainFrame,TweenInfo.new(0.75),{Position = UDim2.new(0.5,0,0.5,0)}):Play()
wait(1.25)
TweenLabelText(WelcomeLabel,"","Hello " .. LocalPlayer.Name,0.05)
wait(3)

-- Loading > Init Loader
WelcomeLabel.Visible = false
wait()
TweenService:Create(MainFrame,TweenInfo.new(0.5),{Size = UDim2.new(0,335,0,122)}):Play()
MainGui.LoadingBarLabel.Text = "Retrieving Modules..."
wait(0.5)
for i, v in pairs(MainGui) do
    if CheckForProperty(v,"Visible") then v.Visible = true end
end

-- Loading > Loading Action List
local lbl = MainGui.LoadingBarLabel
local LoadingActions = {
    function()
        lbl.Text = "Initializing..."
        local UpdateSparte = function()
            writefile("Sparte/Version.txt",game:HttpGet("https://google.com"))
            writefile("Sparte/Modules.json",game:HttpGet("https://google.com"))
            writefile("Sparte/UI.lua",game:HttpGet("https://google.com"))
            writefile("Sparte/Main.lua",game:HttpGet("https://google.com"))
        end
        if not isfolder("Sparte") then
            lbl.Text = "Preforming first time setup..."
            makefolder("Sparte")
            UpdateSparte()
            writefile("Sparte/CustomModules.json",EncodeJSON({"You can make your own Modules for Sparte, more info here URL HERE"}))
        elseif readfile("Sparte/Version.txt") ~= game:HttpGet("URL HERE") then
            lbl.Text = "Updating Sparte..."
            UpdateSparte()
        end
    end,
    function()
        lbl.Text = "Loading Modules..."
    end
}

-- Loading > Loading
do
    local BarMoveSize = 235 / #LoadingActions
    for i, v in pairs(LoadingActions) do
        v()
        TweenService:Create(MainGui.LoadingBar,TweenInfo.new(0.2),{Size = UDim2.new(0,BarMoveSize*i,0,25)}):Play()
        if i == #LoadingActions then
            lbl.Text = "Starting Sparte..."
            wait(1)
            for i, v in pairs(MainGui) do
                if CheckForProperty(v,"Visible") then v.Visible = false end
            end
            TweenService:Create(MainFrame,TweenInfo.new(1),{Size = UDim2.new(0,0,0,0)}):Play()
            SparteLoader:Destroy()
            loadfile("Sparte/Main.lua")()
        end
    end
end
