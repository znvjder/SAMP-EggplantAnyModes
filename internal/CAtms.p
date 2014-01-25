/*
	@file: /internal/CAtms.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define MAX_ATMS (20)
#define ATM_OBJECTID (2618)
#define ATM_MAPICON (52)

enum e_AtmsData
{
	eatm_CP,
	eatm_object,
	eatm_mapicon
};

static stock 
	AtmsCP[MAX_ATMS][e_AtmsData],
	AtmsLoadedElements;

stock CAtms_Init() 
{
	printf("[CAmts]: Loading ATMS please wait...");
	CAtms_Load();
}

stock CAtms_Exit() 
{
	for(new i; i<AtmsLoadedElements; i++)
	{
		if(IsValidDynamicCP(AtmsCP[i][eatm_CP])) DestroyDynamicCP(AtmsCP[i][eatm_CP]);
		if(IsValidDynamicObject(AtmsCP[i][eatm_object])) DestroyDynamicObject(AtmsCP[i][eatm_object]);
		if(IsValidDynamicMapIcon(AtmsCP[i][eatm_mapicon])) DestroyDynamicMapIcon(AtmsCP[i][eatm_mapicon]);
	}
	printf("[CAmts]: All ATMs was unloaded");
}

stock CAtms_Load() 
{
	CMySQL_Query("SELECT fX, fY, fZ, fRX, fRY, fRZ, interior, vw FROM atms WHERE spawned=1;");
	mysql_store_result();
	
	new i, buf[80], Float:data[6], interior, vw;
	while(mysql_fetch_row(buf, "|"))
	{
		if(sscanf(buf, "p<|>ffffff", data[0], data[1], data[2], data[3], data[4], data[5], interior, vw)) continue;
		if(IsValidDynamicCP(AtmsCP[i][eatm_CP])) DestroyDynamicCP(AtmsCP[i][eatm_CP]);
		if(IsValidDynamicObject(AtmsCP[i][eatm_object])) DestroyDynamicObject(AtmsCP[i][eatm_object]);
		if(IsValidDynamicMapIcon(AtmsCP[i][eatm_mapicon])) DestroyDynamicMapIcon(AtmsCP[i][eatm_mapicon]);
		
		AtmsCP[i][eatm_object]=CreateDynamicObject(ATM_OBJECTID, data[0], data[1], data[2], data[3], data[4], data[5], vw, interior, -1, 250);
		AtmsCP[i][eatm_mapicon]=CreateDynamicMapIcon(data[0], data[1], data[2], ATM_MAPICON, 6, vw, interior, -1, 500);
		AtmsCP[i][eatm_CP]=CreateDynamicCP(data[0], data[1], data[2], 1.5, vw, interior, -1, 25.0);
	}
	mysql_free_result();
	AtmsLoadedElements=i;
	printf("[CAtms]: Loaded %d ATMs", i+1);
}

stock CAtms_EnterPlayerInElement(playerid, elementid) 
{
	for(new i; i<AtmsLoadedElements; i++) 
	{
		if(elementid==AtmsCP[i][eatm_CP])
		{
			theplayer::showATMDialog(playerid);
			return true;
		}
	}
	return false;
}

#undef MAX_ATMS
#undef ATM_OBJECTID
#undef ATM_MAPICON