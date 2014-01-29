/*
	@file: /internal/CAudio.p
	@author: 
		Failed <kamilbacia28@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <kamilbacia28@gmail.com>
*/

stock audio::PlayPlayer(playerid, audioid, bool:pause = false, bool:loop = false, bool:downmix = false)
{
	new handle[playerid] = Audio_Play(playerid, audioid);
}

stock audio::GetHandlePlayerPlaySound(playerid)
{
	return handle[playerid];
}

stock audio::PlayStreamed(playerid, const url[], bool:pause = false, bool:loop = false, bool:downmix = false)
{
	new handleStreamed[playerid] = Audio_PlayStreamed(playerid,  url[]);
}

stock audio::GetHandlePlayerPlayStreamed(playerid)
{
	return handleStreamed[playerid];
}

stock audio::PlaySequence(playerid, sequenceid, bool:pause = false, bool:loop = false, bool:downmix = false)
{
	new handleSequence[playerid] = Audio_PlaySequence(playerid, sequenceid);
}

stock audio::GetHandlePlayerPlaySequence(playerid)
{
	return handleSequence[playerid];
}



