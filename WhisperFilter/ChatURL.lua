function URLreplace (chatstring)
    if chatstring ~= nil then
        -- www.X.Y url
        chatstring = string.gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", generateURL("www.%1.%2"))
        
        -- X://Y url
        chatstring = string.gsub (chatstring, " (%a+)://(%S+)%s?", generateURL("%1://%2"))

        -- X@X.Y url (---> email)
        chatstring = string.gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)%.([_A-Za-z0-9-%.]+)%s?", generateURL("%1@%2.%3"))

        -- XXX.YYY.ZZZ.WWW:VVVV url (IP of ts server for example)
        chatstring = string.gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", generateURL("%1.%2.%3.%4:%5"))

        -- XXX.YYY.ZZZ.WWW url (---> IP)
        chatstring = string.gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", generateURL("%1.%2.%3.%4"))

        -- X.Y.Z url
        chatstring = string.gsub (chatstring, " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?", generateURL("%1.%2.%3"))

        -- X.Y.Z:WWWW url  (ts server for example)
        chatstring = string.gsub (chatstring, " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?", generateURL("%1.%2.%3:%4"))

    end
    return chatstring
end

function generateURL(link)
    local returnedLink = " "
    returnedLink = returnedLink .. "|Hurl:" .. link .. "|h"

    returnedLink = returnedLink .. "[" .. link .. "]"

    returnedLink = returnedLink .. "|h|r "

    return returnedLink
end

function PopupURL(link)
    StaticPopupDialogs["SHOW_URL"] = {
        text = "URL : %s",
        button2 = TEXT(ACCEPT),
        hasEditBox = 1,
        hasWideEditBox = 1,
        showAlert = 1, -- HACK : it"s the only way I found to make de StaticPopup have sufficient width to show WideEditBox :(

        OnShow = function()
            local editBox = getglobal(this:GetName().."WideEditBox");
            editBox:SetText(format(link));
            editBox:SetFocus();
            editBox:HighlightText(0);

            local button = getglobal(this:GetName().."Button2");
            button:ClearAllPoints();
            button:SetWidth(200);
            button:SetPoint("CENTER", editBox, "CENTER", 0, -30);

            getglobal(this:GetName().."AlertIcon"):Hide();  -- HACK : we hide the false AlertIcon
        end,

        OnHide = function() end,
        OnAccept = function() end,
        OnCancel = function() end,
        EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1
    };

    StaticPopup_Show ("SHOW_URL", link);
end