/*
	@file: /internal/Attractions/header.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

/*
	CREATE TABLE IF NOT EXISTS attractions(
		id TINYINT NOT NULL AUTO_INCREMENT,
		name VARCHAR(32) NOT NULL DEFAULT 'brak',
		minPlayers TINYINT NOT NULL DEFAULT '2',
		maxPlayers TINYINT NOT NULL DEFAULT '8',
		startingTime TINYINT NOT NULL DEFAULT '25', -- czas w sekundach do wystartowania
		type TINYINT NOT NULL DEFAULT '0', -- brak
		PRIMARY KEY (`id`)
	);

	INSERT INTO attractions (name, minPlayers, maxPlayers, type) VALUES ('Wojna gangow', 2, 16, 1);
*/

enum 
{
	ATTRACTION_NONE=0,
	ATTRACTION_WG,
	ATTRACTION_CHOWANY,
	ATTRACTION_COS,
	MAX_ATTRACTIONS
};

enum e_StateAttractions: (<<=1) 
{
	ATTRACTION_STATE_NONE=0,
	ATTRACTION_STATE_STARTING,
	ATTRACTION_STATE_STARTED,
	ATTRACTION_STATE_OFF,
	ATTRACTION_STATE_OFF, // specjalny 'status' - jezeli go zalaczymy gracz nie moze zapisac sie na ta atrakcje
};

enum e_GameAttractions
{
	eat_gameName[32],
	e_StateAttractions:eat_gameState, 
	eat_gameMaxPlayers,
	eat_gameMinPlayers,
	eat_gameSavedPlayers, // zapisanych graczy
	eat_startTime, // czas w sekundach do wystartowania
	eat_startTick, // czas w ms od wystartowania
};

new AttractionData[MAX_ATTRACTIONS][e_GameAttractions];

stock CAttractions_Init()
{
	new i, row, tmpBuf[128], tmpName[32], addData[4];
	CMySQL_Query("SELECT name, minPlayers, maxPlayers, startingTime, type FROM attractions;", -1);
	mysql_store_result();
	while(mysql_fetch_row(tmpBuf, "|"))
	{
		if(sscanf(tmpBuf, "p<|>s[32]dddd", tmpName, addData[0], addData[1], addData[2], addData[3])) continue;
		
		switch(addData[3])
		{
			case ATTRACTION_WG: {
				row=ATTRACTION_WG;
				string::copy(AttractionData[row][eat_gameName], tmpName);
				AttractionData[row][eat_gameMinPlayers]=addData[0];
				AttractionData[row][eat_gameMaxPlayers]=addData[1];
				AttractionData[row][eat_startTime]=addData[2];
				AttractionData[row][eat_gameSavedPlayers]=0;
				bit_set(AttractionData[row][eat_gameState], ATTRACTION_STATE_OFF);
			}
			case ATTRACTION_CHOWANY: {
				row=ATTRACTION_CHOWANY;
				string::copy(AttractionData[row][eat_gameName], tmpName);
				AttractionData[row][eat_gameMinPlayers]=addData[0];
				AttractionData[row][eat_gameMaxPlayers]=addData[1];
				AttractionData[row][eat_startTime]=addData[2];
				AttractionData[row][eat_gameSavedPlayers]=0;
				bit_set(AttractionData[row][eat_gameState], ATTRACTION_STATE_OFF);
			}
			case ATTRACTION_COS: {
				row=ATTRACTION_COS;
				string::copy(AttractionData[row][eat_gameName], tmpName);
				AttractionData[row][eat_gameMinPlayers]=addData[0];
				AttractionData[row][eat_gameMaxPlayers]=addData[1];
				AttractionData[row][eat_startTime]=addData[2];
				AttractionData[row][eat_gameSavedPlayers]=0;
				bit_set(AttractionData[row][eat_gameState], ATTRACTION_STATE_OFF);
			}
		}
		i++;
	}
	mysql_free_result();
	printf("[CAttractions]: Loaded %d attractions!", i);
}

stock CAttraction_Exit()
{
	for(new i; i<MAX_ATTRACTIONS; i++)
	{
		bit_set(AttractionData[i][eat_gameState], ATTRACTION_STATE_OFF);
	}
}