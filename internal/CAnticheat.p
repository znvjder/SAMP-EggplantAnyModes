/*
	@file: /internal/CAnticheat.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define MAX_CONNECTIONS_FROM_IP (2)

enum (<<=1) // from fs_cheat
{
	CHEAT_TYPE_unkown=1,
	CHEAT_TYPE_s0beit,
	CHEAT_TYPE_raksamp,
	CHEAT_TYPE_cleo
};

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
	new tmpAC[25], numPlayersOnIP=0;
	
	/*printf("\nPobieranie informacji o graczu %d", playerid);
	NetStats_GetIpPort(playerid, tmpAC, sizeof(tmpAC));
	printf("GetPlayerPort: %s", tmpAC);
	printf("BytesReceived: %d", NetStats_BytesReceived(playerid));
	printf("BytesSent: %d", NetStats_BytesSent(playerid));
	printf("MessagesSent: %d", NetStats_MessagesSent(playerid));
	printf("MessagesReceived: %d", NetStats_BytesReceived(playerid));
	printf("GetConnectedTime: %d", NetStats_GetConnectedTime(playerid));
	printf("ConnectionSatatus: %d", NetStats_ConnectionStatus(playerid));
	printf("--------------------------");*/
	
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