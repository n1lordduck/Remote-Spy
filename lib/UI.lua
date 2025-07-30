local p=game:GetService("Players")
local u=game:GetService("UserInputService")
local t=game:GetService("TweenService")
local r=game:GetService("RunService")
local c=game:GetService("CoreGui")

local m={}
m.__index=m

local w={}
w.__index=w

local function applySyntaxHighlighting(text)
    local keywords={"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while","export","type","typeof","continue"}
    local services={"game","workspace","script","Instance","Vector3","Vector2","CFrame","Color3","UDim2","UDim","Enum","BrickColor","Region3","Ray","tick","wait","spawn","delay","coroutine"}
    
    local result=""
    local i=1
    local len=#text
    
    while i<=len do
        local char=text:sub(i,i)
        
        if char=="-"and text:sub(i+1,i+1)=="-"then
            local lineEnd=text:find("\n",i)or len+1
            result=result..'<font color="rgb(120,120,125)">'..text:sub(i,lineEnd-1).."</font>"
            i=lineEnd
        elseif char=='"'or char=="'"then
            local stringEnd=i+1
            while stringEnd<=len and text:sub(stringEnd,stringEnd)~=char do
                if text:sub(stringEnd,stringEnd)=="\\"then
                    stringEnd=stringEnd+1
                end
                stringEnd=stringEnd+1
            end
            result=result..'<font color="rgb(255,150,150)">'..text:sub(i,stringEnd).."</font>"
            i=stringEnd+1
        elseif char:match("%a")or char=="_"then
            local wordEnd=i
            while wordEnd<=len and(text:sub(wordEnd,wordEnd):match("%w")or text:sub(wordEnd,wordEnd)=="_")do
                wordEnd=wordEnd+1
            end
            local word=text:sub(i,wordEnd-1)
            
            local isKeyword=false
            for _,keyword in ipairs(keywords)do
                if word==keyword then
                    result=result..'<font color="rgb(255,100,150)">'..word.."</font>"
                    isKeyword=true
                    break
                end
            end
            
            if not isKeyword then
                for _,service in ipairs(services)do
                    if word==service then
                        result=result..'<font color="rgb(100,200,255)">'..word.."</font>"
                        isKeyword=true
                        break
                    end
                end
            end
            
            if not isKeyword then
                if word:match("^[A-Z]")then
                    result=result..'<font color="rgb(150,255,150)">'..word.."</font>"
                else
                    result=result..word
                end
            end
            
            i=wordEnd
        elseif char:match("%d")then
            local numEnd=i
            while numEnd<=len and(text:sub(numEnd,numEnd):match("%d")or text:sub(numEnd,numEnd)==".")do
                numEnd=numEnd+1
            end
            result=result..'<font color="rgb(255,200,100)">'..text:sub(i,numEnd-1).."</font>"
            i=numEnd
        else
            result=result..char
            i=i+1
        end
    end
    
    return result
end

