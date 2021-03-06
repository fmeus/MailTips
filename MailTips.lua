--[[ =================================================================
    Description:
        MailTips shows you what is attached to a mail without having
        to open the message by hovering over a message in your
        mailbox.

    Dependencies:
        None

    Credits:
        A big 'Thank You' to all the people at Blizzard Entertainment
        for making World of Warcraft.
    ================================================================= --]]

-- Send message to the default chat frame
    function MailTips_Message( msg, prefix )
        -- Initialize
        local prefixText = "";

        -- Add application prefix
        if ( prefix and true ) then
            prefixText = C_GREEN.."MT: "..C_CLOSE;
        end;

        -- Send message to chatframe
        DEFAULT_CHAT_FRAME:AddMessage( prefixText..( msg or "" ) );
    end;

-- Add attached items to tooltip
    function MailTips_OnEnter( self )
        -- Initialize
        local tooltip = GameTooltip;
        local items = items;
        local itemName, itemTexture, itemCount, itemQuality, canUse, itemid, r, g, b, hex;
        local vendorvalue = 0;

        -- Clear data
        wipe( items );

        -- Mail info
        local itemAttached = select( 8, GetInboxHeaderInfo( self.index ) );

        -- Add enclosed items to tooltip
        if ( itemAttached ) then
            -- Group items by name
            for attachID = 1, 12 do
                -- Attachment info
                itemName, itemid, _, itemCount = GetInboxItem( self.index, attachID );

                -- Add it to the tooltip
                if ( itemCount and itemCount > 0 ) then
                    items[itemid] = ( items[itemid] or 0 ) + itemCount;
                end;
            end;

            -- Add items to tooltip
            if ( itemAttached > 1 ) then
                tooltip:AddLine( "|n"..MT_ENCLOSED_ITEMS );
                for key, value in pairs( items ) do
                    itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, sellPrice = GetItemInfo( key );
                    r, g, b, hex = GetItemQualityColor( itemQuality );
                    tooltip:AddDoubleLine( "  |T"..itemTexture..":0|t "..itemName, value, r, g, b );
                    vendorvalue = vendorvalue + ( value * sellPrice );
                end;

                -- Vendor value
                if ( vendorvalue > 0 ) then
                    tooltip:AddLine( "|n" );
                    tooltip:AddDoubleLine( BT_VENDORVALUE, GetCoinTextureString( vendorvalue ) );
                end;

                -- Forces tooltip to properly resize
                tooltip:Show();
            end;
        end;
    end;

-- Install all of the hooks used by MailTips
    function MailTips_Install_Hooks()
        -- Show startup message
        MailTips_Message( MT_STARTUP_MESSAGE, false );

        -- Save original OnEnter function
        MT_Hooks["InboxFrameItem_OnEnter"] = InboxFrameItem_OnEnter;

        -- Set new OnEnter function
        function InboxFrameItem_OnEnter( ... )
            MT_Hooks["InboxFrameItem_OnEnter"]( ... );
            MailTips_OnEnter( ... );
        end;
    end;
