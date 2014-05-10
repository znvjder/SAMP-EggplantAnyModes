/*
	@name project: EggplantDM
	@desc: Projekt "nuda".
	
	@authors:
		- l0nger <l0nger.programmer@gmail.com>
		- Pamdex <pamdex@myotherworld.net>
		- Andrew <andx98@wp.pl>
		- Roberson <do uzupelnienia>
		- Bantu <bantu3i5@tlen.pl>
		- _l0stfake7 <barpon@gmail.com>
		- _Macias_, <maciekgl@o2.pl>
		- Very special thanks to: SA-MP Team, Y_Less, Incognito, Slice, Sacky, Promsters, and others...
	
	@version: 0.1 pre-alpha
	@licence: GPLv2
	@link package: https://github.com/l0nger/SAMP-EggplantDM
*/

#pragma dynamic 4096
#pragma semicolon true
#pragma pack false

#define SCRIPT_PROJECTNAME "Infinity-Gaming.net DM"
#define SCRIPT_NAME	"EggplantDM"
#define SCRIPT_VERSION "0.1 pre-alpha"

#include <a_samp>

#undef MAX_PLAYERS
#define CFG_PLAYERS (50)
#define MAX_PLAYERS CFG_PLAYERS

#include "external/mysql"
#include "external/sscanf"
#include "external/streamer"
#include "external/audio"
#include "external/regex"
#include "external/djson"
#include "external/YSI\y_va"
#include "external/zcmd"

#include "header"
#include "internal/CLogging.p"
#include "internal/CPlayer.p"
#include "internal/CUtility.p"
#include "internal/CMySQL.p"
#include "internal/CConfigData.p"
#include "internal/CAudio.p"
#include "internal/CNetwork.p"
#include "internal/CMessages.p"
#include "internal/CAnticheat.p"
#include "internal/CAccounts.p"
#include "internal/CVehicles.p"
#include "internal/CTextdraws.p"
#include "internal/attractions/header.p"
#include "internal/CFriends.p"
#include "internal/CEntries.p"
#include "internal/CAtms.p"
#include "internal/CMapicons.p"
#include "internal/CWeather.p"
#include "internal/CTimers.p"
#include "internal/CObjects.p"

#include "internal/commands/cmds_header.p"

main() return 0;

public OnGameModeInit() 
{
	CExecTick_begin(scriptInit);
		
	// przyklad uzywania duracji:
	// printf("duration time: %d", DURATION(2 days, 3 hour, 20 minutes, 40 seconds));
	
	/*new level=1;
	new RP=1000;
	level = 1*floatround(floatsqroot(RP)/10/2);
	new nextRP=RP+RP*4/2;
	printf("RP: %d, nextRP: %d, level: %d", RP, nextRP, level);*/
	
	djson_GameModeInit();
	djStyled(true);
	
	CLogging_Init();
	CConfigData_Init();
	CConfigData_Load();
	
	// SAMP configuration
	SetGravity(0.008);
	UsePlayerPedAnims();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	SendRconCommand("unbanip *.*.*.*");
	
	// Variables settings
	ServerData[esd_countPlayersOnline]=0;
	
	// Modules initialize
	network::setServerSyncRate(ServerData[esd_countPlayersOnline]);
	utility::addAllSkins();
	CAccounts_Init();
	CVehicles_Init();
	CEntries_Init();
	CAtms_Init();
	CMapicons_Init();
	CAudio_Init();
	CAttractions_Init();
	CTimers_Init();
	CObjects_Init();
	
	printf("["SCRIPT_NAME" "SCRIPT_VERSION"]: Loaded successfully in %.2f ms!", float(CExecTick_end(scriptInit))/1000.0);
	CLogging_Insert(CLOG_SERVER, "Starting logging...");
	if(ServerData[esd_codeDebugger] >= _DEBUG_EASY) 
	{
		CLogging_Insert(CLOG_DEBUG, "Debugging mode enabled...");
		printf("["SCRIPT_NAME" - Debugger]: Debug mode enabled. Level debugging: %d", ServerData[esd_codeDebugger]);
	}
	
	return 1;
}

public OnGameModeExit() 
{
	CLogging_Insert(CLOG_SERVER, "Terminating logging...");
	CLogging_Exit();
	CAccounts_Exit();
	CVehicles_Exit();
	CAtms_Exit();
	CEntries_Exit();
	CMapicons_Exit();
	CAudio_Exit();
	CAttraction_Exit();
	CObjects_Exit();
	CTimers_Exit();
	CMySQL_Exit();
	regex_delete_all();
	djson_GameModeExit();
	return 1;
}

