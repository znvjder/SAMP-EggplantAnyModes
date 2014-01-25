/*
	@file: /internal/CMapicons.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define MAX_MAPICONS (50)

static stock
	MapiconsHandler[MAX_MAPICONS],
	MapiconsLoadedElements;
	
stock CMapicons_Init() 
{
	CMySQL_Query("SELECT fX, fY, fZ, iconType, iconColor, iconView, interior, vw FROM mapicons;");
	mysql_store_result();
	
	new i, buf[80], Float:fdata[4], data[4];
	while(mysql_fetch_row(buf, "|"))
	{
		if(sscanf(buf, "p<|>fffddfdd", fdata[0], fdata[1], fdata[2], data[0], data[1], fdata[3], data[2], data[3])) continue;
		if(IsValidDynamicMapIcon(MapiconsHandler[i])) DestroyDynamicMapIcon(MapiconsHandler[i]);
		MapiconsHandler[i]=CreateDynamicMapIcon(fdata[0], fdata[1], fdata[2], data[0], data[1], data[2], data[3], -1, fdata[3]);
	}
	mysql_free_result();
	printf("[CMapicons]: Loaded %d mapicons", i+1);
}

stock CMapicons_Exit()
{
	for(new i; i<MapiconsLoadedElements; i++)
	{
		if(IsValidDynamicMapIcon(MapiconsHandler[i])) DestroyDynamicMapIcon(MapiconsHandler[i]);
	}
}
