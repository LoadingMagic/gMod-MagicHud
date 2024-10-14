MagicHud = {}
MagicHud.HealthColor = Color(255, 0, 40, 200) -- MAIN HUD SECTION COLORS.
MagicHud.ArmorColor = Color(0, 85, 155, 200) -- MAIN HUD SECTION COLORS.
MagicHud.JobColor = Color(0, 255, 0) -- MAIN HUD SECTION COLORS.
MagicHud.MoneyColor = Color(0, 255, 0) -- MAIN HUD SECTION COLORS.
MagicHud.SalaryColor = Color(0, 255, 0) -- MAIN HUD SECTION COLORS.
MagicHud.BarXPos = 5
MagicHud.ShowBackground = true -- DISABLES THE HUD BACKGROUND.
MagicHud.EnableHUD = true -- DISABLES THE ENTIRE HUD.
MagicHud.EnableOverheadHUD = true -- DISABLES THE OVERHEAD HUD.
MagicHud.EnableRankDisplay = true -- DISABLES RANK DISPLAY ABOVE HEAD.
MagicHud.EnableLockdownNotification = true -- DISABLES LOCKDOWN NOTIFICATION.
MagicHud.EnableArrestedNotification = true -- DISABLES ARRESTED NOTIFICATION.
MagicHud.EnableAgenda = true -- DISABLES AGENDA.
MagicHud.SandboxMode = false -- DONT WANT DARKRP FEATURES ENABLE THIS FOR SANDBOX.
MagicHud.EnableTopRightTextCycle = false -- THIS FALSE WILL MAKE IT SO THE FIRST MESSAGE HERE IS ONLY SHOW.
MagicHud.TopRightTextColor = Color(255, 255, 255) -- COLOR OF THE TEXT.
MagicHud.TopRightTextInterval = 1 -- THE TIME THAT EACH MESSAGE IS ROTATED.
MagicHud.TopRightTexts = {
    "CHECKOUT OUR WWW.WEBSITE.COM", 
    "CHECKOUT OUR STEAMGROUP WWW.STEAMGROUPLINK.COM",
    "SEEING ERRORS? WHY NOT CHECKOUT OUR WORKSHOP COLLECTION.",
    "WELCOME TO OUR SERVER, WE HOPE YOU ENJOY YOUR STAY!",
    "REMEMBER TO VIEW THE RULES BY USING !MOTD"
}
--[[ EXAMPLE YOU CAN ADD MORE RANKS.
    user = { -- ULX RANK NAME CASE SENSITIVE.
        DisplayName = "User", -- THIS WILL RENAME THE TEXT OF THE RANK GMOD MAKING "user" LOOKS BAD SO THIS FIXES IT MAKES IT "User".
        Color = Color(255, 255, 255), -- COLOR OF THE RANK TEXT ABOVE HEAD.
        Icon = "icon16/user.png", -- REMOVE THIS LINE TO REMOVE THE ICON. ADD NEW ICONS OR USE ICON16 FACEPUNCH ALREADY ADDED THESE.
		RainbowColor = false -- WHY NOT.
    },
]]-- END OF EXAMPLE.
MagicHud.RankSettings = {
    user = {
        DisplayName = "User",
        Color = Color(255, 255, 255),
        Icon = "icon16/user.png",
		RainbowColor = false
    },
    vip = {
        DisplayName = "VIP",
        Color = Color(255, 255, 0),
        Icon = "icon16/star.png", 
        RainbowColor = true
    },
    superadmin = {
        DisplayName = "SuperAdmin",
        Color = Color(255, 0, 0),
        Icon = "icon16/shield.png",
		RainbowColor = true
    },
    admin = {
        DisplayName = "Admin",
        Color = Color(255, 0, 0),
        Icon = "icon16/shield.png",
		RainbowColor = true
    },
    operator = {
        DisplayName = "Operator",
        Color = Color(255, 0, 0),
        Icon = "icon16/shield.png",
		RainbowColor = true
    }
}