public OnPlayerConnect(playerid) 
{
	if(CAnticheat_CheckConnectPlayer(playerid)) 
	{
		Kick(playerid);
		return false;
	}
	if(playerid>MAX_PLAYERS) 
	{
		SendClientMessage(playerid, -1, "[PL]: Serwer osiagnal limit graczy.");
		SendClientMessage(playerid, -1, "[ENG]: This server is full. Try again.");
		theplayer::kick(playerid);
		return false;
	}
	
	if(ServerData[esd_highestPlayerID]<playerid) ServerData[esd_highestPlayerID]=playerid;
	
	utility::getPlayersCount();
	network::setServerSyncRate(ServerData[esd_countPlayersOnline]);
	utility::resetVariablesInEnum(PlayerData[playerid], e_PlayerData);
	GetPlayerName(playerid, PlayerData[playerid][epd_nickname], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerData[playerid][epd_addressIP], 16);
	GetPlayerClientId(playerid, PlayerData[playerid][epd_serialID], 32);
	PlayerData[playerid][epd_ticklastUpdate]=GetTickCount();
	PlayerData[playerid][epd_lastArmour]=99.9;
	PlayerData[playerid][epd_lastArmour]=0.0;
	PlayerData[playerid][epd_properties]=PlayerProperties:PLAYER_NULL;
	bit_set(PlayerData[playerid][epd_properties], PLAYER_FIRSTSPAWN);
	
	if(ServerData[esd_codeDebugger] >= _DEBUG_NORMAL) 
	{
		CLogging_Insert(CLOG_DEBUG, "Player %s (ID: %d) (IP: %s) has connect to the server", PlayerData[playerid][epd_nickname], playerid, PlayerData[playerid][epd_addressIP]);
	}
	if(theplayer::isRegistered(playerid))
	{
		new serialLast[32], ipLast[16];
		string::copy(ipLast, theplayer::getAccountDataString(playerid, "ip_last"));
		string::copy(serialLast, theplayer::getAccountDataString(playerid, "serial_last"));
		
		if(!strcmp(PlayerData[playerid][epd_serialID], serialLast, false) && strcmp(PlayerData[playerid][epd_addressIP], ipLast, false) == 0) 
		{
			theplayer::onEventLogin(playerid, "autologin", true);
		} else {
			theplayer::showLoginDialog(playerid);
			PlayerData[playerid][epd_properties]=PLAYER_INLOGINDIALOG;
		}
	} else {
		theplayer::sendMessage(playerid, COLOR_INFO1, "Witamy na serwerze "SCRIPT_PROJECTNAME"!");
		theplayer::sendMessage(playerid, COLOR_INFO1, "System wykry�, �e nie posiadasz u nas konta. Aby je za�o�y� wpisz: <b>/rejestracja</b>");
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason) 
{
	for(new i=ServerData[esd_highestPlayerID]; i>=0 && IsPlayerConnected(i); i--) 
	{
		if(i != playerid || i==0) 
		{
			ServerData[esd_highestPlayerID]=i;
			break;
		}
	}
	utility::getPlayersCount();
	network::setServerSyncRate(ServerData[esd_countPlayersOnline]);
	
	if(ServerData[esd_codeDebugger] >= _DEBUG_NORMAL) 
	{
		CLogging_Insert(CLOG_DEBUG, "Player %s (R: %d) (ID: %d) (IP: %s) leave from server", PlayerData[playerid][epd_nickname], reason, playerid, PlayerData[playerid][epd_addressIP]);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid) 
{
	CheckPlayerBounds(playerid);
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG)) return false;
	
	if(classid==0 && PlayerData[playerid][epd_lastSkin]>0) 
	{
		// Wczytanie ostatniego skina
		SetPlayerSkin(playerid, PlayerData[playerid][epd_lastSkin]);
	}
	
	SetPlayerPos(playerid, 2004.7404,1913.8379,40.3516);
	SetPlayerFacingAngle(playerid,264.7556);
	//SetPlayerTime(playerid, 0,0);
	SetPlayerCameraPos(playerid,2013.6698,1913.9120,35.0304);	
	SetPlayerCameraLookAt(playerid, 2004.7404,1913.8379,40.3516);
	return 1;
}

