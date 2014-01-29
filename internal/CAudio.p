/*
	@file: /internal/CAudio.p
	@author: 
		Failed <kamilbacia28@gmail.com>,
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <kamilbacia28@gmail.com>
*/

/*
	
*/

#define audio:: audio_

#define CAUDIO_PCKGNAME "pkg_eggplantdm"

#define MAX_AUDIOZONES (10)

enum e_AudioZones
{
	eaz_audioURL[48],
	eaz_audioZone,
	eaz_audioEffect,
	Float:eaz_audio3D[4]
}

new AudioZonesData[MAX_AUDIOZONES][e_AudioZones],
	LoadedAudioZonesElements;

stock CAudio_Init()
{
	printf("[CAudio]: Creating TCP server...");
	Audio_CreateTCPServer(GetServerVarAsInt("port"));
	Audio_SetPack(CAUDIO_PCKGNAME);
	printf("[CAudio]: Done! Default package with audio files is "CAUDIO_PCKGNAME"!");
	CAudio_LoadZones();
}

stock CAudio_Exit()
{
	printf("[CAudio]: Closing server audio...");
	CAudio_UnloadZones();
	Audio_DestroyTCPServer();
	printf("[CAudio]: Done!");
}

stock CAudio_LoadZones()
{
	new i=0, zoneType, tmpBuf[160], audio3dpos[48], rectanglePos[52], circlePos[48], spherePos[48], Float:fData[4], iData[2];
	CMySQL_Query("SELECT zoneType, audioEffect, audio3DPos, rectanglePos, circlePos, spherePos, streamURL, vw, interior FROM audiozones;", -1);
	mysql_store_result();
	while(mysql_fetch_row(tmpBuf, "|"))
	{
		if(IsValidDynamicArea(AudioZonesData[i][eaz_audioZone])) DestroyDynamicArea(AudioZonesData[i][eaz_audioZone]);
		if(sscanf(tmpBuf, "p<|>dds[48]s[52]s[48]s[48]s[48]dd", zoneType, AudioZonesData[i][eaz_audioEffect], audio3dpos, rectanglePos, circlePos, spherePos, AudioZonesData[i][eaz_audioURL], iData[0], iData[1])) continue;
		if(!strcmp(AudioZonesData[i][eaz_audioURL], "unkown")) continue; // pomijamy, jezeli nie ma linku
		
		if(zoneType==0)
		{
			sscanf(rectanglePos, "p<;>ffff", fData[0], fData[1], fData[2], fData[3]);
			AudioZonesData[i][eaz_audioZone]=CreateDynamicRectangle(fData[0], fData[1], fData[2], fData[3], iData[0], iData[1]);
		} else if(zoneType==1) {
			sscanf(circlePos, "p<;>fff", fData[0], fData[1], fData[2]);
			AudioZonesData[i][eaz_audioZone]=CreateDynamicCircle(fData[0], fData[1], fData[2], iData[0], iData[1]);
		} else {
			sscanf(spherePos, "p<;>ffff", fData[0], fData[1], fData[2], fData[3]);
			AudioZonesData[i][eaz_audioZone]=CreateDynamicSphere(fData[0], fData[1], fData[2], fData[3], iData[0], iData[1]);
		}
		sscanf(audio3dpos, "p<;>ffff", AudioZonesData[i][eaz_audio3D][0], AudioZonesData[i][eaz_audio3D][1], AudioZonesData[i][eaz_audio3D][2], AudioZonesData[i][eaz_audio3D][3]);
		i++;
	}
	mysql_free_result();
	LoadedAudioZonesElements=i;
	printf("[CAudio]: Created %d audio zones", LoadedAudioZonesElements);
}

stock CAudio_IsPlayerInZone(playerid, bool:enter=true, zoneid)
{
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP)) return false;
	if(enter)
	{
		if(PlayerData[playerid][epd_audioAZHandle]) Audio_Stop(playerid, PlayerData[playerid][epd_audioAZHandle]);
		for(new i=0; i<LoadedAudioZonesElements; LoadedAudioZonesElements++)
		{
			if(AudioZonesData[i][eaz_audioZone]==zoneid)
			{
				PlayerData[playerid][epd_audioAZHandle]=Audio_PlayStreamed(playerid, AudioZonesData[i][eaz_audioURL], true, false, true);
				Audio_Set3DPosition(playerid, PlayerData[playerid][epd_audioAZHandle], AudioZonesData[i][eaz_audio3D][0], AudioZonesData[i][eaz_audio3D][1], AudioZonesData[i][eaz_audio3D][2], AudioZonesData[i][eaz_audio3D][3]);
				if(AudioZonesData[i][eaz_audioEffect] != -1) Audio_SetFX(playerid, PlayerData[playerid][epd_audioAZHandle], AudioZonesData[i][eaz_audioEffect]);
				Audio_Resume(playerid, PlayerData[playerid][epd_audioAZHandle]);
				return true;
			}
		}
	} else {
		for(new i=0; i<LoadedAudioZonesElements; LoadedAudioZonesElements++)
		{
			if(AudioZonesData[i][eaz_audioZone]==zoneid)
			{
				if(PlayerData[playerid][epd_audioAZHandle]) Audio_Stop(playerid, PlayerData[playerid][epd_audioAZHandle]);
				PlayerData[playerid][epd_audioAZHandle]=0;
				return true;
			}
		}
	}
	return false;
}

