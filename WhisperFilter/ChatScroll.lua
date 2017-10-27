
local scroll = {}
scroll.normal = 1
scroll.shift = 5

function ChatFrame_OnMouseWheel(chatFrame, delta)
    if delta<0 then
        if IsControlKeyDown() then
            chatFrame:ScrollToBottom()
        else
            if IsShiftKeyDown() then
                for i=1, scroll.shift do
                    chatFrame:ScrollDown()
                end
            else
                for i=1, scroll.normal do
                    chatFrame:ScrollDown()
                end
            end
        end
    else
        if IsControlKeyDown() then
            chatFrame:ScrollToTop()
        else
            if IsShiftKeyDown() then
                for i=1, scroll.shift do
                    chatFrame:ScrollUp()
                end
            else
                for i=1, scroll.normal do
                    chatFrame:ScrollUp()
                end
            end
        end
    end
    
end