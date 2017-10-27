-- Big thanks to Jawicna, Funkeln and Tinka for testing it with me in-game
-- Binding Variables






BINDING_HEADER_WHISPERFILTER = "WhisperFilter";
BINDING_NAME_WFSHOWEDITBOX = "Show Editbox";
local function RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

local function RGBToHex(r, g, b)
    r = r <= 255 and r >= 0 and r or 0
    g = g <= 255 and g >= 0 and g or 0
    b = b <= 255 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r, g, b)
end

function len(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local backup
if type(ChatFrame_MessageEventHandler) ~= "nil" then
    backup = ChatFrame_MessageEventHandler
elseif type(ChatFrame_OnEvent) ~= "nil" then
    backup = ChatFrame_OnEvent
end

local _ChatFrame_OpenChat = ChatFrame_OpenChat
local _ChatEdit_OnEnterPressed = ChatEdit_OnEnterPressed

local hooked = false
local hookedhook = false
local found = false
local whisp = "\124cffff7eff\124h[W From] [Psychi]: "
local hook = false
local hookbak = nil
local PlayerName = nil
local WhoFound = false


local NUMBER_OF_CHATBOXES = {}
ChatFrames = {
    ChatFrame1, ChatFrame2, ChatFrame3, ChatFrame4, ChatFrame5, ChatFrame6, ChatFrame7
}


if GetBuildInfo() == "2.4.3" then
    string.gfind = string.gmatch
end


local temp



local total = 0
function timer()
    total = total + arg1
    if WhoFound then
        if debug then
            DEFAULT_CHAT_FRAME:AddMessage("Server responded fast enough!")
        end
        k:SetScript("OnUpdate", nil)
        total = 0
    end
    if total >= 2 then
        if debug then
            DEFAULT_CHAT_FRAME:AddMessage("Server didn't respond fast enough!")
        end
        k:SetScript("OnUpdate", nil)
        total = 0
        AddFriend(PlayerName)
    end
end

if not k then
    if debug then
        DEFAULT_CHAT_FRAME:AddMessage("CREATING FRAME")
    end
    k = CreateFrame("frame")
    k:SetScript("OnUpdate", nil)
end


local counter = 0
local timerLock = 0
local firstLock = false

local f = CreateFrame("Frame")

local function onevent()
    if ignoreUntilLvl == nil then
        ignoreUntilLvl = 5
    end
    --f:UnregisterEvent("ADDON_LOADED")
    --f:UnregisterEvent("PLAYER_LOGIN")
    if arg1 ~= nil then
        -- DEFAULT_CHAT_FRAME:AddMessage(event.." "..arg1)
        if arg1 == "WIM" then
            if WIM_ChatFrame_OnEvent_orig ~= nil or WIM_ChatFrame_MessageEventHandler_orig ~= nil then
                DEFAULT_CHAT_FRAME:AddMessage(whisp.."WIM hook detected! Changing behaviour...")
                hook = true
                WIM_Core:UnregisterEvent("CHAT_MSG_WHISPER")
                WIM_Core:UnregisterEvent("CHAT_MSG_WHISPER_INFORM")
                
                --WIM_ChatFrame_OnEvent = ChatFilter
                if type(ChatFrame_MessageEventHandler) ~= "nil" then
                    hookbak = ChatFrame_MessageEventHandler
                    ChatFrame_MessageEventHandler = ChatFilter
                elseif type(ChatFrame_OnEvent) ~= "nil" then
                    hookbak = ChatFrame_OnEvent
                    ChatFrame_OnEvent = ChatFilter
                end
                if WIMWhoDisabled then
                    if debug then 
                        DEFAULT_CHAT_FRAME:AddMessage("WIM Who - DISABLED")
                    end
                    WIM_SendWho = function () end
                else
                    if debug then 
                        DEFAULT_CHAT_FRAME:AddMessage("WIM Who - ENABLED")
                    end
                    WIM_SendWho = function (name)
                        WIM_Windows[name].waiting_who = true;
                        SetWhoToUI(1);
                        SendWho('n-"'..name..'"')
                    end
                end
            end
        elseif arg1 == "WhisperFilter" then

            if ChannelInfo == nil then
                ChannelInfo = {}
                ChannelInfo['SYSTEM'] = {255,255,0, nil }
                ChannelInfo['SAY'] = {255,255,255, "[S]" }
                ChannelInfo['PARTY'] = {170,170,255, "[P]" }
                ChannelInfo['RAID'] = {255,127,0, "[R]" }
                ChannelInfo['GUILD'] = {64,255,64, "[G]" }
                ChannelInfo['OFFICER'] = {64,192,64, "[O]" }
                ChannelInfo['YELL'] = {255,64,64, "[Y]" }
                ChannelInfo['WHISPER'] = {255,128,255, "[W From]" }
                ChannelInfo['WHISPER_FOREIGN'] = {255,128,255, "[W]" }
                ChannelInfo['WHISPER_INFORM'] = {255,128,255, "[W To]" }
                ChannelInfo['EMOTE'] = {255,128,64, nil }
                ChannelInfo['TEXT_EMOTE'] = {255,128,64, nil }
                ChannelInfo['MONSTER_SAY'] = {255,255,159, nil }
                ChannelInfo['MONSTER_PARTY'] = {170,170,255, nil }
                ChannelInfo['MONSTER_YELL'] = {255,64,64, nil }
                ChannelInfo['MONSTER_WHISPER'] = {255,181,235, nil }
                ChannelInfo['MONSTER_EMOTE'] = {255,128,64, nil }
                ChannelInfo['CHANNEL'] = {255,192,192, nil }
                ChannelInfo['CHANNEL_JOIN'] = {192,128,128, nil }
                ChannelInfo['CHANNEL_LEAVE'] = {192,128,128, nil }
                ChannelInfo['CHANNEL_LIST'] = {192,128,128, nil }
                ChannelInfo['CHANNEL_NOTICE'] = {192,192,192, nil }
                ChannelInfo['CHANNEL_NOTICE_USER'] = {192,192,192, nil }
                ChannelInfo['AFK'] = {255,128,255, nil }
                ChannelInfo['DND'] = {255,128,255, nil }
                ChannelInfo['IGNORED'] = {255,0,0, nil }
                ChannelInfo['SKILL'] = {85,85,255, nil }
                ChannelInfo['LOOT'] = {0,170,0, nil }
                ChannelInfo['MONEY'] = {255,255,0, nil }
                ChannelInfo['OPENING'] = {128,128,255, nil }
                ChannelInfo['TRADESKILLS'] = {255,255,255, nil }
                ChannelInfo['PET_INFO'] = {128,128,255, nil }
                ChannelInfo['COMBAT_MISC_INFO'] = {128,128,255, nil }
                ChannelInfo['COMBAT_XP_GAIN'] = {111,111,255, nil }
                ChannelInfo['COMBAT_HONOR_GAIN'] = {224,202,10, nil }
                ChannelInfo['COMBAT_FACTION_CHANGE'] = {128,128,255, nil }
                ChannelInfo['BG_SYSTEM_NEUTRAL'] = {255,120,10, nil }
                ChannelInfo['BG_SYSTEM_ALLIANCE'] = {0,174,239, nil }
                ChannelInfo['BG_SYSTEM_HORDE'] = {255,0,0, nil }
                ChannelInfo['RAID_LEADER'] = {255,72,9, "[RL]" }
                ChannelInfo['RAID_WARNING'] = {255,72,0, "[RW]" }
                ChannelInfo['RAID_BOSS_EMOTE'] = {255,221,0, nil }
                ChannelInfo['RAID_BOSS_WHISPER'] = {255,221,0, nil }
                ChannelInfo['FILTERED'] = {255,0,0, nil }
                ChannelInfo['BATTLEGROUND'] = {255,127,0, "[BG]" }
                ChannelInfo['BATTLEGROUND_LEADER'] = {255,219,183, "[BL]" }
                ChannelInfo['RESTRICTED'] = {255,0,0, nil }
                ChannelInfo['BATTLENET'] = {255,255,255, nil }
                ChannelInfo['ACHIEVEMENT'] = {255,255,0, nil }
                ChannelInfo['GUILD_ACHIEVEMENT'] = {64,255,64, nil }
                ChannelInfo['ARENA_POINTS'] = {255,255,255, nil }
                ChannelInfo['PARTY_LEADER'] = {118,200,255, "[PL]" }
                ChannelInfo['TARGETICONS'] = {255,255,0, nil }
                ChannelInfo['BN_WHISPER'] = {0,255,246, nil }
                ChannelInfo['BN_WHISPER_INFORM'] = {0,255,246, nil }
                ChannelInfo['BN_CONVERSATION'] = {0,177,240, nil }
                ChannelInfo['BN_CONVERSATION_NOTICE'] = {0,177,240, nil }
                ChannelInfo['BN_CONVERSATION_LIST'] = {0,177,240, nil }
                ChannelInfo['BN_INLINE_TOAST_ALERT'] = {130,197,255, nil }
                ChannelInfo['BN_INLINE_TOAST_BROADCAST'] = {130,197,255, nil }
                ChannelInfo['BN_INLINE_TOAST_BROADCAST_INFORM'] = {130,197,255, nil }
                ChannelInfo['BN_INLINE_TOAST_CONVERSATION'] = {130,197,255, nil }
                ChannelInfo['COMBAT_GUILD_XP_GAIN'] = {111,111,255, nil }
                ChannelInfo['CHANNEL1'] = {255,192,192, "[1]" }
                ChannelInfo['CHANNEL2'] = {255,192,192, "[2]" }
                ChannelInfo['CHANNEL3'] = {255,192,192, "[3]" }
                ChannelInfo['CHANNEL4'] = {255,192,192, "[4]" }
                ChannelInfo['CHANNEL5'] = {255,192,192, "[5]" }
                ChannelInfo['CHANNEL6'] = {255,192,192, "[6]" }
                ChannelInfo['CHANNEL7'] = {255,192,192, "[7]" }
                ChannelInfo['CHANNEL8'] = {255,192,192, "[8]" }
                ChannelInfo['CHANNEL9'] = {255,192,192, "[9]" }
                ChannelInfo['CHANNEL10'] = {255,192,192, "[10]" }
            end
                



            if WFCopyChatFontSize == nil then
                WFCopyChatFontSize = 11
            end

            if chatBoxes == nil then
                chatBoxes = { {}, {}, {}, {} , {} , {} , {} }
            end
 

            local f2 = CreateFrame("Frame")
            f2:RegisterEvent("PLAYER_LOGOUT")
            f2:SetScript("OnEvent", function ()
                for i=1,table.getn(chatBoxes) do
                    if strlen(chatBoxes[i][1]) > 0 and not string.find(chatBoxes[i][1],"History of: ") then
                        table.insert(chatBoxes[i],"History of: "..date("%m/%d/%y %H:%M:%S").."\n")
                    end
                end
            end)

            if WFselectedCopyBox == nil then
                WFselectedCopyBox = DEFAULT_CHAT_FRAME:GetID()
            end
            if tableLimit == nil then
                tableLimit = 1000
            end
            if tonumber(tableLimit) then
                tableLimit = tonumber(tableLimit)
            else
                tableLimit = 1000
            end

            if WFHighlightDisabled == nil then
                WFHighlightDisabled = true
            end
            if WFHighlightLock == nil then
                WFHighlightLock = false
                firstLock = true
            end
            if WFCopyChatDisabled == nil then
                WFCopyChatDisabled = true       
            end

            if WFstickyAllDisabled == nil then
                WFstickyAllDisabled = true
            end


            local frameN = CreateFrame("ScrollingMessageFrame", "DragFrame2", UIParent)
            frameN:SetMovable(true)
            frameN:EnableMouse(true)
            frameN:SetResizable(true)
            --frameN:SetInsertMode("BOTTOM")
            frameN:SetFrameStrata("HIGH")
            frameN:SetToplevel(true)
            frameN:SetJustifyV("BOTTOM")
            frameN:SetClampedToScreen(true) 
            frameN:SetFont("Fonts\\FRIZQT__.TTF", 16)
            frameN:SetTextColor(1, 1, 1, 1) -- default color
            frameN:SetJustifyH("CENTER")
            frameN:Show()


            if WFHighlightPosX == nil or WFHighlightPosY == nil then
                frameN:SetPoint("CENTER", UIParent, "TOP", 0, 0) 
            else
                frameN:SetPoint("CENTER", UIParent, "TOP", WFHighlightPosX, WFHighlightPosY) 
            end

            if WFHighlightSizeW == nil or WFHighlightSizeH == nil then
                frameN:SetWidth(400); frameN:SetHeight(200);
            else
                frameN:SetWidth(WFHighlightSizeW); frameN:SetHeight(WFHighlightSizeH);
            end
            
            

            local tex = frameN:CreateTexture("ARTWORK");
            tex:SetAllPoints();
            tex:SetTexture(0, 0, 0); tex:SetAlpha(0.5);

            

            frameN:SetScript("OnMouseDown", function () 
                counter = counter + 1
                local temp = GetTime()
                temp = temp - timerLock
                if temp < 0.5 and counter == 2 then
                    if WFHighlightLock then
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("CLICKED FAST ENOUGH TO UNLOCK. "..temp.." sec")
                        end

                        frameN:EnableMouse(true)
                        tex:SetAlpha(0.5)
                        WFHighlightLock = false 
                    else
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("CLICKED FAST ENOUGH TO LOCK. "..temp.." sec ")
                        end
                        frameN:EnableMouse(false)
                        tex:SetAlpha(0)
                        WFHighlightLock = true
                        
                    end
                    counter = 0
                    timerLock = 0
                    return
                elseif counter == 1 then
                    if debug then
                        DEFAULT_CHAT_FRAME:AddMessage("TIMER STARTED")
                    end
                    timerLock = GetTime()
                else
                    if debug then
                        DEFAULT_CHAT_FRAME:AddMessage("TIMER END. NOT ENOUGH CLICKS IN TIME")
                    end
                    counter = 0
                    timerLock = 0
                end

            end)
            frameN:RegisterForDrag("LeftButton","RightButton");
            frameN:SetScript("OnDragStart", function()
                if not WFHighlightLock then
                    if arg1 == "LeftButton" then
                        this:StartMoving()
                        this.isMoving = true
                        this.hasMoved = false
                    elseif arg1 == "RightButton" then
                        this:StartSizing()
                        this.isMoving = true
                        this.hasMoved = false
                    end
                    if debug then
                        DEFAULT_CHAT_FRAME:AddMessage("DRAG START")
                    end
                end
            end)

            frameN:SetScript("OnDragStop", function()
                if not WFHighlightLock then
                    this:StopMovingOrSizing();
                    this.isMoving = false;
                end
            end)



            local frame  = CreateFrame("Frame", "WhisperFilterFrame", UIParent)
            frame.width  = 500
            frame.height = 254
            frame:SetFrameStrata("DIALOG")
            frame:SetWidth(frame.width)
            frame:SetHeight(frame.height)
            frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            frame:SetBackdrop({
            bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile     = true,
            tileSize = 32,
            edgeSize = 32,
            insets   = { left = 8, right = 8, top = 8, bottom = 8 }
            })
            frame:SetBackdropColor(0, 0, 0, 1)
            frame:EnableMouse(true)
            frame:EnableMouseWheel(true)
            frame:Hide()


            --frame:SetMovable(true)
            --frame:SetResizable(enable)
            --frame:SetMinResize(100, 100)
            --frame:RegisterForDrag("LeftButton")
            --frame:SetScript("OnDragStart", frame.StartMoving)
            --frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

            --tinsert(UISpecialFrames, "WhisperFilterFrame")

            -- Close button


            local closeButton = CreateFrame("Button", "WhisperFilterButton", frame, "UIPanelButtonTemplate")
            closeButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",-10, 10)
            closeButton:SetHeight(25)
            closeButton:SetWidth(70)
            closeButton:SetText('Close')
            closeButton:SetScript("OnClick", function()
                showEditbox(WFselectedCopyBox)
            end)

            
            for i=1,7 do
                NUMBER_OF_CHATBOXES[i] = i
            end

            function StickyChatTypeOpen(text, chatFrame)
                if not WFstickyAllDisabled then
                    if ( not chatFrame ) then
                        chatFrame = DEFAULT_CHAT_FRAME;
                    end

                    chatFrame.editBox:Show();
                    chatFrame.editBox.setText = 1;
                    chatFrame.editBox.text = text;
                    local type
                    if chatFrame.editBox.GetAttribute ~= nil then
                        type = chatFrame.editBox:GetAttribute("chatType")
                    else
                        type = chatFrame.editBox.chatType
                    end

                    if chatFrame.editBox.SetAttribute ~= nil then
                        chatFrame.editBox:SetAttribute("stickyType", type)
                    else
                        chatFrame.editBox.stickyType = type
                    end
                    
                    ChatEdit_UpdateHeader(chatFrame.editBox)
                else
                    _ChatFrame_OpenChat(text, chatFrame)
                end
            end

            ChatFrame_OpenChat = StickyChatTypeOpen

            function StickyChatTypeSend()
                if not WFstickyAllDisabled then
                    ChatEdit_SendText(this, 1);
                    local type
                    if this.GetAttribute ~= nil then
                        type = this:GetAttribute("chatType")
                    else
                        type = this.chatType
                    end

                    if this.SetAttribute ~= nil then
                        this:SetAttribute("stickyType", type)
                    else
                        this.stickyType = type;
                    end

                    ChatEdit_OnEscapePressed(this)
                else
                    _ChatEdit_OnEnterPressed()
                end
            end

            ChatEdit_OnEnterPressed = StickyChatTypeSend
            
            
            -- DEFAULT_CHAT_FRAME:AddMessage("NUMBER OF CHATS: "..table.getn(NUMBER_OF_CHATBOXES))
            local chatBoxesButtons = {}
            for i=1,table.getn(NUMBER_OF_CHATBOXES) do
                local name, fontSize, r, g, b, alpha, shown, locked = GetChatWindowInfo(i);
                if name ~= nil then
                    -- DEFAULT_CHAT_FRAME:AddMessage(tostring(name))
                    local chatBoxesButton = CreateFrame("Button", "WhisperFilterButton", frame, "UIPanelButtonTemplate")
                    chatBoxesButtons[i] = chatBoxesButton
                    local temp = i - 1
                    chatBoxesButtons[i]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT",25*temp+12, 10)
                    chatBoxesButtons[i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
                    chatBoxesButtons[i]:SetHeight(25)
                    chatBoxesButtons[i]:SetWidth(25)
                    chatBoxesButtons[i]:SetID(i)
                    chatBoxesButtons[i]:SetText(i)
                    chatBoxesButtons[i]:SetAlpha(0.5)
                    chatBoxesButtons[i]:SetScript("OnClick", function()
                        WFselectedCopyBox = this:GetID()
                        showEditbox(WFselectedCopyBox, true)
                    end)

                end


            end
            local name, fontSize, r, g, b, alpha, shown, locked = GetChatWindowInfo(WFselectedCopyBox);

            local boxName = CreateFrame("SimpleHTML", "WhisperFilterBoxName", frame)
            boxName:SetPoint("BOTTOM", frame, "CENTER",20, frame.height*(-0.5)+2)
            boxName:SetHeight(25)
            boxName:SetWidth(strlen(name)*10)
            boxName:SetFont("Fonts\\FRIZQT__.TTF", 10)
            boxName:SetJustifyH("CENTER")
            boxName:SetJustifyV("MIDDLE")
            boxName:SetText(name)


            -- ScrollingMessageFrame
            local scroller = CreateFrame("ScrollFrame","WhisperFilterScroller",frame,"FauxScrollFrameTemplate")
            scroller:SetPoint("TOPLEFT", frame, "TOPLEFT",30,-30)
            scroller:SetPoint("RIGHT", frame, "RIGHT",-35,0)
            scroller:SetPoint("BOTTOM", closeButton, "TOP",0,0)
            --scroller:SetVerticalScroll(tableLimit) 




            local messageFrame = CreateFrame("EditBox", nil, scroller)
            messageFrame:SetPoint("BOTTOM", 0, 0)
            messageFrame:SetWidth(frame.width - 70)
            messageFrame:SetFont("Fonts\\FRIZQT__.TTF", WFCopyChatFontSize)
            messageFrame:SetTextColor(1, 1, 1, 1) -- default color
            messageFrame:SetJustifyH("LEFT")
            --messageFrame:SetMaxLetters(0)
            messageFrame:SetAutoFocus(false)
            messageFrame:SetMultiLine(true)
            frame.messageFrame = messageFrame

            function setFrameSize(frame, fontSize)
                frameSize = frame:GetHeight()/fontSize
                if frameSize < 18 then
                    frameSize = 18
                end

                FauxScrollFrame_Update(scroller,  frameSize, 17, fontSize)
            end

            messageFrame:SetScript("OnEscapePressed",function()
                if debug then
                    DEFAULT_CHAT_FRAME:AddMessage("ESC PRESSED")
                end
                showEditbox(WFselectedCopyBox)
            end)

            scroller:SetScript("OnScrollRangeChanged",function()
                --scroller:SetVerticalScroll(scroller:GetVerticalScrollRange() )
            end)

            messageFrame:SetScript("OnTextChanged",function(self)
                setFrameSize(messageFrame, WFCopyChatFontSize)
                scroller:SetVerticalScroll(scroller:GetVerticalScrollRange() )
            end)



            scroller:SetScrollChild(messageFrame)

            local showedBox = false
            function showEditbox(frameIDs,changebox)
                if not WFCopyChatDisabled then 
                    if frame:IsVisible() and changebox == nil then
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("Hiding box")
                        end
                        showedBox = false
                        messageFrame:SetText("")
                        frame:Hide()
                    else
                        messageFrame:SetText("")

                        for j=1,table.getn(NUMBER_OF_CHATBOXES) do
                            local name, fontSize, r, g, b, alpha, shown, locked = GetChatWindowInfo(j);
                            if name ~= nil then
                                    chatBoxesButtons[j]:Show()
                                    
                                    
                                    chatBoxesButtons[j]:SetAlpha(0.5)

                            end
                        end
                        local name, fontSize, r, g, b, alpha, shown, locked = GetChatWindowInfo(WFselectedCopyBox);
                        chatBoxesButtons[WFselectedCopyBox]:SetAlpha(1)
                        boxName:SetWidth(150)
                        boxName:SetText(name)
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("Showing box with table ID: "..frameIDs)
                        end
                        showedBox = true
                        local length = 0
                        local tableSize = table.getn(chatBoxes[frameIDs]) 
                        if tableSize >= tableLimit then
                            tableSize = tableLimit
                        end
                        local str = ""
                        if GetBuildInfo() == "1.12.1" then
                            local size = len(chatBoxes[frameIDs])
                            for i=1,size do
                                str = str..chatBoxes[frameIDs][size-i+1].."\n"
                            end
                            
                        else
                            str = table.concat(chatBoxes[frameIDs],"\n")
                        end

                        messageFrame:Insert(str)
                        setFrameSize(messageFrame, WFCopyChatFontSize)
                        
                        
                        frame:Show()
                    end
                end
            end

            --[[
            scroller:SetScript("OnUpdate", function()
                if not WFCopyChatDisabled then 
                    frameSize = messageFrame:GetHeight()/WFCopyChatFontSize
                        if frameSize < 18 then
                            frameSize = 18
                        end
                    FauxScrollFrame_Update(scroller,  frameSize, 17, WFCopyChatFontSize)
                end
            end)
            ]]
            local openButtons = {}
            local textures = {}
            local textures2 = {}
        
            for i=1,table.getn(NUMBER_OF_CHATBOXES) do
                local openButton = CreateFrame("Button", "WhisperFilterOpenButton"..i, getglobal('ChatFrame'..i))
                openButtons[i] = openButton
                openButtons[i]:SetPoint("BOTTOMRIGHT", getglobal('ChatFrame'..i), "BOTTOMRIGHT",0, 0)
                openButtons[i]:SetHeight(25)
                openButtons[i]:SetBackdropColor(0,0,0,0.5)
                openButtons[i]:SetWidth(25)
                openButtons[i]:SetMovable(true)
                openButtons[i]:EnableMouse(true)
                openButtons[i]:SetResizable(true)

                local texture = openButtons[i]:CreateTexture(nil, "BACKGROUND")
                textures[i] = texture
                textures[i]:SetTexture("Interface\\AddOns\\WhisperFilter\\chatcopy")
                
                if not WFCopyChatDisabled then
                    textures[i]:SetAlpha(0.3)
                else
                    textures[i]:SetAlpha(0)
                end
                textures[i]:SetAllPoints(openButtons[i])



                local texture2 = openButtons[i]:CreateTexture(nil, "HIGHLIGHT")
                textures2[i] = texture2
                if not WFCopyChatDisabled then
                    textures2[i]:SetAlpha(1)
                else
                    textures2[i]:SetAlpha(0)
                end
                textures2[i]:SetTexture("Interface\\AddOns\\WhisperFilter\\chatcopy2")
                textures2[i]:SetAllPoints(openButtons[i])

                openButtons[i]:SetScript("OnClick", function()
                    showEditbox(WFselectedCopyBox)
                end)



                openButtons[i]:RegisterForDrag("LeftButton","RightButton");
                openButtons[i]:SetScript("OnDragStart", function()
                    if arg1 == "LeftButton" then
                        this:StartMoving()
                        this.isMoving = true
                        this.hasMoved = false
                    elseif arg1 == "RightButton" then
                        this:StartSizing()
                        this.isMoving = true
                        this.hasMoved = false
                    end
                    if debug then
                        DEFAULT_CHAT_FRAME:AddMessage("DRAG START")
                    end
                end)

                openButtons[i]:SetScript("OnDragStop", function()
                    this:StopMovingOrSizing();
                    this.isMoving = false;
                end)
            end

            


            DEFAULT_CHAT_FRAME:AddMessage(whisp..arg1.."loaded just for you. <3")
            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Filter set to level: "..ignoreUntilLvl)
        
            if WFHighlightDisabled or WFHighlightLock then
                frameN:EnableMouse(false)
                tex:SetAlpha(0)
                WFHighlightLock = true
            else
                frameN:EnableMouse(true)
                tex:SetAlpha(0.5)
                WFHighlightLock = false     
            end
            
            if WFmute == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFmute = false
            end
            if WFblacklistUIErrorDisabled == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFblacklistUIErrorDisabled = false
            end
            if WFblacklistUIError == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFblacklistUIError = {}
            end
            if WFwhitelist == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFwhitelist = {}
            end
            if WFblacklist == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFblacklist = {}
            end
            if WFignoreDisabled == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFignoreDisabled = false
            end
            if WIMWhoDisabled == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WIMWhoDisabled = false
            end
            if WFignoreDisabledAll == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFignoreDisabledAll = false
            end
            if WFClinkDisabled == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFClinkDisabled = false
            end
            
            if WFblacklistPhrasesDisabled == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFblacklistPhrasesDisabled = false
            end
            

            if WFblacklistPhrases == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFblacklistPhrases = {}
            end
            if WFHighlightlist == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFHighlightlist = {}
            end

            if WFautoinvDisabled == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                WFautoinvDisabled = true
            end
            
            if LootList == nil then
                -- DEFAULT_CHAT_FRAME:AddMessage("TABLE LOADED")
                LootList = {}
            end

            if debug == nil then
                debug = false
            end

            if WFGuildBlock == nil then
                WFGuildBlock = false
            end


            local guildblock = CreateFrame("Frame")
            guildblock:RegisterEvent('GUILD_INVITE_REQUEST')
            guildblock:SetScript("OnEvent", function ()
                if event == "GUILD_INVITE_REQUEST" and WFGuildBlock then 
                    StaticPopup_Hide("GUILD_INVITE");
                    DeclineGuild();
                    if debug then 
                        DEFAULT_CHAT_FRAME:AddMessage("Guild invite declined "..arg2)
                    end
                end
            end)

            local winnerColor = "\124cff"..RGBToHex(ChannelInfo["SYSTEM"][1],ChannelInfo["SYSTEM"][2],ChannelInfo["SYSTEM"][3]).."\124h"
            local defaultColor = "ffffff"
            local lootColor = "\124cff"..RGBToHex(ChannelInfo["LOOT"][1],ChannelInfo["LOOT"][2],ChannelInfo["LOOT"][3]).."\124h"
            
            local LootTimerTable = {}
            local LootFilter = CreateFrame("Frame")
            LootFilter:RegisterEvent("START_LOOT_ROLL");
            LootFilter:RegisterEvent("CHAT_MSG_LOOT");
            
            function progressRollInfo(tableSize, timer, nextTimer)
                if WFLootFilterDisabled then
                    LootTimerTable[tableSize][1]:SetScript("OnUpdate",nil)
                    return
                end
                local id = 0
                for i=1,tableSize do
                    if LootTimerTable[i][1] == this then
                        id = LootTimerTable[i][2]
                        -- DEFAULT_CHAT_FRAME:AddMessage("ID: "..id)
                        break
                    end
                end
                
                local tableID
                for i=1,table.getn(LootList) do
                    if LootList[i][1] == id then
                        tableID = i
                        -- DEFAULT_CHAT_FRAME:AddMessage("TABLE ID: "..tableID)
                        break
                    end
                end

                
                --DEFAULT_CHAT_FRAME:AddMessage("Roll time on item  expires in "..time)

                if GetLootRollTimeLeft(id) < timer  then
                    if not LootList[tableID]["finished"] then
                        local texture, name, count, quality = GetLootRollItemInfo(id)
                        local numOfRollers = table.getn(LootList[tableID][12]) + table.getn(LootList[tableID][13]) + table.getn(LootList[tableID][14])
                        
                        local msg = lootColor.." - Current rolls: "..numOfRollers.." - "..LootList[tableID][2]
                        

                        if LootList[tableID].duplicates > 0 then
                            msg = msg.." + "..LootList[tableID].duplicates
                        end
                        DEFAULT_CHAT_FRAME:AddMessage(msg)
                            -- DEFAULT_CHAT_FRAME:AddMessage(LootList[i][1].." vs "..id)
                            
                        local TypeTable = {{"Need",12},{"Greed",13},{"Pass",14}}
                        for p=1,table.getn(TypeTable) do
                            local temp
                            -- DEFAULT_CHAT_FRAME:AddMessage("TABLE SIZE: "..table.getn(LootList[tableID][TypeTable[p][2]]))
                            for j=1,table.getn(LootList[tableID][TypeTable[p][2]]) do
                                if temp == nil then
                                    temp = LootList[tableID][TypeTable[p][2]][j]
                                else
                                    temp = temp..", "..LootList[tableID][TypeTable[p][2]][j]
                                end
                                numOfRollers = numOfRollers + 1
                            end
                            if temp ~= nil then
                                DEFAULT_CHAT_FRAME:AddMessage(lootColor..TypeTable[p][1]..": "..temp)
                            end
                        end
                    end
                    if nextTimer == nil then
                        LootTimerTable[tableSize][1]:SetScript("OnUpdate",nil)
                    else
                        LootTimerTable[tableSize][1]:SetScript("OnUpdate", function () 
                            progressRollInfo(tableSize, nextTimer, nil)
                        end)
                    end
                    return
                end                                     
            end

            LootFilter:SetScript("OnEvent", function ()
                --DEFAULT_CHAT_FRAME:AddMessage(arg1)
                if WFLootFilterDisabled then
                    return
                end
                if event == "START_LOOT_ROLL" then 
                    local itemLink = GetLootRollItemLink(arg1)
                    if debug then 
                        DEFAULT_CHAT_FRAME:AddMessage("LOOT ROLL STARTED. ID: "..arg1.." "..itemLink)
                    end
                    local texture, name, count, quality = GetLootRollItemInfo(arg1);
                    local timeLeft = floor(GetLootRollTimeLeft(arg1) / 1000)
                    local itemInfo = {arg1, itemLink, texture, name, count, quality, {}, {}, {}, "", {[1] = nil,[2] = nil}, {}, {}, {}, finished=false, start=time(), done=timeLeft, duplicates=0 }
                    local id = arg1
                    if table.getn(LootList) > 100 then
                        table.remove(LootList,1)
                    end
                    local found = false
                    for i=1,table.getn(LootList) do
                        if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]  then
                            itemInfo = LootList[i]
                            found = true
                            id = LootList[i][1]
                            LootList[i].duplicates = LootList[i].duplicates + 1
                            break
                        end
                    end
                    if not found then
                        table.insert(LootList, itemInfo)
                        local lootTimer = {CreateFrame("Frame"), id }

                        table.insert(LootTimerTable, lootTimer)
                        local tableSize = table.getn(LootTimerTable)
                        LootTimerTable[tableSize][1]:SetScript("OnUpdate", function ()
                            progressRollInfo(tableSize, 50000, 30000)
                        end)
                    end
                    
                    
                end

                if event == "CHAT_MSG_LOOT" then
                    
                    local p = 0
                    local sliced = {}
                    local itemLink
                    if strfind(arg1,"|c%x%x%x%x%x%x%x%x|Hitem:(%d*):(%d*):(%d*):(%d*)[:0-9]*|h%[[^]]*%]|h|r") then
                        local startPos, endPos, firstWord, restOfString = strfind(arg1,"|c%x%x%x%x%x%x%x%x|Hitem:(%d*):(%d*):(%d*):(%d*)[:0-9]*|h%[[^]]*%]|h|r")
                        --local numItem = findItem+strlen(findItem)
                        itemLink = strsub(arg1,startPos,endPos)
                        --DEFAULT_CHAT_FRAME:AddMessage("Logging info about: "..itemLink)
                    end
                    for str in string.gfind(arg1, "[^%s]+") do
                        p = p + 1
                        sliced[p] = str
                        -- DEFAULT_CHAT_FRAME:AddMessage(str)
                        
                    end
                     

                    if sliced[2] == "Roll" then
                        if sliced[1] == "Need" then
                            
                            for i=1,table.getn(LootList) do
                                if LootList[i][2] == itemLink and LootList[i].finished == false and time() < LootList[i]["start"] + LootList[i]["done"] then
                                    -- DEFAULT_CHAT_FRAME:AddMessage("ROLL NEED ")
                                    local temp = {sliced[p],sliced[4]}
                                    table.insert(LootList[i][7],temp)
                                end
                            end
                        elseif sliced[1] == "Greed" then

                            for i=1,table.getn(LootList) do
                                if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                    -- DEFAULT_CHAT_FRAME:AddMessage("ROLL GREED")                          
                                    local temp = {sliced[p],sliced[4]}
                                    table.insert(LootList[i][8],temp)
                                end
                            end
                        end
                    end

                    if sliced[2] == "won:" then
                        DEFAULT_CHAT_FRAME:AddMessage(lootColor.."---------------------------------")
                        DEFAULT_CHAT_FRAME:AddMessage(lootColor.."Roll for "..itemLink..lootColor.." finished")


                        local result = lootColor.."Need: "
                        local temp = ""
                        local winner = sliced[1]
                        if winner == "You" then
                            winner = UnitName("player")
                        end
                        local tableID
                        for i=1,table.getn(LootList) do
                            if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                tableID = i
                                for j=1,table.getn(LootList[i][7]) do
                                    if LootList[i][7][j][1] == winner then
                                        if strlen(temp) > 1 and j <= table.getn(LootList[i][7]) then 
                                            temp = winnerColor.."|Hplayer:"..LootList[i][7][j][1].."|h"..LootList[i][7][j][1].."("..LootList[i][7][j][2]..")|h"..lootColor..", "..temp
                                        else
                                            temp = winnerColor.."|Hplayer:"..LootList[i][7][j][1].."|h"..LootList[i][7][j][1].."("..LootList[i][7][j][2]..")|h"..lootColor
                                        end
                                    else
                                        if strlen(temp) > 1 and j <= table.getn(LootList[i][7]) then 
                                            temp = temp..", ".."|Hplayer:"..LootList[i][7][j][1].."|h"..LootList[i][7][j][1].."("..LootList[i][7][j][2]..")|h"
                                        else
                                            temp = "|Hplayer:"..LootList[i][7][j][1].."|h"..LootList[i][7][j][1].."("..LootList[i][7][j][2]..")|h"
                                        end
                                    end
                                end
                                break
                            end
                        end
                        if strlen(temp) > 1 then
                            result = result..temp
                            DEFAULT_CHAT_FRAME:AddMessage(result)
                            local text
                            for j=1,table.getn(LootList[tableID][13]) do
                                if text ~= nil then
                                    text = text..", "..LootList[tableID][13][j]
                                else
                                    text = LootList[tableID][13][j]
                                end
                            end
                            if text ~= nil then
                                DEFAULT_CHAT_FRAME:AddMessage(lootColor.."Greed: "..text)
                            end
                        end

                        local result = lootColor.."Greed: "
                        local temp = ""
                        for i=1,table.getn(LootList) do
                            if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                for j=1,table.getn(LootList[i][8]) do
                                    if LootList[i][8][j][1] == winner then
                                        if strlen(temp) > 1 and j <= table.getn(LootList[i][8]) then 
                                            temp = winnerColor.."|Hplayer:"..LootList[i][8][j][1].."|h"..LootList[i][8][j][1].."("..LootList[i][8][j][2]..")|h"..lootColor..", "..temp
                                        else
                                            temp = winnerColor.."|Hplayer:"..LootList[i][8][j][1].."|h"..LootList[i][8][j][1].."("..LootList[i][8][j][2]..")|h"..lootColor
                                        end
                                    else
                                        if strlen(temp) > 1 and j <= table.getn(LootList[i][8]) then 
                                            temp = temp..", ".."|Hplayer:"..LootList[i][8][j][1].."|h"..LootList[i][8][j][1].."("..LootList[i][8][j][2]..")|h"
                                        else
                                            temp = "|Hplayer:"..LootList[i][8][j][1].."|h"..LootList[i][8][j][1].."("..LootList[i][8][j][2]..")|h"
                                        end
                                    end
                                end
                                break
                            end
                        end
                        if strlen(temp) > 1 then
                            result = result..temp
                            DEFAULT_CHAT_FRAME:AddMessage(result)
                        end

                        local result = lootColor.."Pass: "
                        local temp = ""
                        for i=1,table.getn(LootList) do
                            if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                for j=1,table.getn(LootList[i][14]) do
                                    if strlen(temp) > 0 then
                                        temp = temp..", "..LootList[i][14][j]
                                    else
                                        temp = LootList[i][14][j]
                                    end
                                end
                                break
                            end
                        end
                        if strlen(temp) > 1 then
                            result = result..temp
                            DEFAULT_CHAT_FRAME:AddMessage(result)
                        end
                        DEFAULT_CHAT_FRAME:AddMessage(lootColor.."---------------------------------")

                        for i=1,table.getn(LootList) do
                            if LootList[i][2] == itemLink  and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                LootList[i][10] = winner
                                if LootList[i].duplicates == 0 then
                                    LootList[i]["finished"] = true
                                else
                                    LootList[i].duplicates = LootList[i].duplicates  - 1
                                end
                                break
                            end
                        end

                    end

                    if sliced[1] == "You" then
                        sliced[1] = UnitName("player")
                        DEFAULT_CHAT_FRAME:AddMessage(lootColor..arg1)
                    end
                    if sliced[4] == "Need" then
                        for i=1,table.getn(LootList) do
                            if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                if LootList[i][11][2] ~= "Need" and sliced[1] ~= LootList[i][11][1] then
                                    LootList[i][11][1] = sliced[1]
                                    LootList[i][11][2] = "Need"
                                    DEFAULT_CHAT_FRAME:AddMessage(lootColor.."First player "..winnerColor.."|Hplayer:"..sliced[1].."|h["..sliced[1].."]|h"..lootColor.." has selected Need for "..itemLink..lootColor.."!") 
                                end
                                table.insert(LootList[i][12],sliced[1])
                                break
                            end

                        end     
                    end

                    if sliced[4] == "Greed" then
                        for i=1,table.getn(LootList) do
                            if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                if LootList[i][11][2] ~= "Greed" and LootList[i][11][2] ~= "Need" and sliced[1] ~= LootList[i][11][1] then
                                    LootList[i][11][1] = sliced[1]
                                    LootList[i][11][2] = "Greed"
                                    DEFAULT_CHAT_FRAME:AddMessage(lootColor.."First player "..winnerColor.."|Hplayer:"..sliced[1].."|h["..sliced[1].."]|h"..lootColor.." has selected Greed for "..itemLink.."!")   
                                end
                                table.insert(LootList[i][13],sliced[1])
                                break
                            end
                        end     
                    end
                    if sliced[2] == "passed" then
                        -- DEFAULT_CHAT_FRAME:AddMessage("Player: "..sliced[1].." Passed: "..itemLink)
                        if sliced[1] == "Everyone" then
                            DEFAULT_CHAT_FRAME:AddMessage(lootColor..arg1)
                            for i=1,table.getn(LootList) do
                                if LootList[i][2] == itemLink  and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                    LootList[i]["finished"] = true
                                    break
                                end
                            end
                        else
                            for i=1,table.getn(LootList) do
                                if LootList[i][2] == itemLink and not LootList[i].finished and time() < LootList[i]["start"] + LootList[i]["done"]   then
                                    table.insert(LootList[i][14],sliced[1])
                                    break
                                end
                            end
                        end
                    end
                end
            end)


            local highlightTimer = 0
            local happenedHighlight = false

            local function SendFilteredMessage(event, frameID)

                local type = strsub(event,10)
                if type == "CHANNEL" then
                    type = type..arg8
                end
                --this:AddMessage(type)
                if string.find(event, "CHANNEL_NOTICE_USER") or string.find(event, "CHANNEL_NOTICE") or string.find(event, "CHANNEL_JOIN")  or string.find(event, "CHANNEL_LEAVE")  then
                    -- this:AddMessage("NOT MEMBER")
                    return
                end
                if not WFCopyChatDisabled then  
                    if chatBoxes[frameID] ~= nil then
                        if table.getn(chatBoxes[frameID]) ~= nil then
                            local tableSize = table.getn(chatBoxes[frameID]) 
                            
                            if debug then 
                                -- DEFAULT_CHAT_FRAME:AddMessage("EVENT: "..event.." FRAME ID: "..frameID)
                            end
                            if tableSize >= tonumber(tableLimit) then
                                if debug then 
                                    -- DEFAULT_CHAT_FRAME:AddMessage("TABLE "..frameID.." IS FULL - REMOVING FIRST LINE")
                                end
                                table.remove(chatBoxes[frameID],1)
                            end
                        end
                    end
                end

                local IsText = false

                if not WFHighlightDisabled or not WFCopyChatDisabled then
                    if arg1 ~= nil then
                        local hour,minute = GetGameTime();
                        local second = mod(time(), 60)
                        if strlen(hour) <= 1 then
                            hour = "0"..hour
                        end
                        if strlen(minute) <= 1 then
                            minute = "0"..minute
                        end
                        if strlen(second) <= 1 then
                            second = "0"..second
                        end
                           -- ChatFrame3:AddMessage(arg1..arg2)
                        
                        local parse = strsub(event,10)
                            local check
                        local hexcolor
                        if ChannelInfo[type] ~= nil then
                            hexcolor = RGBToHex(ChannelInfo[type][1],ChannelInfo[type][2],ChannelInfo[type][3])
                        else
                            hexcolor = "ffffff"
                        end
                        if string.find(type,"MONSTER") then
                            check = "\124cffffffff\124h"..hour..":"..minute..":"..second.."\124cff"..hexcolor.."\124h "..arg2..": "..arg1
                        elseif string.find(type,"COMBAT") or string.find(type,"AURA") or string.find(type,"SPELL") then
                            check = "\124cffffffff\124h"..hour..":"..minute..":"..second.."\124cff"..hexcolor.."\124h "..arg1
                        elseif ChannelInfo[type] ~= nil then
                            if ChannelInfo[type][4] == nil then
                                check = "\124cffffffff\124h"..hour..":"..minute..":"..second.."\124cff"..hexcolor.."\124h "..arg1
                            elseif arg2 ~= nil and parse ~= nil then
                                -- DEFAULT_CHAT_FRAME:AddMessage("AAAAAAAAAAtype: "..type.." SHORTCUT: "..ChannelInfo[type][4])
                                check = "\124cffffffff\124h"..hour..":"..minute..":"..second.."\124cff"..hexcolor.."\124h "..ChannelInfo[type][4].." |Hplayer:"..arg2.."|h["..arg2.."]|h: "..arg1
                            end
                        end

                        if check ~= nil then
                            check = check.."\124cffffffff\124h"
                        end
                        if not WFCopyChatDisabled then
                            
                            if check ~= nil then
                                
                                if chatBoxes[frameID] ~= nil then
                                    if debug then 
                                        ChatFrame2:AddMessage("Added to table "..frameID..": "..check)
                                    end
                                    table.insert(chatBoxes[frameID],check)
                                end
                            end
                        end
                        -- Highlight function

                        if not WFHighlightDisabled then

                            if highlightTimer+0.1 <= GetTime() then 
                                happenedHighlight = false
                                end
                            if not happenedHighlight then
                                happenedHighlight = true
                                highlightTimer = GetTime()
                                local found = false
                                for k,phrase in pairs(WFHighlightlist) do
                                    if string.lower(phrase) == "[system]" and parse == "SYSTEM" then
                                        found = true
                                        break
                                    end
                                    if check ~= nil and phrase ~= nil and UnitName('player') ~= arg2 and type ~= "WHISPER_INFORM" then
                                        if debug then 
                                            ChatFrame2:AddMessage(string.lower(check).." vs "..string.lower(phrase))
                                        end
                                        if string.find(string.lower(check),string.lower(phrase), 1, true) ~= nil then
                                            found = true
                                        end
                                    end
                                end
                                if found then   
                                    found = false
                                    if debug then
                                        DEFAULT_CHAT_FRAME:AddMessage("Highlight phrase: "..check)
                                    end
                                    if not WFmute then
                                        PlaySoundFile("Interface\\AddOns\\WhisperFilter\\notif.mp3");
                                    end
                                    frameN:AddMessage(check)
                                end
                            end
                        end
                    end
                end



                

                if debug then 
                    -- DEFAULT_CHAT_FRAME:AddMessage("Sending message: "..tostring(hook))
                end
                if hook and frameID == 1 then   
                    if(WIM_ChatFrameSupressor_OnEvent(event)) then
                        backup(event)
                    else
                        WIM_Incoming(event)
                    end
                else
                    backup(event)
                end
            end


            function AddToWhitelist(name,lvl,frame) 
                if lvl >= ignoreUntilLvl then
                    if debug then 
                        DEFAULT_CHAT_FRAME:AddMessage("ALLOWED "..name)
                    end
                    local foundInTable = false
                    for i, v in pairs(WFwhitelist) do
                        if v[1] == name then
                            if debug then
                                DEFAULT_CHAT_FRAME:AddMessage(name.." found in whitelist")
                            end
                            foundInTable = true
                        end
                    end
                    if not foundInTable then
                        local playerInfo = {name,lvl}
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("Player added to whitelist!")
                        end
                        table.insert(WFwhitelist, playerInfo)
                    end
                    arg1 = prevArg1
                    arg2 = prevArg2
                    arg3 = prevArg3
                    if debug then
                        DEFAULT_CHAT_FRAME:AddMessage("SendFilteredMessage1")
                    end
                    SendFilteredMessage(prev, frame)
                else
                    if debug then 
                        DEFAULT_CHAT_FRAME:AddMessage("NOT ALLOWED - LOW LVL "..name)
                    end
                end
            end

            local tradeHook = false
            UIErrorsFrame_OnEvent = function(event,message)
                if not WFblacklistUIErrorDisabled then
                    for k, v in pairs(WFblacklistUIError) do
                        if string.find( string.lower(message), v ) then
                            if debug then   
                                DEFAULT_CHAT_FRAME:AddMessage(message.." found in blacklist")
                                DEFAULT_CHAT_FRAME:AddMessage("ERROR BLOCKED")
                            end
                            return
                        end
                    end
                end
                if tradeHook then
                    tradeHook = false
                    if message ~= nil then 
                        h = string.find(message, "Trade cancel");--p = string.find(arg1,"Out of range")
                    end
                    if h ~= nil then
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("Trade info blocked")
                        end
                        return
                    end
                else
                    if debug then
                        DEFAULT_CHAT_FRAME:AddMessage("Error message "..event)
                    end
                    if ( event == "SYSMSG" ) then
                        this:AddMessage(message, arg2, arg3, arg4, 1.0, UIERRORS_HOLD_TIME);
                    elseif ( event == "UI_INFO_MESSAGE" ) then
                        this:AddMessage(message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
                    elseif ( event == "UI_ERROR_MESSAGE" ) then
                        this:AddMessage(message, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
                    end
                end
            end

            local backupTrade = TradeFrame_OnEvent
            local backupCancelTrade = TradeFrame_OnHide
            TradeFrame_OnEvent = function () 
                if not WFignoreDisabledAll then
                    local name =UnitName('npc')
                    if name ~= nil then
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("Opened trade window with "..name.." ") 
                        end
                        for i, v in pairs(WFblacklist) do
                            if v == name then
                                if debug then
                                    
                                    DEFAULT_CHAT_FRAME:AddMessage(name.." found in blacklist")
                                    DEFAULT_CHAT_FRAME:AddMessage("TRADE BLOCKED")
                                end
                                TradeFrame_OnHide()
                                tradeHook = true
                                return
                            end
                        end
                    end
                    backupTrade()
                else
                    backupTrade()
                end
            end


            function ChatFilter(event)
                local ChatFrameID = this:GetID()
                local activeChannel = false
                
                if event == "CHAT_MSG_LOOT" then
                    if string.find(event, "You have selected") or string.find(event, "Everyone Passed") then
                        SendFilteredMessage(event,ChatFrameID)
                    else
                        if not WFLootFilterDisabled then
                            return
                        end
                    end
                end

                if not string.find(event, "EMOTE") then
                    if string.find(event,"COMBAT") then
                        --this:AddMessage("ADDED TO COMBAT LOG COPY")
                        SendFilteredMessage(event,ChatFrameID)
                        return
                    elseif string.find(event,"SPELL") then
                        -- this:AddMessage("ADDED TO COMBAT LOG COPY")
                        SendFilteredMessage(event,ChatFrameID)
                        return
                    elseif string.find(event,"AURA") then
                        --this:AddMessage("ADDED TO COMBAT LOG COPY")
                        SendFilteredMessage(event,ChatFrameID)
                        return
                    end
                    for i=1,table.getn(NUMBER_OF_CHATBOXES) do
                        if ChatFrameID == NUMBER_OF_CHATBOXES[i] then
                            activeChannel = true
                            break
                        end
                    end
                    if not activeChannel then
                        backup(event)
                        return
                    end
                    local activeMSG = false
                    local DefaultMessages = { GetChatWindowMessages(ChatFrameID)}
                    for k,v in pairs(DefaultMessages) do
                        if debug then
                            -- DEFAULT_CHAT_FRAME:AddMessage(v.." vs "..event)
                        end

                        if string.find(event,v) then
                            activeMSG = true
                        end

                        if event == "CHAT_MSG_CHANNEL" then
                            
                            if arg9 ~= nil then
                                local activeCHANNEL = false
                                for index, value in pairs(this.channelList) do
                                    
                                    for str in string.gfind(arg9, "[^%s]+") do
                                        -- DEFAULT_CHAT_FRAME:AddMessage(ChatFrameID.." "..value.."  vs  "..str)
                                        if value == str then
                                            activeCHANNEL = true
                                            break
                                        end
                                    end
                                    if activeCHANNEL then
                                        break
                                    end
                                end
                                if not activeCHANNEL then
                                backup(event)
                                return
                            end
                            end
                            
                        end
                    end

                    if not activeMSG and activeMSG ~= nil then
                        backup(event)
                        return
                    end
                
                end
            --DEFAULT_CHAT_FRAME:AddMessage("ACTIVE MSG AFTER "..event)

                if not WFignoreDisabledAll then
                    if arg1 ~= nil and arg2 ~= nil then
                        for i, v in pairs(WFblacklist) do
                            if v == arg2 then
                                if debug then
                                    DEFAULT_CHAT_FRAME:AddMessage(arg2.." found in blacklist")
                                    DEFAULT_CHAT_FRAME:AddMessage("MESSAGE IGNORED"..arg1)
                                end
                                return
                            end
                        end
                    end
                end

                if not WFblacklistPhrasesDisabled then
                    if arg1 ~= nil then
                        for k,phrase in pairs(WFblacklistPhrases) do
                            if phrase ~= nil then
                                if string.find(arg1,phrase, 1, true) ~= nil then
                                    if debug then
                                        DEFAULT_CHAT_FRAME:AddMessage(arg1.." Blocked phrase: "..phrase)
                                    end
                                    return
                                end
                            end
                        end
                    end
                end
                if arg1 ~= nil then
                    if string.find(arg1,"[\228-\233]") ~=nil then
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage("Asian chars - blocked")
                        end
                        return
                    end
                end

                if event == "CHAT_MSG_WHISPER" then
                    if not WFignoreDisabled then
                        for i, v in pairs(WFblacklist) do
                            if v == arg2 then
                                if debug then
                                    DEFAULT_CHAT_FRAME:AddMessage(arg2.." found in blacklist")
                                end
                                return
                            end
                        end
                    end
                end

                if not WFClinkDisabled then
                    if arg1 ~= nil then
                        if GetBuildInfo() == "1.12.1" then
                            chatstring = string.gsub (arg1, "{CLINK:(%x+):(%d-):(%d-):(%d-):(%d-):([^}]-)}", "|c%1|Hitem:%2:%3:%4:%5|h[%6]|h|r")
                        else
                            chatstring = string.gsub (arg1, "{CLINK:item:(%x+):(%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
                            chatstring = string.gsub (chatstring, "{CLINK:enchant:(%x+):(%-?%d-):([^}]-)}", "|c%1|Henchant:%2|h[%3]|h|r")
                            chatstring = string.gsub (chatstring, "{CLINK:quest:(%x+):(%-?%d-):(%-?%d-):([^}]-)}","|cffffff00|Hquest:%2:%3|h[%4]|h|r")
                            chatstring = string.gsub (chatstring, "{CLINK:spell:(%x+):(%-?%d-):([^}]-)}","|c%1|Hspell:%2|h[%3]|h|r")
                            chatstring = string.gsub (chatstring, "{CLINK:(%x+):(%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
                        end
                        arg1 = chatstring
                    end
                end

                if ChatFrameID ~= nil then
                    if event == "CHAT_MSG_SYSTEM" then
                        if debug then
                            DEFAULT_CHAT_FRAME:AddMessage(arg1)
                        end
                        if WFGuildBlock then
                            if string.find(arg1, "invites you join") then
                                return
                            end
                        end
                        if string.find(arg1,"player total") ~= nil and hookedhook then
                            hookedhook = false
                            return
                        end
                        if string.find(arg1,"Level.%d+.* -") ~= nil and hooked then
                            WhoFound = true
                            hooked = false
                            hookedhook = true
                            if debug then
                                DEFAULT_CHAT_FRAME:AddMessage("USING WHO - PLAYER FOUND")
                            end
                            local str
                            local i = 0
                            local lvl
                            for str in string.gfind(arg1, "[^%s]+") do
                                if i == 2 then
                                    lvl = str
                                end
                                i = i + 1
                            end
                            if debug then
                                DEFAULT_CHAT_FRAME:AddMessage("Name: "..PlayerName.." Level: "..lvl)
                            end
                            lvl = tonumber(lvl)
                            AddToWhitelist(PlayerName,lvl,ChatFrameID)
                            return
                        end

                        if string.find(arg1,"friend") ~=nil and hooked or hookedhook then
                            hookedhook = false
                            if debug then
                                DEFAULT_CHAT_FRAME:AddMessage("USING FRIENDLIST")
                            end
                            if string.find(arg1,"already") ~=nil or string.find(arg1,"yourself") ~=nil then
                                if debug then
                                    DEFAULT_CHAT_FRAME:AddMessage("YOU CAN'T ADD THIS GUY TO FRIENDLIST")
                                end
                                arg1 = prevArg1
                                arg2 = prevArg2
                                arg3 = prevArg3
                                 if debug then
                                    DEFAULT_CHAT_FRAME:AddMessage("SendFilteredMessage2")
                                end
                                SendFilteredMessage(prev,ChatFrameID)
                                hooked = false
                            else if string.find(arg1,"added to friend") ~= nil and hooked then
                                if debug then
                                    DEFAULT_CHAT_FRAME:AddMessage(PlayerName.." ADDED TO FRIEND LIST")
                                end     
                                for i=1,GetNumFriends() do
                                    local name, level, class, loc, connected, status = GetFriendInfo(i);
                                    if level == 0 then
                                        break
                                    end
                                    if PlayerName == name then
                                        if debug then
                                            DEFAULT_CHAT_FRAME:AddMessage("Player info: "..name.." "..level)
                                        end
                                        AddToWhitelist(PlayerName,level,ChatFrameID)
                                        break
                                    end
                                end
                                RemoveFriend(PlayerName)
                                hooked = false
                                hookedhook = true      
                            end end
                        else
                            if debug then
                                DEFAULT_CHAT_FRAME:AddMessage("SendFilteredMessage7")
                            end
                            SendFilteredMessage(event,ChatFrameID)
                        end
                        return
                    end
                    if event == "CHAT_MSG_WHISPER"  then    
                        for i=1,GetNumFriends() do
                            local name, level, class, loc, connected, status = GetFriendInfo(i);
                            if arg2 == name then
                                if debug then
                                    DEFAULT_CHAT_FRAME:AddMessage("SendFilteredMessage3")
                                end
                                SendFilteredMessage(event,ChatFrameID)
                                return
                            end
                        end
                        if not WFautoinvDisabled then
                            if WFautoinvList ~= nil then
                                if WFautoinvList == arg1 then
                                    if debug then
                                        DEFAULT_CHAT_FRAME:AddMessage("Sending invite to player: "..arg2)
                                    end
                                    InviteUnit(arg2)
                                end
                            end
                        end
                        local foundInTable = false
                        for i, v in pairs(WFwhitelist) do
                            if v[1] == arg2 then
                                if debug then
                                    DEFAULT_CHAT_FRAME:AddMessage(arg2.." found in whitelist")
                                end
                                foundInTable = true
                            end
                        end
                        if foundInTable then
                            if debug then
                                this:AddMessage("SendFilteredMessage4")
                            end

                            SendFilteredMessage(event,ChatFrameID)
                            return
                        end
                        hooked = true
                        SendWho('n-"'..arg2..'"')
                        PlayerName = arg2
                        k:SetScript("OnUpdate", timer)


                        
                        prev = event
                        prevArg1 = arg1
                        prevArg2 = arg2
                        prevArg3 = arg3
                        setglobal(prev)
                        setglobal(prevArg2)
                        setglobal(prevArg3)
                        return
                    else
                        if debug then
                            -- DEFAULT_CHAT_FRAME:AddMessage("SendFilteredMessage5")
                        end
                        SendFilteredMessage(event,ChatFrameID)
                        return
                    end
                else
                    if debug then
                        this:AddMessage("SendFilteredMessage8")
                    end
                    SendFilteredMessage(event,ChatFrameID)
                    return
                end
            end
            
            if type(ChatFrame_MessageEventHandler) ~= "nil" then
                ChatFrame_MessageEventHandler = ChatFilter
            elseif type(ChatFrame_OnEvent) ~= "nil" then
                ChatFrame_OnEvent = ChatFilter
            end

            SLASH_WHISPERFILTER1, SLASH_WHISPERFILTER2, SLASH_WHISPERFILTER3 = '/wf', '/psychi','/whisperfilter'
            SLASH_IGNOREFILTER1,SLASH_IGNOREFILTER2 = '/i','/ignore'
            SLASH_RELOAD1, SLASH_RELOAD2 = '/reloadui', '/reload'


            local function whisperHandler(msg, editbox)


                if WFwhitelist ~= nil then
                    -- DEFAULT_CHAT_FRAME:AddMessage(table.getn(whitelist))
                end
                local parse = {}
                local i = -1
                for cmd in string.gfind(msg, "[^%s]+") do
                    i = i +1
                    parse[i] = cmd
                end

                
                if parse[0] == "guildblock" then
                    if WFGuildBlock then
                        WFGuildBlock = false
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Guild block disabled.")
                    else
                        WFGuildBlock = true
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Guild block enabled.")
                    end
                    return
                end

                if parse[0] == "mute" then
                    if WFmute then
                        WFmute = false
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Sounds enabled.")
                    else
                        WFmute = true
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Sounds muted.")
                    end
                    return
                end
                if parse[0] == "autoinv" or parse[0] == "autoinvite" then
                    if i == 0 then
                        if WFautoinvDisabled then
                            WFautoinvDisabled = false
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Autoinvite is enabled.")
                        else
                            WFautoinvDisabled = true
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Autoinvite is disabled.")
                        end
                    else
                        WFautoinvList = parse[1]
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."People who whispers you "..parse[1].." will be invited!")
                    end
                    return
                end

                if parse[0] == "unlock" then
                    if WFHighlightDisabled then
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."You must enable this feature first to do that.")
                    else
                        frameN:SetMovable(true)
                        frameN:SetResizable(true)
                        frameN:EnableMouse(true)
                        tex:SetAlpha(0.5)
                        WFHighlightLock = false 
                    end
                    return
                end
                if parse[0] == "highlight" then
                    if i == 0 then
                        if WFHighlightDisabled then
                            if firstLock then
                                firstLock = false
                                frameN:EnableMouse(true)
                                tex:SetAlpha(0.5)
                                WFHighlightLock = false
                            elseif not WFHighlightLock then
                                frameN:EnableMouse(true)
                                tex:SetAlpha(0.5)
                            end
                            WFHighlightDisabled = false
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Highlight is enabled.")
                        else
                            frameN:EnableMouse(false)
                            tex:SetAlpha(0)
                            WFHighlightDisabled = true
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Highlight is disabled.")
                        end
                    else
                        local connect
                        for k=1,i do
                            if connect == nil then
                                connect = parse[k]
                            else
                                connect = connect.." "..parse[k]
                            end
                            
                        end

                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Added phrase to highlights: "..connect)
                        table.insert(WFHighlightlist,connect)
                    end
                    return
                end

                if parse[0] == "error" then
                    if i == 0 then
                        if WFblacklistUIErrorDisabled then
                            WFblacklistUIErrorDisabled = false
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Error message blacklist is enabled.")
                        else
                            WFblacklistUIErrorDisabled = true
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Error message blacklist is disabled.")
                        end
                    else
                        local connect
                        for k=1,i do
                            if connect == nil then
                                connect = parse[k]
                            else
                                connect = connect.." "..parse[k]
                            end
                            
                        end
                        local check = strsub(connect,strlen(connect))
                        DEFAULT_CHAT_FRAME:AddMessage(check)
                        if check == "." then
                            connect = strsub(connect,1,strlen(connect)-1)
                        end
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Added error message to blacklist: "..connect)
                        table.insert(WFblacklistUIError,connect)
                    end
                    return
                end
                if parse[0] == "phrase" then
                    if i == 0 then
                        if WFblacklistPhrasesDisabled then
                            WFblacklistPhrasesDisabled = false
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Phrase blacklist is enabled.")
                        else
                            WFblacklistPhrasesDisabled = true
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Phrase blacklist is disabled.")
                        end
                    else
                        local connect
                        for k=1,i do
                            if connect == nil then
                                connect = parse[k]
                            else
                                connect = connect.." "..parse[k]
                            end
                            
                        end
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Added phrase to blacklist: "..connect)
                            table.insert(WFblacklistPhrases,connect)
                    end
                    return
                end
                if parse[0] == "copychat" then
                    if i == 0 then
                        if WFCopyChatDisabled then
                            WFCopyChatDisabled = false
                            for i=1,table.getn(NUMBER_OF_CHATBOXES) do
                                textures[i]:SetAlpha(0.3)
                                textures2[i]:SetAlpha(1)
                            end
                            for i=1,table.getn(NUMBER_OF_CHATBOXES) do
                                textures[i]:SetAlpha(0.3)
                            end

                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Copychat function is enabled.")
                        else
                            WFCopyChatDisabled = true
                            for i=1,table.getn(NUMBER_OF_CHATBOXES) do
                                textures[i]:SetAlpha(0)
                                textures2[i]:SetAlpha(0)
                            end
                            for i=1,table.getn(NUMBER_OF_CHATBOXES) do
                                textures[i]:SetAlpha(0)
                            end
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Copychat function is disabled.")
                        end
                    else
                        if parse[1] == "set" and tostring(parse[2]) and tostring(parse[3]) then
                            if ChannelInfo[tostring(parse[2])] ~= nil then
                                ChannelInfo[tostring(parse[2])][4] = tostring(parse[3])
                                DEFAULT_CHAT_FRAME:AddMessage(whisp..parse[2].." name changed to: "..parse[3])
                            end
                            
                        end
                        if parse[1] == "limit" and tonumber(parse[2]) then
                            tableLimit = tonumber(parse[2])
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Limit changed to "..tableLimit)
                        end
                    end
                    return
                end

                

                if parse[0] == "sticky" then
                    if WFstickyAllDisabled then
                        WFstickyAllDisabled = false
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Sticky chat messages is enabled.")
                    else
                        WFstickyAllDisabled = true
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Sticky chat messages is disabled.")
                    end
                    return
                end

                if parse[0] == "clink" then
                    if WFClinkDisabled then
                        WFClinkDisabled = false
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Clink fix is enabled.")
                    else
                        WFClinkDisabled = true
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Clink fix function is disabled.")
                    end
                    return
                end

                if parse[0] == "loot" then
                    if WFLootFilterDisabled then
                        WFLootFilterDisabled = false
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Loot Filter is enabled.")
                    else
                        WFLootFilterDisabled = true
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Loot Filter is disabled.")
                    end
                    return
                end

                if parse[0] == "wim" then
                    if WIMWhoDisabled then
                        WIMWhoDisabled = false
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."WIM Who function is enabled.")
                    else
                        WIMWhoDisabled = true
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."WIM Who function is disabled.")
                    end
                    return
                end

                if parse[0] == "ignore" then
                    if parse[1] == "all" then
                        if WFignoreDisabledAll then
                            WFignoreDisabledAll = false
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Ignore ALL function is enabled.")
                        else
                            WFignoreDisabledAll = true
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Ignore ALL function is disabled.")
                        end
                        return
                    end
                    if WFignoreDisabled then
                        if debug then 
                            DEFAULT_CHAT_FRAME:AddMessage("WF ignore - DISABLED")
                        end
                        WIM_SendWho = function () end

                        WFignoreDisabled = false
                        SLASH_IGNOREFILTER1,SLASH_IGNOREFILTER2 = '/i','/ignore'
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Ignore function is enabled.")
                    else
                        if debug then 
                            DEFAULT_CHAT_FRAME:AddMessage("WF ignore - ENABLED")
                        end
                        WIM_SendWho = function (name)
                            WIM_Windows[name].waiting_who = true;
                            SetWhoToUI(1);
                            SendWho('n-"'..name..'"')
                        end
                        WFignoreDisabled = true
                        SLASH_IGNOREFILTER1,SLASH_IGNOREFILTER2 = nil, nil
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Ignore function is disabled.")
                    end
                    return
                end

                if parse[0] == "remove" then
                    if parse[1] == "whitelist" then
                        for k=2,i do
                            for p, v in pairs(WFwhitelist) do
                                if string.lower(parse[k]) == string.lower(v[1]) then
                                    DEFAULT_CHAT_FRAME:AddMessage(whisp.."Removed item from "..parse[1]..": "..parse[k])
                                    table.remove(WFwhitelist,p)
                                end
                            end
                        end
                    elseif parse[1] == "blacklist" then
                        for k=2,i do
                            for p, v in pairs(WFblacklist) do       
                                if string.lower(parse[k]) == string.lower(v) then
                                    DEFAULT_CHAT_FRAME:AddMessage(whisp.."Removed item from "..parse[1]..": "..parse[k])
                                    table.remove(WFblacklist,p)
                                end
                            end
                        end
                    elseif parse[1] == "phrase" then
                        local connect
                        for k=2,i do
                            if connect == nil then
                                connect = parse[k]
                            else
                                connect = connect.." "..parse[k]
                            end
                            
                        end

                            for p, v in pairs(WFblacklistPhrases) do    
                                if string.lower(connect) == string.lower(v) then
                                    DEFAULT_CHAT_FRAME:AddMessage(whisp.."Removed item from "..parse[1]..": "..connect)
                                    table.remove(WFblacklistPhrases,p)
                                end
                            end
                    elseif parse[1] == "error" then
                        local connect
                        for k=2,i do
                            if connect == nil then
                                connect = parse[k]
                            else
                                connect = connect.." "..parse[k]
                            end
                            
                        end
                            for p, v in pairs(WFblacklistUIError) do    
                                if string.lower(connect) == string.lower(v) then
                                    DEFAULT_CHAT_FRAME:AddMessage(whisp.."Removed item from "..parse[1]..": "..connect)
                                    table.remove(WFblacklistUIError,p)
                                end
                            end
                    elseif parse[1] == "highlight" then
                        local connect
                        for k=2,i do
                            if connect == nil then
                                connect = parse[k]
                            else
                                connect = connect.." "..parse[k]
                            end
                            
                        end

                            for p, v in pairs(WFHighlightlist) do           
                                if string.lower(connect) == string.lower(v) then
                                    DEFAULT_CHAT_FRAME:AddMessage(whisp.."Removed item from "..parse[1]..": "..connect)
                                    table.remove(WFHighlightlist,p)
                                end
                            end
                    else
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."What do you want me to "..parse[0].."? /wf "..parse[0].." whitelist | blacklist | phrases | error | highlight")
                    end
                    
                    return
                end

                if parse[0] == "show" then
                    DEFAULT_CHAT_FRAME:AddMessage("Current words:")
                    if parse[1] == "whitelist" then
                        for k, v in pairs(WFwhitelist) do
                            DEFAULT_CHAT_FRAME:AddMessage(v[1])
                        end
                    elseif parse[1] == "blacklist" then
                        for k, v in pairs(WFblacklist) do
                            DEFAULT_CHAT_FRAME:AddMessage(v)
                        end
                    elseif parse[1] == "phrase" then
                        for k, v in pairs(WFblacklistPhrases) do
                            DEFAULT_CHAT_FRAME:AddMessage(v)
                        end
                    elseif parse[1] == "error" then
                        for k, v in pairs(WFblacklistUIError) do
                            DEFAULT_CHAT_FRAME:AddMessage(v)
                        end
                    elseif parse[1] == "highlight" then
                        for k, v in pairs(WFHighlightlist) do
                            DEFAULT_CHAT_FRAME:AddMessage(v)
                        end
                    elseif parse[1] == "autoinv" then
                        DEFAULT_CHAT_FRAME:AddMessage(WFautoinvList)
                    else
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."What do you want me to "..parse[0].."? /wf "..parse[0].." whitelist | blacklist | phrases | error | highlight")
                    end
                    
                    return
                end
                if parse[0] == "clean" or parse[0] == "wipe" or parse[0] == "reset" then
                    
                    if parse[1] == "whitelist" then
                        WFwhitelist = {}
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."I can "..parse[0].." "..parse[1].." for you.")
                    elseif parse[1] == "blacklist" then
                        WFblacklist = {}
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."I can "..parse[0].." "..parse[1].." for you.")
                    elseif parse[1] == "phrases" then
                        WFblacklistPhrases = {}
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."I can "..parse[0].." "..parse[1].." for you.")
                    elseif parse[1] == "error" then
                        WFblacklistUIError = {}
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."I can "..parse[0].." "..parse[1].." for you.")
                    elseif parse[1] == "highlight" then
                        WFHighlightlist = {}
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."I can "..parse[0].." "..parse[1].." for you.")
                    elseif parse[1] == "autoinv" then
                        WFautoinvList = nil
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."I can "..parse[0].." "..parse[1].." for you.")
                    else
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."What do you want me to "..parse[0].."? /wf "..parse[0].." whitelist | blacklist | phrases | error | highlight")
                    end
                    
                    return
                end
                if parse[0] == "debug" then
                    if debug then
                        debug = false
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."GJ! We did it! Finally no more insects in here. Love ya <3")
                    else
                        debug = true
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Don't worry. Lets kill those bugs together. :*")
                    end
                    if type(ChatFrame_MessageEventHandler) ~= "nil" then
                        ChatFrame_MessageEventHandler = ChatFilter
                    elseif type(ChatFrame_OnEvent) ~= "nil" then
                        ChatFrame_OnEvent = ChatFilter
                    end
                    
                    return
                end
                if i > -1 then
                    if parse[0] == "level" then
                        if tonumber(parse[1]) then
                            local number = tonumber(parse[1])
                            if number > 0 and number < 61 then
                                DEFAULT_CHAT_FRAME:AddMessage(whisp.."Level limit set to: "..number)
                                local i=1
                                while i <= table.getn(WFwhitelist) do
                                    if WFwhitelist[i][2] < number then
                                        if debug then
                                            DEFAULT_CHAT_FRAME:AddMessage("REMOVED PLAYER "..WFwhitelist[i][1])
                                        end
                                        table.remove(WFwhitelist,i) 
                                    else
                                        i = i + 1
                                    end

                                end
                                ignoreUntilLvl = number
                                if type(ChatFrame_MessageEventHandler) ~= "nil" then
                                    ChatFrame_MessageEventHandler = ChatFilter
                                elseif type(ChatFrame_OnEvent) ~= "nil" then
                                    ChatFrame_OnEvent = ChatFilter
                                end
                            else
                                DEFAULT_CHAT_FRAME:AddMessage(whisp.."You must enter number in range <1,60>!")
                            end
                        else
                            DEFAULT_CHAT_FRAME:AddMessage(whisp.."Current level is set to: "..ignoreUntilLvl)
                        end
                    else
                        DEFAULT_CHAT_FRAME:AddMessage(whisp.."Unknown command. List of commands: level <number>, clean <whitelist | blacklist>, ignore, debug, show <whitelist | blacklist>. :D That's all.")
                    end
                end
            end

            local function ignoreHandler(msg, editbox)
                if WFignoreDisabled then
                    DEFAULT_CHAT_FRAME:AddMessage(whisp.."Ignore function is disabled. You can enable it by /wf ignore.")
                else
                    local parse = {}
                    local i = -1
                    for cmd in string.gfind(msg, "[^%s]+") do
                        i = i +1
                        parse[i] = cmd
                    end
                    if i > -1 then
                        if parse[0] ~= nil then
                            local name = string.upper(string.sub(parse[0],1,1))..string.sub(parse[0],2,strlen(parse[0]))
                            local i=1
                            local found = false
                            while i <= table.getn(WFblacklist) do
                                if WFblacklist[i] == name then
                                    found = true
                                    break
                                else
                                    i = i + 1
                                end
                            end
                            if found then
                                table.remove(WFblacklist,i) 
                                DEFAULT_CHAT_FRAME:AddMessage("\124cfffffb00\124h"..name.." is no longer being ignored.")
                            else    
                                table.insert(WFblacklist, name)
                                DEFAULT_CHAT_FRAME:AddMessage("\124cfffffb00\124h"..name.." is now being ignored.")
                            end
                        end
                    end
                end
            end

            local function reloadHandler(msg, editbox)
                ConsoleExec("reloadui")
            end
            SlashCmdList["WHISPERFILTER"] = whisperHandler;
            SlashCmdList["IGNOREFILTER"] = ignoreHandler;
            SlashCmdList["RELOAD"] = reloadHandler;
        end 
    end     
end
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", onevent)