public OnPlayerRequestSpawn(playerid) 
{
	CheckPlayerBounds(playerid);
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG)) 
	{
		theplayer::sendMessage(playerid, COLOR_ERROR, "Aby skorzysta� z tej funkcji musisz si� pierw zalogowa�.");
		return false;
	}
	
	if(ServerData[esd_codeDebugger] >= _DEBUG_NORMAL) 
	{
		CLogging_Insert(CLOG_DEBUG, "Player %d requesting spawn needed", playerid);
	}
	return 1;
}

public OnPlayerSpawn(playerid) 
{
	CheckPlayerBounds(playerid);
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG)) 
	{
		theplayer::hideDialog(playerid);
		theplayer::sendMessage(playerid, COLOR_ERROR, "Nie ma tak �atwo!");
		theplayer::kick(playerid);
		return false;
	}
	
	if(ServerData[esd_codeDebugger] >= _DEBUG_NORMAL) 
	{
		CLogging_Insert(CLOG_DEBUG, "Player %d spawned", playerid);
	}

	new tmpSkin=GetPlayerSkin(playerid);
	if(PlayerData[playerid][epd_lastSkin]!=tmpSkin) PlayerData[playerid][epd_lastSkin]=tmpSkin;
	
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_FIRSTSPAWN)) 
	{
		if(bit_if(PlayerData[playerid][epd_properties], PLAYER_ISLOGGED)) 
		{
			if(PlayerData[playerid][epd_spawnType]==0) {
				SetPlayerHealth(playerid, PlayerData[playerid][epd_lastHealth]);
				if(PlayerData[playerid][epd_lastArmour]>0) SetPlayerArmour(playerid, PlayerData[playerid][epd_lastArmour]);
				
				SetPlayerSkin(playerid, PlayerData[playerid][epd_lastSkin]);
				SetPlayerPos(playerid, PlayerData[playerid][epd_lastPos][0], PlayerData[playerid][epd_lastPos][1], PlayerData[playerid][epd_lastPos][2]);
				SetPlayerFacingAngle(playerid, PlayerData[playerid][epd_lastPos][3]);
			} else {
				// TODO: Wyszukanie domu i zespawnowanie gracza w domu
			}
			theplayer::loadWeaponsData(playerid);
			theplayer::loadAttachedObjects(playerid);
		} else {
			// wywolac dla niezarejestrowanego gracza "nowa gre" i krotki tutorial
			SetPlayerPos(playerid, 0.0, 0.0, 3.0);
			// startowy spawn - lotnisko LS
		}
		
		bit_unset(PlayerData[playerid][epd_properties], PLAYER_FIRSTSPAWN);
		if(bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP))
		{
			bit_set(PlayerData[playerid][epd_properties], PLAYER_SYNCACP);
			Audio_TransferPack(playerid);
		}
	} else {
		SetPlayerPos(playerid, PlayerData[playerid][epd_lastPos][0], PlayerData[playerid][epd_lastPos][1], PlayerData[playerid][epd_lastPos][2]);
		SetPlayerFacingAngle(playerid, PlayerData[playerid][epd_lastPos][3]);
	}
	SetCameraBehindPlayer(playerid);
	PlayerData[playerid][epd_ticklastUpdate]=GetTickCount();
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) 
{
	CheckPlayerBounds(playerid);
	if(killerid != INVALID_PLAYER_ID) 
	{
	
	} else {
	
	}
	return true;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) 
{
	CheckPlayerBounds(playerid);
	CheckVehicleBounds(vehicleid);
	
	new Float:tmpPP[3], Float:tmpVP[3];
	GetPlayerPos(playerid, tmpPP[0], tmpPP[1], tmpPP[2]);
	GetVehiclePos(vehicleid, tmpVP[0], tmpVP[1], tmpVP[2]);
	if(math::betweenDist3D(tmpPP[0], tmpPP[1], tmpPP[2], tmpVP[0], tmpVP[1], tmpVP[2])>=5.0)  // uniemozliwiamy wejscie jezeli gracz jest wiecej niz 5j od pojazdu
	{
		ClearAnimations(playerid);
		return false;
	}
	
	if(ispassenger) // wchodzi jako pasazer
	{
		if(bit_if(thevehicle::getProperties(vehicleid), VEHICLE_ISOWNED) && thevehicle::getOwner(vehicleid) != playerid)  // pojazd jest prywatny
		{
			switch(thevehicle_getDoorEnterType(vehicleid)) 
			{
				case VEHICLE_ENTER_NOBODY: 
				{
					ClearAnimations(playerid);
					return false;
				}
				case VEHICLE_ENTER_FRIENDS: 
				{
					
				}
				case VEHICLE_ENTER_GANGMEMBERS: 
				{
				
				}
				case VEHICLE_ENTER_ALL: 
				{
				
				}
			}
		}
	} else { // wchodzi jako kierowca
		if(bit_if(thevehicle::getProperties(vehicleid), VEHICLE_ISOWNED) && thevehicle::getOwner(vehicleid) != playerid)  // pojazd jest prywatny
		{
			switch(thevehicle_getDoorEnterType(vehicleid)) 
			{
				case VEHICLE_ENTER_NOBODY: 
				{
					ClearAnimations(playerid);
					return false;
				}
				case VEHICLE_ENTER_FRIENDS: 
				{
				
				}
				case VEHICLE_ENTER_GANGMEMBERS: 
				{
				
				}
				case VEHICLE_ENTER_ALL: 
				{
				
				}
			}
		}
	}
	return true;
}

