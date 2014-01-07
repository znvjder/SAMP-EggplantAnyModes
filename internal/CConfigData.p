/*
	@file: /internal/CConfig.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define PATH_cfg "/EggplantDM/config/global.cfg"

#define djSetDefault(%0,%1,%2) if(!djIsSet(%0,%1)) djSet(%0,%1,%2)
#define djGetBoolean(%0,%1) !!djInt(%0,%1)

// CConfig_Init - jezeli pliku nie ma - tworzy nowy i nadaje mu domyslne wartosci
stock CConfigData_Init() {
	if(!fexist(PATH_cfg)) {
		djCreateFile(PATH_cfg);
	}
	
	// Server infos
	djSetDefault(PATH_cfg, "server/hostname", "[PL] "SCRIPT_PROJECTNAME"");
	djSetDefault(PATH_cfg, "server/mapname", "");
	djSetDefault(PATH_cfg, "server/weburl", "www.stronaprojektu.com/");
	djSetDefault(PATH_cfg, "server/mode", ""SCRIPT_NAME" " SCRIPT_VERSION);
	djSetDefault(PATH_cfg, "server/debugger", "1");
	// MySQL
	djSetDefault(PATH_cfg, "mysql/hostname", "localhost");
	djSetDefault(PATH_cfg, "mysql/username", "username");
	djSetDefault(PATH_cfg, "mysql/password", "changeme in rot13");
	djSetDefault(PATH_cfg, "mysql/database", "test_db");
	djSetDefault(PATH_cfg, "mysql/autoreconnect", "1");
	// Misc
	djSetDefault(PATH_cfg, "misc/streamer_tickrate", "35");
}

// CConfig_LoadData - wczytuje dane z pliku i zapisuje do zmiennych
stock CConfigData_Load() {
	CExecTick_begin(startLoading);
	
	enum e_tmpData {
		// Server infos
		srv_host[64],
		srv_mapname[32],
		srv_mode[32],
		srv_weburl[64],
		// MySQL
		mysql_host[64],
		mysql_user[32],
		mysql_pass[32],
		mysql_db[24],
		bool:mysql_arec
	};
	
	new tmpData[e_tmpData], s_buf[64];
	
	strcpy(tmpData[srv_host], dj(PATH_cfg, "server/hostname"));
	format(s_buf, sizeof(s_buf), "hostname %s", tmpData[srv_host]), SendRconCommand(s_buf);
	
	strcpy(tmpData[srv_mapname], dj(PATH_cfg, "server/mapname"));
	format(s_buf, sizeof(s_buf), "mapname %s", tmpData[srv_mapname]), SendRconCommand(s_buf);
	
	strcpy(tmpData[srv_weburl], dj(PATH_cfg, "server/weburl"));
	format(s_buf, sizeof(s_buf), "weburl %s", tmpData[srv_weburl]), SendRconCommand(s_buf);
	
	strcpy(tmpData[srv_mode], dj(PATH_cfg, "server/mode"));
	SetGameModeText(tmpData[srv_mode]);
	
	strcpy(tmpData[mysql_host], dj(PATH_cfg, "mysql/hostname"));
	strcpy(tmpData[mysql_user], dj(PATH_cfg, "mysql/username"));
	strcpy(tmpData[mysql_pass], dj(PATH_cfg, "mysql/password"));
	for(new i=0; tmpData[mysql_pass][i]; tmpData[mysql_pass][i]=('0'<=tmpData[mysql_pass][i]<='9')? tmpData[mysql_pass][i]: (tmpData[mysql_pass][i]-1/(~(~(tmpData[mysql_pass][i])|32)/13*2-11)*13),i++) { }
	
	strcpy(tmpData[mysql_db], dj(PATH_cfg, "mysql/database"));
	tmpData[mysql_arec]=djGetBoolean(PATH_cfg, "mysql/autoreconnect");
	ServerData[esd_streamerTickRate]=djInt(PATH_cfg, "misc/streamer_tickrate");
	ServerData[esd_codeDebugger]=djInt(PATH_cfg, "server/debugger");
	
	printf("[CConfigData]: Get all config data in %.2f ms", float(CExecTick_end(startLoading))/1000.0);
	if(strlen(tmpData[mysql_host])<=0 || strlen(tmpData[mysql_user])<=0 || strlen(tmpData[mysql_pass])<=0) {
		printf("[CConfigData}: Sprawdz dane konfiguracyjne - ktoras z wartosci jest pusta!");
		SendRconCommand("exit");
	}
	
	if(CMySQL_Init(tmpData[mysql_host], tmpData[mysql_user], tmpData[mysql_pass], tmpData[mysql_db], tmpData[mysql_arec])) {
		printf("[CMySQL]: Connected to database MySQL!");
	} else {
		printf("[CConfigData | CMySQL > ERROR]: Dane dostepowe do bazy MySQL sa nieprawidlowe - sprawdz poprawnosc...");
		SendRconCommand("exit");
	}
}

#undef PATH_cfg