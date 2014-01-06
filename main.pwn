/*
	@name project: EggplantDM
	@desc: Stworzono na potrzeby serwera Infinity-Gaming.net DM
	
	@authors:
		- l0nger <l0nger.programmer@gmail.com>
		- Pamdex <pamdex@myotherworld.net>
		- Andrew <andx98@wp.pl>
		- Robertson <do uzupelnienia>
		- Bantu <bantu3i5@tlen.pl>
		- _l0stfake7 <barpon@gmail.com>
		- Very special thanks to: SA-MP Team, Y_Less, Incognito, Slice, Sacky, Promsters, and others...
	
	@version: 0.1 pre-alpha
	@licence: GPLv2
*/

#define SCRIPT_VERSION "0.1 pre-alpha"
#define _DEBUG 1
#pragma dynamic 4096

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

#include "header"
#include "internal/CLogging.p"
#include "internal/CUtility.p"
#include "internal/CMySQL.p"
#include "internal/CConfigData.p"
#include "internal/CAccounts.p"

main() return 0;

public OnGameModeInit() {
	CExecTick_begin(scriptInit);
	
	// przyklad uzywania duracji:
	printf("duration time: %d", DURATION(2 days, 3 hour, 20 minutes, 40 seconds));
	
	djson_GameModeInit();
	djStyled(true);
	
	CLogging_Init();
	CConfigData_Init();
	CConfigData_Load();
	
	printf("[EggplantDM "SCRIPT_VERSION"]: Loaded successfully in %.2f ms!", float(CExecTick_end(scriptInit))/1000.0);
	CLogging_Insert(CLOG_SERVER, "Starting logging...");
	return 1;
}

public OnGameModeExit() {
	CLogging_Insert(CLOG_SERVER, "Terminating logging...");
	CLogging_Exit();
	CMySQL_Exit();
	regex_delete_all();
	djson_GameModeExit();
	return 1;
}

public OnPlayerConnect(playerid) {
	if(playerid>MAX_PLAYERS) {
		SendClientMessage(playerid, -1, "Serwer osiagnal limit graczy. This server is full.");
		theplayer::kick(playerid);
		return 0;
	}
	
	utility::resetVariablesInEnum();
	GetPlayerName(playerid, PlayerData[playerid][epd_nickname], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerData[playerid][epd_addressIP], 16);
	
	if(ServerData[esd_codeDebugger]>2) {
		CLogging_Insert(CLOG_DEBUG, "Player %s (ID: %d) (IP: %s) has connect to the server", PlayerData[playerid][epd_nickname], playerid, PlayerData[playerid][epd_addressIP]);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	if(ServerData[esd_codeDebugger]>2) {
		CLogging_Inset(CLOG_DEBUG, "Player %s (R: %d) (ID: %d) (IP: %s) leave from server", PlayerData[playerid][epd_nickname], reason, playerid, PlayerData[playerid][epd_addressIP]);
	}
	return 1;
}

public OnPlayerSpawn(playerid) {
	if(ServerData[esd_codeDebugger]>2) {
		CLogging_Insert(CLOG_DEBUG, "Player %d spawned", playerid);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid) {
	if(ServerData[esd_codeDebugger]>2) {
		CLogging_Insert(CLOG_DEBUG, "Player %d requesting class needed", playerid);
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid) {
	if(ServerData[esd_codeDebugger]>2) {
		CLogging_Insert(CLOG_DEBUG, "Player %d requesting spawn needed", playerid);
	}
	return 1;
}