stock CAudio_UnloadZones()
{
	for(new i; i<LoadedAudioZonesElements; i++)
	{
		if(IsValidDynamicArea(AudioZonesData[i][eaz_audioZone])) DestroyDynamicArea(AudioZonesData[i][eaz_audioZone]);
	}
}

public Audio_OnClientConnect(playerid)
{
	PlayerData[playerid][epd_audioBgHandle]=0;
	PlayerData[playerid][epd_audioAZHandle]=0;
	bit_set(PlayerData[playerid][epd_properties], PLAYER_HASCAP);
	theplayer::sendMessage(playerid, COLOR_ERROR, "Nawi¹zano synchronizacje z klientem audio.");
	return true;
}

public Audio_OnClientDisconnect(playerid)
{
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP)) return false; // zabezpieczenie w razie "mozliwego" spamu
	PlayerData[playerid][epd_audioBgHandle]=0;
	PlayerData[playerid][epd_audioAZHandle]=0;
	bit_unset(PlayerData[playerid][epd_properties], PLAYER_HASCAP);
	theplayer::sendMessage(playerid, COLOR_ERROR, "Synchronizacja z klientem audio zosta³a utracona.");
	return true;
}

public Audio_OnTransferFile(playerid, file[], current, total, result)
{
	// dane pobieramy dopiero po zespawnowaniu
	if(current==1) 
	{
		theplayer::sendMessage(playerid, COLOR_INFO1, "Trwa synchronizowanie plików multimedialnych, proszê czekaæ.");
	} else {
	
	}
	if(total==current)
	{
	
		bit_unset(PlayerData[playerid][epd_properties], PLAYER_SYNCACP);
		theplayer::sendMessage(playerid, COLOR_INFO1, "Synchronizacja zosta³a ukoñczona sukcesem.");
	}
	return true;
}

public Audio_OnPlay(playerid, handleid)
{
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP)) return false;
	
	return true;
}

public Audio_OnStop(playerid, handleid)
{
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP)) return false;
	
	return true;
}

public Audio_OnTrackChange(playerid, handleid, track[])
{

	return true;
}

public Audio_OnRadioStationChange(playerid, station)
{
	return true;
}

forward audio::reloadPackage(pid);
public audio::reloadPackage(pid)
{
	if(pid==INVALID_PLAYER_ID)
	{
		theplayer::foreach(i)
		{
			Audio_TransferPack(i);
		}
	} else {
		Audio_TransferPack(pid);
	}
}

stock audio::playSound(playerid, audioid, bool:pause=false, bool:loop=false, bool:downmix=true)
{
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP)) return false;
	if(PlayerData[playerid][epd_audioBgHandle]) Audio_Stop(playerid, PlayerData[playerid][epd_audioBgHandle]);
	PlayerData[playerid][epd_audioBgHandle]=Audio_Play(playerid, audioid, pause, loop, downmix);
	return PlayerData[playerid][epd_audioBgHandle];
}

stock audio::playFromURL(playerid, const url[], bool:pause=false, bool:loop=false, bool:downmix=true)
{
	if(isnull(url)) return false;
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP)) return false;
	if(PlayerData[playerid][epd_audioBgHandle]) Audio_Stop(playerid, PlayerData[playerid][epd_audioBgHandle]);
	PlayerData[playerid][epd_audioBgHandle]=Audio_PlayStreamed(playerid, url, pause, loop, downmix);
	return PlayerData[playerid][epd_audioBgHandle];
}

stock audio::stop(playerid)
{
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_HASCAP)) return false;
	if(PlayerData[playerid][epd_audioBgHandle]) Audio_Stop(playerid, PlayerData[playerid][epd_audioBgHandle]);
}
