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
		- Very special thanks to: SA-MP Team, Y_Less, Incognito, Sacky, Promsters, and others...
	
	@version: 0.1 pre-alpha
	@licence: GPLv2
*/

#define SCRIPT_VERSION "0.1 pre-alpha"
#define _DEBUG 1

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

#include "header"
#include "internal/CUtility.p"
#include "internal/CMySQL.p"
#include "internal/CConfigData.p"

main() return 0;

public OnGameModeInit() {
	CExecTick_begin(scriptInit);
	
	djson_GameModeInit();
	djStyled(true);
	
	CConfigData_Init();
	CConfigData_Load();
	
	printf("[EggplantDM "SCRIPT_VERSION"]: Loaded successfully in %.2f ms!", float(CExecTick_end(scriptInit))/1000.0);
	return 1;
}

public OnGameModeExit() {

	CMySQL_Exit();
	djson_GameModeExit();
	return 1;
}