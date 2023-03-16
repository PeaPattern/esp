_G.Enabled = true
_G.TargetPart = "PrimaryPart"--child name (i.e. UpperTorso) or PrimaryPart or blank for HumanoidRootPart

_G.Text = true
_G.TextColor = Color3.fromRGB(0,255,0)
_G.TextOutline = true
_G.TextOutlineColor = Color3.fromRGB(0,0,0)
_G.TextOffset = Vector3.new(0,4,0)
_G.TextFont = "System" --UI,System,Plex,Monospace

_G.Shape = true
_G.ShapeType = "Square" --Circle,Square,Triangle
_G.ShapeColor = Color3.fromRGB(255,255,255)
_G.ShapeFilled = false
_G.ShapeSize = 80
_G.ShapeThickness = 1

--=-=-=-=-=-=-=--

local Camera = workspace.CurrentCamera

local function ESP(Target)
    local lbl = Drawing.new("Text")
    lbl.Text = string.format("%s (@%s)", Target.DisplayName, Target.Name)
    lbl.Size = 20
    lbl.Center = true
    lbl.Outline = _G.TextOutline
    lbl.Color = _G.TextColor
    lbl.OutlineColor = _G.TextOutlineColor
    lbl.Visible = _G.Text
    lbl.Font = Drawing.Fonts[_G.TextFont]
    
    local shape = Drawing.new(_G.ShapeType)
    if _G.ShapeType == "Circle" then
        shape.Radius = _G.ShapeSize
    elseif _G.ShapeType == "Square" then
        shape.Size = Vector2.new(_G.ShapeSize,_G.ShapeSize)
    end
    shape.Thickness = _G.ShapeThickness
    shape.Filled = _G.ShapeFilled
    shape.Color = _G.ShapeColor
    shape.Visible = _G.Shape
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            local Root
            if _G.TargetPart == "" then
                Root = Target.Character.HumanoidRootPart
            elseif _G.TargetPart == "PrimaryPart" then
                Root = Target.Character.PrimaryPart
            elseif Target.Character:FindFirstChild(_G.TargetPart) then
                Root = Target.Character:FindFirstChild(_G.TargetPart)
            end
            local playerPosition = Root.Position
            
            local namePosition, nameVisible = Camera:WorldToViewportPoint(playerPosition + _G.TextOffset)
            local shapePosition, shapeVisible = Camera:WorldToViewportPoint(playerPosition)
            
            if namePosition and nameVisible and _G.Enabled then
                lbl.Visible = true
                lbl.Position = Vector2.new(namePosition.X, namePosition.Y)
            else
                lbl.Visible = false
            end
            
            if shapePosition and shapeVisible and _G.Enabled then
                shape.Visible = true
                local VectorTwo = Vector2.new(shapePosition.X-_G.ShapeSize/2, shapePosition.Y-_G.ShapeSize/2)
                if _G.ShapeType == "Triangle" then
                    shape.PointA = VectorTwo + Vector2.new(-_G.ShapeSize,_G.ShapeSize,0)
                    shape.PointB = VectorTwo + Vector2.new(0,-_G.ShapeSize,0)
                    shape.PointC = VectorTwo + Vector2.new(_G.ShapeSize,_G.ShapeSize,0)
                else
                    shape.Position = VectorTwo
                end
            else
                shape.Visible = false
            end
        else
            shape.Visible = false
        end
    end)
end

for _,v in next, game:GetService("Players"):GetPlayers() do
    ESP(v)
end
game:GetService("Players").PlayerAdded:Connect(function(v)
    ESP(v)
end)