function m:CreateWindow(cfg)
    local self=setmetatable({},w)
    
    self.EventClicked=Instance.new("BindableEvent")
    self.WindowClosed=Instance.new("BindableEvent")
    self.Events={}
    self.EventGroups={}
    self.Buttons={}
    
    local s=Instance.new("ScreenGui")
    s.Name="MacUI_"..tick()
    s.Parent=c
    s.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    
    local f=Instance.new("Frame")
    f.Name="MainWindow"
    f.Parent=s
    f.Size=UDim2.new(0,cfg.Size and cfg.Size[1] or 800,0,cfg.Size and cfg.Size[2] or 500)
    f.BackgroundColor3=Color3.fromRGB(30,30,35)
    f.BorderSizePixel=0
    
    if cfg.Position=="center" then
        f.Position=UDim2.new(0.5,-f.Size.X.Offset/2,0.5,-f.Size.Y.Offset/2)
    elseif type(cfg.Position)=="table" then
        f.Position=UDim2.new(0,cfg.Position[1],0,cfg.Position[2])
    else
        f.Position=UDim2.new(0.5,-f.Size.X.Offset/2,0.5,-f.Size.Y.Offset/2)
    end
    
    local wc=Instance.new("UICorner")
    wc.CornerRadius=UDim.new(0,10)
    wc.Parent=f
    
    local tb=Instance.new("Frame")
    tb.Name="TitleBar"
    tb.Parent=f
    tb.Size=UDim2.new(1,0,0,32)
    tb.BackgroundColor3=Color3.fromRGB(45,45,50)
    tb.BorderSizePixel=0
    
    local tc=Instance.new("UICorner")
    tc.CornerRadius=UDim.new(0,10)
    tc.Parent=tb
    
    local rb=Instance.new("Frame")
    rb.Name="RedButton"
    rb.Parent=tb
    rb.Size=UDim2.new(0,12,0,12)
    rb.Position=UDim2.new(0,12,0.5,-6)
    rb.BackgroundColor3=Color3.fromRGB(255,95,87)
    rb.BorderSizePixel=0
    
    local rbc=Instance.new("UICorner")
    rbc.CornerRadius=UDim.new(0.5,0)
    rbc.Parent=rb
    
    local yb=Instance.new("Frame")
    yb.Name="YellowButton"
    yb.Parent=tb
    yb.Size=UDim2.new(0,12,0,12)
    yb.Position=UDim2.new(0,32,0.5,-6)
    yb.BackgroundColor3=Color3.fromRGB(255,189,46)
    yb.BorderSizePixel=0
    
    local ybc=Instance.new("UICorner")
    ybc.CornerRadius=UDim.new(0.5,0)
    ybc.Parent=yb
    
    local gb=Instance.new("Frame")
    gb.Name="GreenButton"
    gb.Parent=tb
    gb.Size=UDim2.new(0,12,0,12)
    gb.Position=UDim2.new(0,52,0.5,-6)
    gb.BackgroundColor3=Color3.fromRGB(39,201,63)
    gb.BorderSizePixel=0
    
    local gbc=Instance.new("UICorner")
    gbc.CornerRadius=UDim.new(0.5,0)
    gbc.Parent=gb
    
    local tt=Instance.new("TextLabel")
    tt.Name="Title"
    tt.Parent=tb
    tt.Size=UDim2.new(1,-140,1,0)
    tt.Position=UDim2.new(0,70,0,0)
    tt.BackgroundTransparency=1
    tt.Text=cfg.Title or"Window"
    tt.TextColor3=Color3.fromRGB(200,200,205)
    tt.TextSize=13
    tt.Font=Enum.Font.Gotham
    tt.TextXAlignment=Enum.TextXAlignment.Center
    
    local cf=Instance.new("Frame")
    cf.Name="Content"
    cf.Parent=f
    cf.Size=UDim2.new(1,0,1,-32)
    cf.Position=UDim2.new(0,0,0,32)
    cf.BackgroundTransparency=1
    
    local sb=Instance.new("Frame")
    sb.Name="Sidebar"
    sb.Parent=cf
    sb.Size=UDim2.new(0.35,0,1,0)
    sb.BackgroundColor3=Color3.fromRGB(40,40,45)
    sb.BorderSizePixel=0
    
    local d=Instance.new("Frame")
    d.Name="Divider"
    d.Parent=cf
    d.Size=UDim2.new(0,1,1,0)
    d.Position=UDim2.new(0.35,0,0,0)
    d.BackgroundColor3=Color3.fromRGB(60,60,65)
    d.BorderSizePixel=0
    
    local el=Instance.new("ScrollingFrame")
    el.Name="EventsList"
    el.Parent=sb
    el.Size=UDim2.new(1,0,1,-10)
    el.Position=UDim2.new(0,0,0,5)
    el.BackgroundTransparency=1
    el.ScrollBarThickness=4
    el.ScrollBarImageColor3=Color3.fromRGB(100,100,105)
    el.CanvasSize=UDim2.new(0,0,0,0)
    el.AutomaticCanvasSize=Enum.AutomaticSize.Y
    
    local ll=Instance.new("UIListLayout")
    ll.Parent=el
    ll.Padding=UDim.new(0,1)
    ll.SortOrder=Enum.SortOrder.LayoutOrder
    
    local cp=Instance.new("Frame")
    cp.Name="CodePanel"
    cp.Parent=cf
    cp.Size=UDim2.new(0.65,-1,1,-50)
    cp.Position=UDim2.new(0.35,1,0,0)
    cp.BackgroundColor3=Color3.fromRGB(25,25,30)
    cp.BorderSizePixel=0
    
    local ct=Instance.new("TextLabel")
    ct.Name="CodeText"
    ct.Parent=cp
    ct.Size=UDim2.new(1,-16,1,-16)
    ct.Position=UDim2.new(0,8,0,8)
    ct.BackgroundTransparency=1
    ct.Text="-- Select an event to view code\n\nprint('Welcome to MacUI')"
    ct.TextColor3=Color3.fromRGB(180,180,185)
    ct.TextSize=12
    ct.Font=Enum.Font.Code
    ct.TextXAlignment=Enum.TextXAlignment.Left
    ct.TextYAlignment=Enum.TextYAlignment.Top
    ct.TextWrapped=true
    ct.RichText=true
    
    local bp=Instance.new("Frame")
    bp.Name="ButtonPanel"
    bp.Parent=cf
    bp.Size=UDim2.new(0.65,-1,0,45)
    bp.Position=UDim2.new(0.35,1,1,-45)
    bp.BackgroundColor3=Color3.fromRGB(35,35,40)
    bp.BorderSizePixel=0
    
    local btl=Instance.new("UIListLayout")
    btl.Parent=bp
    btl.FillDirection=Enum.FillDirection.Horizontal
    btl.Padding=UDim.new(0,8)
    btl.SortOrder=Enum.SortOrder.LayoutOrder
    btl.VerticalAlignment=Enum.VerticalAlignment.Center
    
    local btp=Instance.new("UIPadding")
    btp.Parent=bp
    btp.PaddingLeft=UDim.new(0,12)
    btp.PaddingRight=UDim.new(0,12)
    btp.PaddingTop=UDim.new(0,8)
    btp.PaddingBottom=UDim.new(0,8)
    
    self.gui=s
    self.window=f
    self.titleBar=tb
    self.titleText=tt
    self.eventsList=el
    self.codeText=ct
    self.buttonPanel=bp
    
    local function h(btn,hc,oc)
        local cd=Instance.new("TextButton")
        cd.Parent=btn
        cd.Size=UDim2.new(1,0,1,0)
        cd.BackgroundTransparency=1
        cd.Text=""
        
        cd.MouseEnter:Connect(function()
            t:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=hc}):Play()
        end)
        
        cd.MouseLeave:Connect(function()
            t:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=oc}):Play()
        end)
        
        if btn==rb then
            cd.MouseButton1Click:Connect(function()
                self.WindowClosed:Fire()
            end)
        end
    end
    
    h(rb,Color3.fromRGB(255,115,107),Color3.fromRGB(255,95,87))
    h(yb,Color3.fromRGB(255,199,66),Color3.fromRGB(255,189,46))
    h(gb,Color3.fromRGB(59,211,83),Color3.fromRGB(39,201,63))
    
    if cfg.Draggable~=false then
        local dr,ds,sp=false,nil,nil
        
        tb.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                dr=true
                ds=i.Position
                sp=f.Position
            end
        end)
        
        u.InputChanged:Connect(function(i)
            if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
                local delta=i.Position-ds
                f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+delta.X,sp.Y.Scale,sp.Y.Offset+delta.Y)
            end
        end)
        
        u.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                dr=false
            end
        end)
    end
    
    f.Size=UDim2.new(0,0,0,0)
    f.Position=UDim2.new(0.5,0,0.5,0)
    
    return self
