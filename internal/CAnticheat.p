/*
	@file: /internal/CAnticheat.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define MAX_CONNECTIONS_FROM_IP (2)
#define CAC_SOBEIT_VERSION "0.3x"

stock CAnticheat_Init() 
{
	printf("[CAnticheat]: Loaded correctly");
}

stock CAnticheat_Exit() 
{
	printf("[CAnticheat]: Unloaded correctly!");
}

stock CAnticheat_CheckConnectPlayer(playerid) 
{
	new tmpAC[16], numPlayersOnIP=0;
	
	GetPlayerVersion(playerid, tmpAC, sizeof(tmpAC));
	if(!strcmp(tmpAC, CAC_SOBEIT_VERSION)) 
	{
		return true;
	}
	
	GetPlayerIp(playerid, tmpAC, 16);
	numPlayersOnIP=CAC_GetNumPlayerFromOnIP(tmpAC);
	if(numPlayersOnIP>MAX_CONNECTIONS_FROM_IP) 
	{
		printf("[CAnticheat]: Connecting player (%d) exceeded %d IP connections from %s", playerid, MAX_CONNECTIONS_FROM_IP, tmpAC);
		return true;
	}
	return false;
}

static stock CAC_GetNumPlayerFromOnIP(const ip[]) 
{
	new tmpIP[16], ip_count=0;
	theplayer::foreach(i) 
	{
		GetPlayerIp(i, tmpIP, 16);
		if(!strcmp(tmpIP, ip)) ip_count++;
	}
	return ip_count;
}

#undef MAX_CONNECTIONS_FROM_IP