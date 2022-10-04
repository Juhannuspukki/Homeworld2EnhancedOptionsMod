-- =============================================================================
-- Homeworld 2 Clean Data Resource Project
-- By S110
-- Version 1.0
-- 02/06/2010
-- Tools used: EditPad Lite, LuaDC version 0.9.19, and Cold Fusion LUA Decompiler v1.0.0
-- =============================================================================

GUID = {110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12}

GameRulesName = "$3203"

Description = "$3230"

GameSetupOptions = {
{name = "resources",
	locName = "$3240",
	tooltip = "$3239",
	default = 1,
	visible = 1,
	choices = {"$3241", "0.5", "$3242", "1.0", "$3243", "2.0"},},
{name = "unitcaps",
	locName = "$3214",
	tooltip = "$3234",
	default = 1,
	visible = 1,
	choices = {
		"$3215", "Small",
		"$3216", "Normal",
		"$3217", "Large", 
		"2x High", "Very Large",
		"2x High (No Strikecraft)", "Very Large No Strikecraft",
		"2x High (No Frigates)", "Very Large No Frigates",
		"2x High (No Battle Capitals)", "Very Large No Battle Capitals",
		"2x High (No Battlecruisers)", "Very Large No Battlecruisers",
		"2x High (Flagships)", "Very Large Flagships",
		"Nearly Unlimited", "Unlimited"
	},},
{name = "resstart",
	locName = "$3205",
	tooltip = "$3232",
	default = 2,
	visible = 1,
	choices = {
		"None (1)", "1", 
		"$3206", "1000", 
		"Default (3500)", "3500",
		"Medium (5000)", "5000",
		"$3208", "10000",
		"Very High (20000)", "20000",
		"Extremely High (50000)", "50000",
		"Ultra High (100000)", "100000",
		"Nearly Unlimited (1000000)", "1000000",
		"$3209", "0",
	},},
{name = "startwith",
	locName = "Starting Fleet",
	tooltip = "SELECT A STARTING FLEET CONFIGURATION",
	default = 3,
	visible = 1,
	choices = {
		"Mothership", "mothership",
		"Shipyard", "shipyard",
		"2x Carrier", "carriers",
		"Mothership + Carrier", "default",
		"Shipyard + Carrier", "shipyardAndCarrier",
		"Mothership + Shipyard + Carrier", "defaultAndShipyard"
	 },},
{name = "resourcecollectors",
	locName = "Resource Collectors",
	tooltip = "SELECT THE NUMBER OF RESOURCE COLLECTORS PLAYERS START WITH",
	default = 2,
	visible = 1,
	choices = {
		"0", "00",
		"3", "03",
		"6", "06",
		"9", "09",
		"12", "12",
		"15", "15"
	},},
{name = "mobilerefineries",
	locName = "Mobile Refineries",
	tooltip = "SELECT THE NUMBER OF MOBILE REFINERIES PLAYERS START WITH",
	default = 0,
	visible = 1,
	choices = {
		"0", "00",
		"1", "01",
		"2", "02"
	},},
{name = "progenitors",
	locName = "Progenitor Ships",
	tooltip = "SELECT THE PROGENITOR SHIPS PLAYERS START WITH",
	default = 0,
	visible = 1,
	choices = {
		"None", "0",
		"Dreadnaught", "1",
		"Sajuuk", "2",
		"Dreadnaught + Sajuuk", "3"
	},},
{name = "lockteams",
	locName = "$3220",
	tooltip = "$3235",
	default = 0,
	visible = 1,
	choices = {"$3221", "yes", "$3222", "no"},},
{name = "startlocation",
	locName = "$3225",
	tooltip = "$3237",
	default = 0,
	visible = 1,
choices = {"$3226", "random", "$3227", "fixed"},},}

dofilepath("data:scripts/scar/restrict.lua")

function OnInit()
	MPRestrict();
	Rule_Add("MainRule")

	--fleet setup
	local startingFleetSuffix = GetGameSettingAsString("startwith");
	local resourceCollectorSuffix = GetGameSettingAsString("resourcecollectors");
	local mobileRefinerySuffix = GetGameSettingAsString("mobilerefineries");
	local progenitorSuffix = GetGameSettingAsString("progenitors");

	SetStartFleetSuffix("+name=" .. startingFleetSuffix .. "+collectors=" .. resourceCollectorSuffix .. "+refineries=" .. mobileRefinerySuffix .. "+progenitors=" .. progenitorSuffix)
end

function MainRule()
	local playerIndex = 0;
	local playerCount = Universe_PlayerCount();
	while (playerIndex < playerCount) do
	if (Player_IsAlive(playerIndex) == 1 and Player_HasShipWithBuildQueue(playerIndex) == 0) then
	Player_Kill(playerIndex)
	end
	playerIndex = playerIndex + 1
	end
	local numAlive = 0;
	local numEnemies = 0;
	local gameOver = 1;
	playerIndex = 0
	while (playerIndex < playerCount) do
	if (Player_IsAlive(playerIndex) == 1) then
	local otherPlayerIndex = 0;
	while (otherPlayerIndex < playerCount) do
	if (AreAllied(playerIndex, otherPlayerIndex) == 0 and Player_IsAlive(otherPlayerIndex) == 1) then
	gameOver = 0
	else
	numEnemies = numEnemies + 1
	end
	otherPlayerIndex = otherPlayerIndex + 1
	end
	numAlive = numAlive + 1
	end
	playerIndex = playerIndex + 1
	end
	if (numEnemies == 0 and numAlive > 0) then
	gameOver = 0
	end
	if (gameOver == 1) then
	Rule_Add("waitForEnd")
	Event_Start("endGame")
	Rule_Remove("MainRule")
	end
end

function waitForEnd()
	if (Event_IsDone("endGame")) then
	setGameOver()
	Rule_Remove("waitForEnd")
	end
end

Events = {}
Events["endGame"] = {{{"wID = Wait_Start(5)", "Wait_End(wID)"},},}
