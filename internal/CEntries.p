/*
	@file: /internal/CEntries.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

/*
	Zapytanie do insertowania:
	INSERT INTO entries 
	(eType, enter, enterX, enterY, enterZ, enterAng, exitX, exitY, exitZ, exitAng, enterI, enterVW, exitI, exitVW, label, labelView) 
	VALUES 
	(0, 1, '4.0', '4.0', '2.0', '90.0', '12.0', '12.0', '3.0', '180.0', 0, 0, 0, 0, 'Wejscie testowe', 50.0);
	
*/

#define MAX_ENTRIES (100)

#define ENTRIES_TYPE_PICKUP (0)
#define ENTRIES_TYPE_CP (1)

#define ENTRIES_LABEL_COLOR (0x7E8894FF)

#define ENTRIES_ENTER_DELAY (3000)

#define ENTRIES_EXIT_PICKUPID (19135)

enum e_EntriesData 
{
	eed_type,
	bool:eed_enter,
	eed_enterElement,
	eed_exitElement,
	eed_enterType,
	Float:eed_enterPos[4],
	Float:eed_exitPos[4],
	Text3D:edd_label,
	eed_interior[2], // 0-wejscie, 1-wyjscie
	eed_vw[2] // 0-wejscie, 1-wyjscie
};

new EntriesData[MAX_ENTRIES][e_EntriesData],
	EntriesLoadedElements;
	
stock CEntries_Init() 
{
	printf("[CEntries]: Loading entries please wait!");
	CEntries_Load();
}

stock CEntries_Exit() 
{
	for(new i; i<EntriesLoadedElements; i++) 
	{
		if(IsValidDynamicPickup(EntriesData[i][eed_enterElement])) DestroyDynamicPickup(EntriesData[i][eed_enterElement]);
		if(IsValidDynamicCP(EntriesData[i][eed_enterElement])) DestroyDynamicCP(EntriesData[i][eed_enterElement]);
		if(IsValidDynamicPickup(EntriesData[i][eed_exitElement])) DestroyDynamicPickup(EntriesData[i][eed_exitElement]);
		if(IsValidDynamic3DTextLabel(EntriesData[i][edd_label])) DestroyDynamic3DTextLabel(EntriesData[i][edd_label]);
	}
	printf("[CEntries]: Unloading all entries!");
}

stock CEntries_Load() 
{
	CMySQL_Query("SELECT eType, enter, pickupid, cpSize, enterX, enterY, enterZ, enterAng, exitX, exitY, exitZ, exitAng, enterI, enterVW, exitI, exitVW, label, labelView FROM entries WHERE eClosed=0;");
	mysql_store_result();
	
	new i, buf[128], labelText[48], Float:labelView, Float:cpSize, pickupid;
	while(mysql_fetch_row(buf, "|")) 
	{
		if(sscanf(buf, "p<|>dddfffffffffdddds[48]f", 
			EntriesData[i][eed_type], EntriesData[i][eed_enter], pickupid, cpSize, 
			EntriesData[i][eed_enterPos][0], EntriesData[i][eed_enterPos][1], EntriesData[i][eed_enterPos][2], EntriesData[i][eed_enterPos][3],
			EntriesData[i][eed_exitPos][0], EntriesData[i][eed_exitPos][1], EntriesData[i][eed_exitPos][2], EntriesData[i][eed_exitPos][3],
			EntriesData[i][eed_interior][0], EntriesData[i][eed_vw][0], EntriesData[i][eed_interior][0], EntriesData[i][eed_vw][1], labelText, labelView)) continue;
		
		if(IsValidDynamicPickup(EntriesData[i][eed_enterElement])) DestroyDynamicPickup(EntriesData[i][eed_enterElement]);
		if(IsValidDynamicCP(EntriesData[i][eed_enterElement])) DestroyDynamicCP(EntriesData[i][eed_enterElement]);
		if(IsValidDynamicPickup(EntriesData[i][eed_exitElement])) DestroyDynamicPickup(EntriesData[i][eed_exitElement]);
		if(IsValidDynamic3DTextLabel(EntriesData[i][edd_label])) DestroyDynamic3DTextLabel(EntriesData[i][edd_label]);
		
		if(EntriesData[i][eed_type]==ENTRIES_TYPE_PICKUP) 
		{
			EntriesData[i][eed_enterElement]=CreateDynamicPickup(pickupid, 1, EntriesData[i][eed_enterPos][0], EntriesData[i][eed_enterPos][1], EntriesData[i][eed_enterPos][2], EntriesData[i][eed_vw][0], EntriesData[i][eed_interior][0], -1, .streamdistance=75.0);
		} else {
			EntriesData[i][eed_enterElement]=CreateDynamicCP(EntriesData[i][eed_enterPos][0], EntriesData[i][eed_enterPos][1], EntriesData[i][eed_enterPos][2], cpSize, EntriesData[i][eed_vw][0], EntriesData[i][eed_interior][0], -1, .streamdistance=75.0);
		}
		
		EntriesData[i][eed_exitElement]=CreateDynamicPickup(ENTRIES_EXIT_PICKUPID, 1, EntriesData[i][eed_exitPos][0], EntriesData[i][eed_exitPos][1], EntriesData[i][eed_exitPos][2], EntriesData[i][eed_vw][1], EntriesData[i][eed_interior][1], -1, .streamdistance=30.0);
		if(!isnull(labelText)) 
		{
			EntriesData[i][edd_label]=CreateDynamic3DTextLabel(labelText, ENTRIES_LABEL_COLOR, EntriesData[i][eed_enterPos][0], EntriesData[i][eed_enterPos][1], EntriesData[i][eed_enterPos][2]+0.75, labelView, _, _, 1, EntriesData[i][eed_vw], EntriesData[i][eed_interior], -1, labelView);
		}
		i++;
	}
	mysql_free_result();
	EntriesLoadedElements=i;
	printf("[CEntries]: Loaded %d entries in map", EntriesLoadedElements);
}