public OnPlayerExitVehicle(playerid, vehicleid) 
{
	CheckPlayerBounds(playerid);
	CheckVehicleBounds(vehicleid);
	
	return true;
}

public OnPlayerStateChange(playerid, newstate, oldstate) 
{
	CheckPlayerBounds(playerid);
	switch(newstate)
	{
		case PLAYER_STATE_NONE:
		{
		
		}
		case PLAYER_STATE_DRIVER: 
		{
		
		}
		case PLAYER_STATE_PASSENGER: 
		{
		
		}
		case PLAYER_STATE_ONFOOT: 
		{
		
		}
		case PLAYER_STATE_SPAWNED: 
		{
		
		}
		case PLAYER_STATE_WASTED: 
		{
		
		}
		case PLAYER_STATE_SPECTATING: 
		{
		
		}
	}
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
	CheckPlayerBounds(playerid);
	
	return true;
}

public OnPlayerText(playerid, text[]) 
{
	CheckPlayerBounds(playerid);
	PlayerData[playerid][epd_ticklastUpdate]=GetTickCount();
	
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG)) 
	{
		theplayer::sendMessage(playerid, COLOR_ERROR, "Aby skorzysta� z tej funkcji musisz si� pierw zalogowa�.");
		return false;
	}
	
	return 0;
}

public OnPlayerUpdate(playerid) 
{
	PlayerData[playerid][epd_ticklastUpdate]=GetTickCount();
	
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
	CheckPlayerBounds(playerid);
	
	switch(dialogid) 
	{
		case DIALOG_BLANK: 
		{
			return true;
		}
		case DIALOG_LOGIN: 
		{
			if(!response) 
			{
				theplayer::hideDialog(playerid);
				theplayer::sendMessage(playerid, COLOR_INFO1, "Anulowa�e� logowanie - do zobaczenia ponownie!");
				theplayer::kick(playerid);
				return true;
			}
			theplayer::onEventLogin(playerid, inputtext);
		}
		case DIALOG_REGISTER: 
		{
			if(!response) 
			{
				theplayer::sendMessage(playerid, COLOR_INFO1, "Anulowa�e� rejestracje konta, pomy�l o tym jeszcze!");
				theplayer::hideDialog(playerid);
				return true;
			}
			theplayer::onEventRegister(playerid, inputtext);
		}
	}
	if(CFriends_DialogResponse(playerid, dialogid, response, listitem, inputtext)) return true;
	return false;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) 
{
	CheckPlayerBounds(playerid);
	
	return true;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{

	return true;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	
	return true;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	//printf("Player shoot (%d): weapon: %d, hittype: %d, hitid: %d, fX: %f, fY: %f, fZ: %f", playerid, weaponid, hittype, hitid, fX, fY, fZ);
	//printf("GetPlayerAspectRatio: %f, GetPlayerCameraZoom: %f", GetPlayerCameraAspectRatio(playerid), GetPlayerCameraZoom(playerid));
	return true;
}

public OnPlayerStreamIn(playerid, forplayerid) 
{
	CheckPlayerBounds(playerid);
	CheckPlayerBounds(forplayerid);
	
	return true;
}

public OnPlayerStreamOut(playerid, forplayerid) 
{
	CheckPlayerBounds(playerid);
	CheckPlayerBounds(forplayerid);
	
	return true;
}

public OnVehicleStreamIn(vehicleid, forplayerid) 
{
	CheckPlayerBounds(forplayerid);
	CheckVehicleBounds(vehicleid);
	
	return true;
}

public OnVehicleStreamOut(vehicleid, forplayerid) 
{
	CheckPlayerBounds(forplayerid);
	CheckVehicleBounds(vehicleid);
	
	return true;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
	CheckPlayerBounds(playerid);
	
	return true;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) 
{
	CheckPlayerBounds(playerid);
	
	return true;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) 
{
	CheckPlayerBounds(playerid);
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG)) 
	{
		theplayer::sendMessage(playerid, COLOR_ERROR, "Aby skorzysta� z tej funkcji musisz si� pierw zalogowa�.");
		return false;
	}
	return true;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) 
{
	CheckPlayerBounds(playerid);
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG)) 
	{
		theplayer::sendMessage(playerid, COLOR_ERROR, "Aby skorzysta� z tej funkcji musisz si� pierw zalogowa�.");
		return false;
	}
	return true;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid) 
{
	return true;
}

