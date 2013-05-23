--[[ =================================================================
    Description:
        All globals used within MailTips.
    ================================================================= --]]

-- Colors used within MailTips
    C_GREEN  = "|cFF00FF00";
    C_CLOSE  = "|r";

-- Global variables
    MT = _G[ "MailTips" ]; -- AddOn object itself
    MT_NAME = GetAddOnMetadata( "MailTips", "Title" );
    MT_VERSION = GetAddOnMetadata( "MailTips", "Version" );

-- Mail items
    items = {};

-- Hook related stuff
    MT_Hooks = {};
    MT_Hooks["InboxFrameItem_OnEnter"] = {};
