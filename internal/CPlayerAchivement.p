/*
	@file: /internal/CPlayerAchivement.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		Zielony745 <SzymonGeek@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

/*

CREATE TABLE IF NOT EXISTS achievements(
	avtID INT NOT NULL AUTO_INCREMENT,
	title VARCHAR(32) NOT NULL, -- tytul osiagniecia
	description VARCHAR(64) NOT NULL, -- opis
	PRIMARY KEY (avtID)
);

INSERT INTO achievements SET title='Odwazny krok - rejestracja konta', description='Zarejestruj konto na serwerze.';

CREATE TABLE IF NOT EXISTS userachievement(
	avtID INT NOT NULL AUTO_INCREMENT,
	userID INT NOT NULL,
	date TIMESTAMP NOT NULL, -- jezeli zaliczyl - zapisujemy czas
	passed TINYINT(1) NOT NULL DEFAULT '0', -- 0=nie zaliczyl, 1=zaliczyl
	PRIMARY KEY (`avtID`),
	FOREIGN KEY (avtID) REFERENCES achievements(avtID)
);

*/

#define MAX_ARCHIVEMENTS (10) // Max osiągniec

#define AVT_REGISTERACCOUNT (1)

enum e_AchievementData 
{
	evd_avtID,
	evd_avtTitle[32],
	evd_avtDesc[64]
};

static stock 
	AchievementData[MAX_ARCHIVEMENTS][e_AchievementData];

stock CAchievement_LoadAll()
{
	new i=0, tmpBuf[128];
	CMySQL_Query("SELECT avtID, title, description FROM achievements;", -1);
	mysql_store_result();
	while(mysql_fetch_row(tmpBuf, "|"))
	{
		if(sscanf(tmpBuf, "p<|>ds[32]s[64]", AchievementData[i][evd_avtID], AchievementData[i][evd_avtTitle], AchievementData[i][evd_avtDesc])) continue;
		i++;
	}
	mysql_free_result();
	printf("[CPlayerAchievement]: Loaded %d achievements!", i);
}

stock theplayer::avtCheck( playerid, avtid )
{
	switch(avtid)
	{
		case AVT_REGISTERACCOUNT: // zarejestrowal konto
		{
			if(!theplayer::avtCheckPasssed(playerid, AVT_REGISTERACCOUNT))
			{
				theplayer::sendMessage(playerid, COLOR_INFO1, "Gratulacje! Ukonczyles wlasnie osiagniecie <b>%d</b>: <b>%s</b>!", AchievementData[AVT_REGISTERACCOUNT-1][evd_avtID], AchievementData[AVT_REGISTERACCOUNT-1][evd_avtTitle]);
				// na razie testowa wiadomosc
				theplayer::avtRecord(playerid, avtid);
				return true;
			}
		}
	}
	return false;
}

stock theplayer::avtCheckPasssed( playerid, avtid )
{
	CMySQL_Query("SELECT passed FROM userachievement WHERE avtID='%d' AND userID='%d' LIMIT 1;", -1, avtid, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	new bool:wykonal=!!mysql_fetch_int();
	mysql_free_result();
	return wykonal;
}

stock theplayer::avtAdd( playerid, avtid )
{
	CMySQL_Query("INSERT INTO userachievement (avtID, userID, date, passed) VALUES ('%d', '%d', NOW(), 1);", -1, avtid, PlayerData[playerid][epd_accountID]);
}

stock theplayer::avtListing( playerid, type_listing=0 )
{
	/*
		listowanie osiagniec:
			0) osiagniecia wykonane
			1) osiagniecia niewykonane
			2) (nad tym trzeba pomyslec) wszystkie(?)
			
		TODO: sortowanie wedlug daty?
	*/
	// Pobieranie wszystkich osiagniec - nawet tych nie zaliczonych
	new i, longBuf[512], tmpBuf[128], avtID, avtTitle[32], avtDate[24];
	
	if(type_listing==0)
	{
	
		CMySQL_Query("SELECT a.avtID, a.title, ap.date FROM userachievement ap JOIN achievements a ON ap.avtID=a.avtID WHERE userid='%d' AND passed='1';", -1, PlayerData[playerid][epd_accountID], type_listing);
		mysql_store_result();
		while(mysql_fetch_row(tmpBuf, "|"))
		{
			if(sscanf(tmpBuf, "p<|>s[32]s[64]", avtID, avtTitle, avtDate)) continue;
			format(longBuf, sizeof(longBuf), "%s\n(%d:%d)\t%s", longBuf, (i+1), avtID, avtTitle);
			i++;
		}
		mysql_free_result();
	} else if(type_listing==1) {
		// trzeba wykominic jakies zapytanko, ktore nie beda w userachievements
	} else {
	
	}
	/*
	if(!i)
	{
		ShowPlayerDialog(playerid, DIALOG_AVT_LIST, DIALOG_STYLE_MSGBOX, "Osiagniecia", "Nie udalo się pobrać listy osiągnieć, sprobuj ponownie.", "Zamknij");
	} else {
		ShowPlayerDialog(playerid, DIALOG_AVT_LIST, DIALOG_STYLE_LIST, "Osiagniecia", longBuf, "Wybierz", "Zamknij");
	}
	*/
	return true;
}