public OnVehicleSpawn(vehicleid) 
{
	return true;
}

public OnVehicleDeath(vehicleid, killerid) 
{
	return true;
}

public OnVehicleMod(playerid, vehicleid, componentid) 
{
	return true;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) 
{
	return true;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) 
{
	return true;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat) 
{

}

// Objects callbacks
public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	//printf("fX: %f, fy: %f, fz: %f, frx: %f, fry: %f, frz: %f", fX, fY, fZ, fRotX, fRotY, fRotZ);
	return true;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	return true;
}

// Streamer callbacks
public OnDynamicObjectMoved(objectid)
{
	
	return true;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{

	return true;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{

	return true;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(CEntries_EnterPlayerInElement(playerid, -1, pickupid)) return true;
	return false;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(CEntries_EnterPlayerInElement(playerid, checkpointid, -1)) return true;
	if(CAtms_EnterPlayerInElement(playerid, checkpointid)) return true;
	return false;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{

	return false;
}

public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{

	return false;
}

public OnPlayerLeaveDynamicRaceCP(playerid, checkpointid)
{

	return false;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(CAudio_IsPlayerInZone(playerid, true, areaid)) return true;
	return false;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(CAudio_IsPlayerInZone(playerid, false, areaid)) return true;
	return false;
}

// Timers callbacks
timer:GameLoop()
{
	ServerData[interval_gameLoop]=GetTickCount();
	#define diff_ms(%0,%1) (ServerData[interval_%0]-ServerData[interval_%1])
	
	if(diff_ms(gameLoop,attractionUpdate) >= DURATION_MS(1 second))
	{
		//printf("attractionUpdate: %d", diff_ms(gameLoop,saveStats)/1000);
		ServerData[interval_attractionUpdate]=GetTickCount();
	}
	if(diff_ms(gameLoop,statsUpdate) >= ((ServerData[esd_countPlayersOnline]>=90)? DURATION_MS(16 second): (ServerData[esd_countPlayersOnline]>=50)? DURATION_MS(12 second): DURATION_MS(6 second)))
	{
		//printf("statsUpdate: %d", diff_ms(gameLoop,saveStats)/1000);
		ServerData[interval_statsUpdate]=GetTickCount();
	}
	if(diff_ms(gameLoop,saveStats) >= ((ServerData[esd_countPlayersOnline]>=90)? DURATION_MS(20 minutes): (ServerData[esd_countPlayersOnline]>=50)? DURATION_MS(15 minutes): DURATION_MS(10 minutes)))
	{
		//printf("savestats: %d", diff_ms(gameLoop,saveStats)/1000);
		ServerData[interval_saveStats]=GetTickCount();
	}
	#undef diff_ms
}

timer:Weather()
{
	// odpalamy timer minute po rownej godzinie
	new minutes;
	gettime(_, minutes);
	CWeather_Update();
	CTimers_Call(TIMER_WEATHER, #@Weather, math::abs(minutes-60)+1*60*1000, false); 
}

// CAC callbacks
forward OnPlayerCheatDetected(playerid, cheatType);
public OnPlayerCheatDetected(playerid, cheatType)
{
	/*
		Funkcja bez dodania skryptu fs_cheat, ktory znajduje sie w katalogu filterscript
		nie bedzie dzialac poprawnie.
	*/
	switch(cheatType)
	{
		case CHEAT_TYPE_s0beit:
		{
			printf("Cheat detected - %d > cheat type: s0beit", playerid); 
		}
		case CHEAT_TYPE_raksamp:
		{
			printf("Cheat detected - %d > cheat type: raksamp", playerid); 
		}
		case CHEAT_TYPE_cleo:
		{
			printf("Cheat detected - %d > cheat type: cleo", playerid); 
		}
	}
}
