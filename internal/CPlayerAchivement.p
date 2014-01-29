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
	description VARCHAR(64) NOT NULL, -- opis
	PRIMARY KEY (avtID)
);

CREATE TABLE IF NOT EXISTS userachievement(
	avtID INT NOT NULL AUTO_INCREMENT,
	userID INT NOT NULL,
	date TIMESTAMP,
	remark VARCHAR(64), -- uwagi
	PRIMARY KEY (`avtID`),
	FOREIGN KEY (avtID) REFERENCES achievements(avtID)
);
TODO: Dodać dodawanie osiągnięcia do konta.
*/

#define MAX_ARCHIVEMENTS 10 //Max osiągnięc
enum archivements_Info {
	id,
	description[100]
}

enum playerArchivements_Info {
	avtid[4],
	date[4],
	remark[4]
}
new Archivment_Info[MAX_ARCHIVEMENTS][archivements_Info];
new PlayerArchivment[MAX_PLAYERS][playerArchivements_Info];

stock theplayer::getArchivment(playerid, arch_id)
{
	switch(arch_id)
	{
	case 0:
	{
		//Osiągnięcie nowe konto//
		if (PlayerData[playerid][epd_walletMoney] > 1000 && theplayer::getArchivementsByPlayer( playerid, 0 ) != true)//Sprawdzanie według ilości pieniędzy i czy osiągnięcie już jest.
		{
			SendClientMessage("[Ukonczono]Gratulacje! Ukończyłeś osiągnięcie jakieś tam...");
			theplayer::addNewArchivementsByPlayer( playerid, archid, "Data", "Uwagi");
			//I coś tam jescze :)
		}
	}
	}
}

stock theplayer::getArchivements( userid, new_avtid )
{
	for (new i = 0; i < MAX_ARCHIVEMENTS; i++)
	{
		//Sprawdzanie czy osiągnięcie istnieje
		if (PlayerArchivment[playerid][avtid][i] == new_avtid) return true;
	}
	return false;
}

stock theplayer::addNewArchivements( userid, avtid, date[], remark[] )
{
	//TO DO: Zrobić dodanie nowego osiągnięcia dla konta.
}

stock theplayer::loadArchivements( userid )
{
	//Dzięki tej funkcji można pobrać wszystkie osiągnięcia danego gracza.
	//Wczytywanie danych.
	new arch_query[30], count;
	CMySQL_Query("SELECT avtID date, remark FROM userachievement WHERE userID = '%d'", -1, PlayerData[userid][epd_accountID]);
	mysql_store_result();
	count = 0;
	while(mysql_fetch_rows(arch_query, "|"))
	{
		sscanf(arch_query, "p<|>ds[30]s[64]",
			PlayerArchivment[userid][avtid][count],
			PlayerArchivment[userid][date][count],
			PlayerArchivment[userid][remark][count]);
		if (!PlayerArchivment[userid][avtid][count])
			break;
		count++;
	}
	mysql_free_result();
	if (!PlayerArchivment[userid][avtid][count]) return false;
	return true;
}