stock CEntries_EnterPlayerInElement(playerid, checkpoint=-1, pickupid=-1) 
{
	new delayElement=false;
	if((GetTickCount()-PlayerData[playerid][epd_entriesPickupDelay]) < ENTRIES_ENTER_DELAY) delayElement=true;
	
	if(!delayElement) 
	{
		for(new i=0; i<EntriesLoadedElements; i++) 
		{
			switch(EntriesData[i][eed_type]) 
			{
				case ENTRIES_TYPE_PICKUP:
				{
					if(pickupid==EntriesData[i][eed_enterElement]) 
					{
						if(EntriesData[i][eed_enter]==false && !theplayer::isAdmin(playerid))
						{
							theplayer::sendMessage(playerid, COLOR_INFO1, "Zamkniete!");
							return true;
						}
						
						new Float:fVelocity[3];
						GetPlayerVelocity(playerid, fVelocity[0], fVelocity[1], fVelocity[2]);
						PlayerData[playerid][epd_entriesVelocity][0]=(fVelocity[0]*3);
						PlayerData[playerid][epd_entriesVelocity][1]=(fVelocity[1]*3);
						PlayerData[playerid][epd_entriesVelocity][2]=(fVelocity[2]*1.5);
						theplayer::teleport(playerid, true, utility::unpackXYZ(EntriesData[i][eed_exitPos]), EntriesData[i][eed_exitPos][3], EntriesData[i][eed_interior][1], EntriesData[i][eed_vw][1]);
						PlayerData[playerid][epd_entriesPickupDelay]=GetTickCount();
						return true;
					} 
					else if(pickupid==EntriesData[i][eed_exitElement]) 
					{
						theplayer::teleport(playerid, true, EntriesData[i][eed_enterPos][0]-PlayerData[playerid][epd_entriesVelocity][0], EntriesData[i][eed_enterPos][1]-PlayerData[playerid][epd_entriesVelocity][1], EntriesData[i][eed_enterPos][2]-PlayerData[playerid][epd_entriesVelocity][2], EntriesData[i][eed_exitPos][3]-180.0, EntriesData[i][eed_interior][0], EntriesData[i][eed_vw][0]);
						PlayerData[playerid][epd_entriesPickupDelay]=GetTickCount();
						return true;
					}
				}
				case ENTRIES_TYPE_CP: 
				{
					if(checkpoint==EntriesData[i][eed_enterElement]) 
					{
						if(EntriesData[i][eed_enter]==false && !theplayer::isAdmin(playerid))
						{
							theplayer::sendMessage(playerid, COLOR_INFO1, "Zamkniete!");
							return true;
						}
						
						new Float:fVelocity[3];
						GetPlayerVelocity(playerid, fVelocity[0], fVelocity[1], fVelocity[2]);
						PlayerData[playerid][epd_entriesVelocity][0]=(fVelocity[0]*3);
						PlayerData[playerid][epd_entriesVelocity][1]=(fVelocity[1]*3);
						PlayerData[playerid][epd_entriesVelocity][2]=(fVelocity[2]*1.5);
						theplayer::teleport(playerid, true, utility::unpackXYZ(EntriesData[i][eed_exitPos]), EntriesData[i][eed_exitPos][3], EntriesData[i][eed_interior][1], EntriesData[i][eed_vw][1]);
						PlayerData[playerid][epd_entriesPickupDelay]=GetTickCount();
						return true;
					} 
					else if(pickupid==EntriesData[i][eed_exitElement]) 
					{
						theplayer::teleport(playerid, true, EntriesData[i][eed_enterPos][0]-PlayerData[playerid][epd_entriesVelocity][0], EntriesData[i][eed_enterPos][1]-PlayerData[playerid][epd_entriesVelocity][1], EntriesData[i][eed_enterPos][2]-PlayerData[playerid][epd_entriesVelocity][2], EntriesData[i][eed_exitPos][3]-180.0, EntriesData[i][eed_interior][0], EntriesData[i][eed_vw][0]);
						PlayerData[playerid][epd_entriesPickupDelay]=GetTickCount();
						return true;
					}
				}
			}
		}
	}
	return false;
}