end

function w:CreateEventGroup(name,tp)
    if self.EventGroups[name] then return self.EventGroups[name] end
    
    local group={
        name=name,
        type=tp,
        events={},
        expanded=false,
        groupFrame=nil,
        childrenContainer=nil
    }
    
    local gf=Instance.new("Frame")
    gf.Name="EventGroup_"..name
    gf.Size=UDim2.new(1,0,0,24)
    gf.BackgroundColor3=Color3.fromRGB(50,50,55)
    gf.BorderSizePixel=0
    gf.LayoutOrder=1000+#self.eventsList:GetChildren()
    
    local ti=Instance.new("Frame")
    ti.Parent=gf
    ti.Size=UDim2.new(0,3,1,0)
    ti.BackgroundColor3=tp=="RemoteEvent"and Color3.fromRGB(52,199,89)or Color3.fromRGB(255,149,0)
    ti.BorderSizePixel=0
    
    local arrow=Instance.new("TextLabel")
    arrow.Parent=gf
    arrow.Size=UDim2.new(0,12,1,0)
    arrow.Position=UDim2.new(0,8,0,0)
    arrow.BackgroundTransparency=1
    arrow.Text="▶"
    arrow.TextColor3=Color3.fromRGB(150,150,155)
    arrow.TextSize=10
    arrow.Font=Enum.Font.Gotham
    arrow.TextXAlignment=Enum.TextXAlignment.Center
    
    local nl=Instance.new("TextLabel")
    nl.Parent=gf
    nl.Size=UDim2.new(1,-45,1,0)
    nl.Position=UDim2.new(0,25,0,0)
    nl.BackgroundTransparency=1
    nl.Text=name.." ("..tp..")"
    nl.TextColor3=Color3.fromRGB(200,200,205)
    nl.TextSize=12
    nl.Font=Enum.Font.GothamBold
    nl.TextXAlignment=Enum.TextXAlignment.Left
    
    local count=Instance.new("TextLabel")
    count.Parent=gf
    count.Size=UDim2.new(0,30,1,0)
    count.Position=UDim2.new(1,-35,0,0)
    count.BackgroundTransparency=1
    count.Text="0"
    count.TextColor3=Color3.fromRGB(120,120,125)
    count.TextSize=10
    count.Font=Enum.Font.Gotham
    count.TextXAlignment=Enum.TextXAlignment.Right
    
    local cb=Instance.new("TextButton")
    cb.Parent=gf
    cb.Size=UDim2.new(1,0,1,0)
    cb.BackgroundTransparency=1
    cb.Text=""
    
    local cc=Instance.new("Frame")
    cc.Name="ChildrenContainer"
    cc.Size=UDim2.new(1,0,0,0)
    cc.Position=UDim2.new(0,0,1,0)
    cc.BackgroundTransparency=1
    cc.Visible=false
    cc.LayoutOrder=1001+#self.eventsList:GetChildren()
    
    local cl=Instance.new("UIListLayout")
    cl.Parent=cc
    cl.Padding=UDim.new(0,1)
    cl.SortOrder=Enum.SortOrder.LayoutOrder
    
    cb.MouseEnter:Connect(function()
        t:Create(gf,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(60,60,65)}):Play()
    end)
    
    cb.MouseLeave:Connect(function()
        t:Create(gf,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(50,50,55)}):Play()
    end)
    
    cb.MouseButton1Click:Connect(function()
        group.expanded=not group.expanded
        
        if group.expanded then
            arrow.Text="▼"
            cc.Visible=true
            local targetSize=UDim2.new(1,0,0,#group.events*25)
            cc.Size=UDim2.new(1,0,0,0)
            t:Create(cc,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=targetSize}):Play()
        else
            arrow.Text="▶"
            local tw=t:Create(cc,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=UDim2.new(1,0,0,0)})
            tw:Play()
            tw.Completed:Connect(function()
                cc.Visible=false
            end)
        end
    end)
    
    group.groupFrame=gf
    group.childrenContainer=cc
    group.countLabel=count
    group.arrow=arrow
    
    gf.Parent=self.eventsList
    cc.Parent=self.eventsList
    
    self.EventGroups[name]=group
    return group
