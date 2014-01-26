/*
	@file: /internal/commands/cmds_header.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#include "internal/commands/cmds_admin"
#include "internal/commands/cmds_gm"
#include "internal/commands/cmds_premium"
#include "internal/commands/cmds_players"

public OnPlayerCommandPerformed(playerid, cmdtext[], success) 
{
	CheckPlayerBounds(playerid);
	new nowTime=gettime();
	if(!theplayer::isAdmin(playerid, RANK_ADMIN) && PlayerData[playerid][epd_cmdSpamTime]<nowTime)
	{
		switch(PlayerData[playerid][epd_cmdSpamCount]++)
		{
			case 3:
			{
				theplayer::sendMessage(playerid, COLOR_ERROR, "Wykryto spam komendami.");
				PlayerData[playerid][epd_cmdSpamTime]=nowTime;
				return true;
			}
			case 5:
			{
				theplayer::sendMessage(playerid, COLOR_ERROR, "Wykryto spam komendami. Za chwilê zostaniesz wyrzucony!");
				PlayerData[playerid][epd_cmdSpamTime]=nowTime;
				return true;
			}
			case 10:
			{
				theplayer::sendMessage(playerid, COLOR_ERROR, "Zosta³eœ wyrzucony, za zbyt du¿y spam komendami.");
				theplayer::kick(playerid);
				CLogging_Insert(CLOG_SERVER, "%s (%d) - zostal wyrzucony za spam komendami", PlayerData[playerid][epd_nickname], playerid);
				return true;
			}
		}
	} else {
		PlayerData[playerid][epd_cmdSpamCount]=0;
		PlayerData[playerid][epd_cmdSpamTime]=nowTime;
	}
	
	if(success)
	{
		CLogging_Insert(CLOG_CMDS, "%s (%d) > %s", PlayerData[playerid][epd_nickname], playerid, cmdtext); 
		return true;
	} else {
		theplayer::sendMessage(playerid, COLOR_ERROR, "B³¹d! Nie znaleziono takiej komendy!");
		return true;
	}
}

public OnPlayerCommandReceived(playerid, cmdtext[]) 
{
	CheckPlayerBounds(playerid);
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG)) 
	{
		theplayer::sendMessage(playerid, COLOR_ERROR, "Aby skorzystaæ z tej funkcji musisz siê pierw zalogowaæ.");
		return false;
	}
	return true;
}