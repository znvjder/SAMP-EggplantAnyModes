/*
	@file: /internal/CTextdraws.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define CTextDrawPerPlayer_Destroy(%0,%1) PlayerTextDrawDestroyEx(%0,%1)

enum 
{
	// global textdraws
	GLOBAL_TD_BOXMAIN=0,
	GLOBAL_TD_BOXPASEK,
	
	// time
	GLOBAL_TD_BOXTIME,
	GLOBAL_TD_TIME,
	GLOBAL_TD_TIMELABEL,
	
	GLOBAL_TD_LOGO,
	GLOBAL_TD_ENDINGURL, // .net
	
	GLOBAL_TD_SCRIPTVERSION,
	
	MAX_GLOBAL_TEXTDRAWS
};

enum 
{
	// per player textdraws
	PLAYER_TD_BOXPING=0,
	PLAYER_TD_BOXFPS,
	PLAYER_TD_PING,
	PLAYER_TD_FPS,
	PLAYER_TD_PINGLABEL,
	PLAYER_TD_FPSLABEL,
	
	PLAYER_TD_HIDDINGSCREEN,
	PLAYER_TD_NOTIFICATION, 
	
	MAX_PLAYER_TEXTDRAWS
};

new Text:globalTextDraws[MAX_GLOBAL_TEXTDRAWS],
	PlayerText:playerTextDraws[MAX_PLAYERS][MAX_PLAYER_TEXTDRAWS];
	
stock CTextdraws_Init() 
{
	globalTextDraws[GLOBAL_TD_BOXMAIN] = TextDrawCreate(0.000000, 432.000000, "box_glowny");
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_BOXMAIN], 255);
	TextDrawFont(globalTextDraws[GLOBAL_TD_BOXMAIN], 1);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_BOXMAIN], 0.000000, 1.500000);
	TextDrawColor(globalTextDraws[GLOBAL_TD_BOXMAIN], -1);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_BOXMAIN], 0);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_BOXMAIN], 1);
	TextDrawSetShadow(globalTextDraws[GLOBAL_TD_BOXMAIN], 1);
	TextDrawUseBox(globalTextDraws[GLOBAL_TD_BOXMAIN], 1);
	TextDrawBoxColor(globalTextDraws[GLOBAL_TD_BOXMAIN], 112);
	TextDrawTextSize(globalTextDraws[GLOBAL_TD_BOXMAIN], 640.000000, 0.000000);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_BOXMAIN], 0);
	
	globalTextDraws[GLOBAL_TD_BOXPASEK] = TextDrawCreate(0.000000, 431.000000, "box_glowny_pasek");
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_BOXPASEK], 255);
	TextDrawFont(globalTextDraws[GLOBAL_TD_BOXPASEK], 1);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_BOXPASEK], 0.000000, -0.200000);
	TextDrawColor(globalTextDraws[GLOBAL_TD_BOXPASEK], -1);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_BOXPASEK], 0);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_BOXPASEK], 1);
	TextDrawSetShadow(globalTextDraws[GLOBAL_TD_BOXPASEK], 1);
	TextDrawUseBox(globalTextDraws[GLOBAL_TD_BOXPASEK], 1);
	TextDrawBoxColor(globalTextDraws[GLOBAL_TD_BOXPASEK], -291437825);
	TextDrawTextSize(globalTextDraws[GLOBAL_TD_BOXPASEK], 640.000000, 0.000000);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_BOXPASEK], 0);
	
	globalTextDraws[GLOBAL_TD_LOGO] = TextDrawCreate(530.000000, 433.000000, "~y~Your~w~Server");
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_LOGO], 32);
	TextDrawFont(globalTextDraws[GLOBAL_TD_LOGO], 1);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_LOGO], 0.280000, 1.200000);
	TextDrawColor(globalTextDraws[GLOBAL_TD_LOGO], -1);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_LOGO], 1);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_LOGO], 1);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_LOGO], 0);

	globalTextDraws[GLOBAL_TD_ENDINGURL] = TextDrawCreate(599.000000, 438.000000, "~w~.Domain");
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_ENDINGURL], 32);
	TextDrawFont(globalTextDraws[GLOBAL_TD_ENDINGURL], 1);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_ENDINGURL], 0.170000, 0.699998);
	TextDrawColor(globalTextDraws[GLOBAL_TD_ENDINGURL], -1);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_ENDINGURL], 1);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_ENDINGURL], 1);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_ENDINGURL], 0);
	
	globalTextDraws[GLOBAL_TD_SCRIPTVERSION] = TextDrawCreate(86.000000, 411.000000, "0.1.1");
	TextDrawAlignment(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], 2);
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], 32);
	TextDrawFont(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], 2);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], 0.200000, 0.799998);
	TextDrawColor(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], -1);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], 1);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], 1);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_SCRIPTVERSION], 0);
	
	globalTextDraws[GLOBAL_TD_BOXTIME] = TextDrawCreate(2.000000, 374.000000, "LD_POKE:cdback");
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_BOXTIME], 255);
	TextDrawFont(globalTextDraws[GLOBAL_TD_BOXTIME], 4);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_BOXTIME], 0.090000, -0.100000);
	TextDrawColor(globalTextDraws[GLOBAL_TD_BOXTIME], 96);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_BOXTIME], 0);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_BOXTIME], 1);
	TextDrawSetShadow(globalTextDraws[GLOBAL_TD_BOXTIME], 1);
	TextDrawUseBox(globalTextDraws[GLOBAL_TD_BOXTIME], 1);
	TextDrawBoxColor(globalTextDraws[GLOBAL_TD_BOXTIME], 0);
	TextDrawTextSize(globalTextDraws[GLOBAL_TD_BOXTIME], 32.000000, 16.000000);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_BOXTIME], 0);
	
	globalTextDraws[GLOBAL_TD_TIMELABEL] = TextDrawCreate(14.000000, 372.000000, "czas");
	TextDrawAlignment(globalTextDraws[GLOBAL_TD_TIMELABEL], 2);
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_TIMELABEL], 32);
	TextDrawFont(globalTextDraws[GLOBAL_TD_TIMELABEL], 2);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_TIMELABEL], 0.140000, 0.599999);
	TextDrawColor(globalTextDraws[GLOBAL_TD_TIMELABEL], -1);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_TIMELABEL], 1);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_TIMELABEL], 1);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_TIMELABEL], 0);
	
	globalTextDraws[GLOBAL_TD_TIME] = TextDrawCreate(18.000000, 377.000000, "~w~20:41");
	TextDrawAlignment(globalTextDraws[GLOBAL_TD_TIME], 2);
	TextDrawBackgroundColor(globalTextDraws[GLOBAL_TD_TIME], 32);
	TextDrawFont(globalTextDraws[GLOBAL_TD_TIME], 3);
	TextDrawLetterSize(globalTextDraws[GLOBAL_TD_TIME], 0.240000, 1.000000);
	TextDrawColor(globalTextDraws[GLOBAL_TD_TIME], -1);
	TextDrawSetOutline(globalTextDraws[GLOBAL_TD_TIME], 1);
	TextDrawSetProportional(globalTextDraws[GLOBAL_TD_TIME], 1);
	TextDrawSetSelectable(globalTextDraws[GLOBAL_TD_TIME], 0);
	
}

stock CTextdraws_Exit() 
{
	for(new i; i<MAX_GLOBAL_TEXTDRAWS-1; i++) 
	{
		TextDrawHideForAll(globalTextDraws[i]);
		TextDrawDestroy(globalTextDraws[i]);
		globalTextDraws[i]=INVALID_TEXT_DRAW;
	}
}

stock CTextdrawPerPlayer_Init(playerid) 
{
	playerTextDraws[playerid][PLAYER_TD_BOXPING] = CreatePlayerTextDraw(playerid,2.000000, 410.000000, "LD_POKE:cdback");
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 255);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 4);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 0.090000, -0.100000);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 96);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 0);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 1);
	PlayerTextDrawSetShadow(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 1);
	PlayerTextDrawUseBox(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 1);
	PlayerTextDrawBoxColor(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 0);
	PlayerTextDrawTextSize(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 32.000000, 16.000000);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_BOXPING], 0);

	playerTextDraws[playerid][PLAYER_TD_BOXFPS] = CreatePlayerTextDraw(playerid,2.000000, 392.000000, "LD_POKE:cdback");
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 255);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 4);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 0.090000, -0.100000);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 96);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 0);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 1);
	PlayerTextDrawSetShadow(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 1);
	PlayerTextDrawUseBox(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 1);
	PlayerTextDrawBoxColor(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 0);
	PlayerTextDrawTextSize(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 32.000000, 16.000000);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_BOXFPS], 0);

	playerTextDraws[playerid][PLAYER_TD_FPS] = CreatePlayerTextDraw(playerid,18.000000, 395.000000, "~w~41");
	PlayerTextDrawAlignment(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], 2);
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], 32);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], 3);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], 0.240000, 1.000000);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], -1);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], 1);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], 1);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_FPS], 0);

	playerTextDraws[playerid][PLAYER_TD_PING] = CreatePlayerTextDraw(playerid,18.000000, 413.000000, "~w~124ms");
	PlayerTextDrawAlignment(playerid,playerTextDraws[playerid][PLAYER_TD_PING], 2);
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_PING], 32);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_PING], 3);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_PING], 0.240000, 1.000000);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_PING], -1);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_PING], 1);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_PING], 1);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_PING], 0);

	playerTextDraws[playerid][PLAYER_TD_PINGLABEL] = CreatePlayerTextDraw(playerid,12.000000, 408.000000, "Ping");
	PlayerTextDrawAlignment(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], 2);
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], 32);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], 2);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], 0.140000, 0.599999);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], -1);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], 1);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], 1);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_PINGLABEL], 0);

	playerTextDraws[playerid][PLAYER_TD_FPSLABEL] = CreatePlayerTextDraw(playerid,12.000000, 390.000000, "FPS");
	PlayerTextDrawAlignment(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], 2);
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], 32);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], 2);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], 0.140000, 0.599999);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], -1);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], 1);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], 1);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_FPSLABEL], 0);
	
	playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN] = CreatePlayerTextDraw(playerid,0.000000, 0.000000, "zaslona_ekranu");
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 255);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 1);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 0.000000, 47.499992);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], -1);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 0);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 1);
	PlayerTextDrawSetShadow(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 1);
	PlayerTextDrawUseBox(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 1);
	PlayerTextDrawBoxColor(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], -208);
	PlayerTextDrawTextSize(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 640.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_HIDDINGSCREEN], 0);
	
	playerTextDraws[playerid][PLAYER_TD_NOTIFICATION] = CreatePlayerTextDraw(playerid,6.000000, 435.000000, "~>~ l0nger chce byc Twoim znajomym, jezeli zgadasz sie na to wpisz /znajomi i wybierz ostatnie zaproszenia");
	PlayerTextDrawBackgroundColor(playerid,playerTextDraws[playerid][PLAYER_TD_NOTIFICATION], 16);
	PlayerTextDrawFont(playerid,playerTextDraws[playerid][PLAYER_TD_NOTIFICATION], 1);
	PlayerTextDrawLetterSize(playerid,playerTextDraws[playerid][PLAYER_TD_NOTIFICATION], 0.170000, 0.799999);
	PlayerTextDrawColor(playerid,playerTextDraws[playerid][PLAYER_TD_NOTIFICATION], -808464385);
	PlayerTextDrawSetOutline(playerid,playerTextDraws[playerid][PLAYER_TD_NOTIFICATION], 1);
	PlayerTextDrawSetProportional(playerid,playerTextDraws[playerid][PLAYER_TD_NOTIFICATION], 1);
	PlayerTextDrawSetSelectable(playerid,playerTextDraws[playerid][PLAYER_TD_NOTIFICATION], 0);
}

stock CTextdrawPerPlayer_Exit(playerid) 
{

}

stock CTextDrawPerPlayer_Destroy(playerid, PlayerText:ptd) 
{
	PlayerTextDrawDestroy(playerid, ptd);
	ptd=INVALID_TEXT_DRAW;
}