end

function w:AddEvent(n,tp,cd)
    local fullKey=n.."_"..tick()
    if self.Events[fullKey] then return end
    
    local group=self:CreateEventGroup(n,tp)
    
    local ev={name=n,type=tp,code=cd,fullKey=fullKey,group=group}
    self.Events[fullKey]=ev
    table.insert(group.events,ev)
    
    group.countLabel.Text=tostring(#group.events)
    
    local i=Instance.new("Frame")
    i.Name="EventItem_"..fullKey
    i.Size=UDim2.new(1,0,0,24)
    i.BackgroundColor3=Color3.fromRGB(35,35,40)
    i.BorderSizePixel=0
    i.LayoutOrder=#group.events
    
    local indent=Instance.new("Frame")
    indent.Parent=i
    indent.Size=UDim2.new(0,20,1,0)
    indent.BackgroundTransparency=1
    
    local ti=Instance.new("Frame")
    ti.Parent=i
    ti.Size=UDim2.new(0,2,0.7,0)
    ti.Position=UDim2.new(0,20,0.15,0)
    ti.BackgroundColor3=tp=="RemoteEvent"and Color3.fromRGB(52,199,89)or Color3.fromRGB(255,149,0)
    ti.BorderSizePixel=0
    
    local time=os.date("%H:%M:%S")
    local nl=Instance.new("TextLabel")
    nl.Parent=i
    nl.Size=UDim2.new(1,-30,1,0)
    nl.Position=UDim2.new(0,25,0,0)
    nl.BackgroundTransparency=1
    nl.Text=time
    nl.TextColor3=Color3.fromRGB(180,180,185)
    nl.TextSize=11
    nl.Font=Enum.Font.Code
    nl.TextXAlignment=Enum.TextXAlignment.Left
    
    local cb=Instance.new("TextButton")
    cb.Parent=i
    cb.Size=UDim2.new(1,0,1,0)
    cb.BackgroundTransparency=1
    cb.Text=""
    
    cb.MouseEnter:Connect(function()
        t:Create(i,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(45,45,50)}):Play()
    end)
    
    cb.MouseLeave:Connect(function()
        if i:GetAttribute("Selected")~=true then
            t:Create(i,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(35,35,40)}):Play()
        end
    end)
    
    cb.MouseButton1Click:Connect(function()
        for gName,g in pairs(self.EventGroups)do
            for _,event in pairs(g.events)do
                if event.ui then
                    event.ui:SetAttribute("Selected",false)
                    event.ui.BackgroundColor3=Color3.fromRGB(35,35,40)
                end
            end
        end
        
        i:SetAttribute("Selected",true)
        i.BackgroundColor3=Color3.fromRGB(0,122,255)
        self.codeText.Text=applySyntaxHighlighting(cd)
        
        self.EventClicked:Fire(n,tp,cd)
        
        local sc=t:Create(nl,TweenInfo.new(0.08),{TextSize=12})
        sc:Play()
        sc.Completed:Connect(function()
            t:Create(nl,TweenInfo.new(0.08),{TextSize=11}):Play()
        end)
    end)
    
    ev.ui=i
    i.Parent=group.childrenContainer
    
    if group.expanded then
        group.childrenContainer.Size=UDim2.new(1,0,0,#group.events*25)
    end
end

function w:RemoveEvent(n,fullKey)
    if fullKey and self.Events[fullKey] then
        local ev=self.Events[fullKey]
        local group=ev.group
        
        if ev.ui then
            ev.ui:Destroy()
        end
        
        for i,event in ipairs(group.events)do
            if event.fullKey==fullKey then
                table.remove(group.events,i)
                break
            end
        end
        
        group.countLabel.Text=tostring(#group.events)
        
        if #group.events==0 then
            if group.groupFrame then
                group.groupFrame:Destroy()
            end
            if group.childrenContainer then
                group.childrenContainer:Destroy()
            end
            self.EventGroups[n]=nil
        elseif group.expanded then
            group.childrenContainer.Size=UDim2.new(1,0,0,#group.events*25)
        end
        
        self.Events[fullKey]=nil
    end
end

function w:SetCode(cd)
    self.codeText.Text=applySyntaxHighlighting(cd)
end

function w:AddButton(name,callback)
    if self.Buttons[name] then return end
    
    local btn=Instance.new("TextButton")
    btn.Name=name.."Button"
    btn.Parent=self.buttonPanel
    btn.Size=UDim2.new(0,80,0,28)
    btn.BackgroundColor3=Color3.fromRGB(60,60,65)
    btn.BorderSizePixel=0
    btn.Text=name
    btn.TextColor3=Color3.fromRGB(200,200,205)
    btn.TextSize=12
    btn.Font=Enum.Font.Gotham
    btn.AutoButtonColor=false
    
    local bc=Instance.new("UICorner")
    bc.CornerRadius=UDim.new(0,6)
    bc.Parent=btn
    
    btn.MouseEnter:Connect(function()
        t:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(70,70,75)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        t:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(60,60,65)}):Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        t:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(50,50,55)}):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        t:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(70,70,75)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    self.Buttons[name]=btn
end

function w:RemoveButton(name)
    if not self.Buttons[name] then return end
    
    self.Buttons[name]:Destroy()
    self.Buttons[name]=nil
end

function w:Show()
    local originalSize=self.window.Size
    local originalPos=self.window.Position
    
    self.window.Size=UDim2.new(0,0,0,0)
    self.window.Position=UDim2.new(0.5,0,0.5,0)
    
    local tw=t:Create(self.window,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=originalSize,
        Position=originalPos
    })
    tw:Play()
end

function w:Hide()
    local tw=t:Create(self.window,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0)
    })
    tw:Play()
end

function w:Destroy()
    if self.gui then
        self.gui:Destroy()
    end
    if self.EventClicked then
        self.EventClicked:Destroy()
    end
    if self.WindowClosed then
        self.WindowClosed:Destroy()
    end
end

function w:SetTitle(title)
    self.titleText.Text=title
end

return m