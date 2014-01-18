/*
	@file: /internal/CFriends.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>,
		Andrew <andx98@wp.pl>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

/*
	TODO:
	
	1) Dodac czasowe zabezpieczenia do zapytan SQL, czyli lista znajomych, powiadomienia i dodawanie znajomego - na ok. 1 minute od ostatniego uzycia (zoptymalizujemy troche serwer mysql)
*/

stock CFriends_ShowHomePage(playerid) {
	new tmpBuf[128], iloscPowiadomien;
	CMySQL_Query("SELECT COUNT(*) FROM friends WHERE invited='%d' AND accepted=0 AND TIMESTAMPDIFF(DAY, ts_created, NOW())<=30", -1, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	iloscPowiadomien=mysql_fetch_int();
	mysql_free_result();
	
	if(!iloscPowiadomien) {
		ShowPlayerDialog(playerid, DIALOG_FRIENDS_INDEX, DIALOG_STYLE_LIST, "Znajomi", "Lista znajomych\nZaproszenia (brak nowych powiadomien)\nZaproœ do znajomych...", "Wybierz", "Anuluj");
	} else {
		format(tmpBuf, sizeof(tmpBuf), "Lista znajomych\nZaproszenia (%d)\nZaproœ do znajomych...", iloscPowiadomien);
		ShowPlayerDialog(playerid, DIALOG_FRIENDS_INDEX, DIALOG_STYLE_LIST, "Znajomi", tmpBuf, "Wybierz", "Anuluj");
	}
}

stock CFriends_CheckOrAreFriendByUID(player_uid, friend_uid) {
	if(friend_uid<0) return false;
	CMySQL_Query("SELECT 1 FROM friends WHERE inviter='%d' AND invited='%d' OR inviter='%d' AND invited='%d' LIMIT 1;", -1, friend_uid, player_uid, player_uid, friend_uid);
	mysql_store_result();
	new bool:areWeFriends=false;
	if(mysql_num_rows()) areWeFriends=true;
	mysql_free_result();
	return areWeFriends;
}

stock CFriends_CheckOrAreFriend(playerid, friendid) {
	if(!IsPlayerConnected(friendid)) return false;
	CMySQL_Query("SELECT 1 FROM friends WHERE inviter='%d' AND invited='%d' OR inviter='%d' AND invited='%d' LIMIT 1;", -1, PlayerData[friendid][accountID], PlayerData[playerid][accountID], PlayerData[playerid][accountID], PlayerData[friendid][accountID]);
	mysql_store_result();
	new bool:areWeFriends=false;
	if(mysql_num_rows()) areWeFriends=true;
	mysql_free_result();
	return areWeFriends;
}

stock CFriends_SeeMyFriends(playerid) {
	CMySQL_Query("SELECT a.nickname FROM friends f JOIN accounts a ON inviter=a.id WHERE invited='%d' AND accepted=1", -1, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	if(!mysql_num_rows()) {
		ShowPlayerDialog(playerid, DIALOG_FRIENDS_LIST, DIALOG_STYLE_LIST, "Znajomi > Lista znajomych", "Nie masz jeszcze znajomych...", "Wróæ", "");
		mysql_free_result();
		return;
	}
	new tmpBuf[512], szNick[24], i=0;
	while(mysql_fetch_row(szNick)) {
		format(tmpBuf, sizeof(tmpBuf), "%s\n%d)\t%s", tmpBuf, (i+1), szNick);
		i++;
	}
	mysql_free_result();
	ShowPlayerDialog(playerid, DIALOG_FRIENDS_LIST, DIALOG_STYLE_LIST, "Znajomi > Lista znajomych", tmpBuf, "Wróæ", "");
}

stock CFriends_InviteFriend(playerid, friendName[]) {
	if(isnull(friendName) || !(3<=strlen(friendName)<=MAX_PLAYER_NAME-1)) {
		ShowPlayerDialog(playerid, DIALOG_FRIENDS_INVITE, DIALOG_STYLE_INPUT, "Znajomi > Zaproœ znajomego", "W poni¿sze okienko wpisz nick osoby, któr¹ chcesz zaprosiæ do grona swoich znajomych.", "Dodaj", "Wróæ");
		return;
	}
	if(!theplayer::isAccountExists(friendName)) {
		ShowPlayerDialog(playerid, DIALOG_FRIENDS_INVITE, DIALOG_STYLE_INPUT, "Znajomi > Zaproœ znajomego", "W poni¿sze okienko wpisz nick osoby, któr¹ chcesz zaprosiæ do grona swoich znajomych.\nNie znaleziono osoby o takiej nazwie... Spróbuj jeszcze raz.", "Dodaj", "Wróæ");
		return;
	} else {
		new accountid=theplayer::getAccountIDByName(friendName);
		if(CFriends_CheckOrAreFriendByUID(PlayerData[playerid][epd_accountID], accountid)) {
			ShowPlayerDialog(playerid, DIALOG_FRIENDS_INVITE, DIALOG_STYLE_INPUT, "Znajomi > Zaproœ znajomego", "W poni¿sze okienko wpisz nick osoby, któr¹ chcesz zaprosiæ do grona swoich znajomych.\nTa osoba jest ju¿ na liœcie znajomych.", "Dodaj", "Wróæ");
			return;
		}
		new friendid=utility::getPlayerIDFromName(friendName);
		if(friendid==0xFFFF) {
			CMySQL_Query("INSERT INTO friends (ts_created, inviter, invited) VALUES (NOW(), '%d', '%d');", -1, PlayerData[playerid][epd_accountID], accountid);
		} else {
			CMySQL_Query("INSERT INTO friends (ts_created, inviter, invited) VALUES (NOW(), '%d', '%d');", -1, PlayerData[playerid][epd_accountID], PlayerData[friendid][epd_accountID]);
			// TODO:
			// Powiadomic gracza "friendid" o nowym zaproszeniu do znajomych
		}
	}
}

stock CFriends_DialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	switch(dialogid) {
		case DIALOG_FRIENDS_INDEX: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					// lista znajomych
					CFriends_SeeMyFriends(playerid);
				} 
				case 1: {
					// powiadomienia/akceptowanie zaproszen
				}
				case 2: {
					// dodawanie znajomego/zapraszanie
					ShowPlayerDialog(playerid, DIALOG_FRIENDS_INVITE, DIALOG_STYLE_INPUT, "Znajomi > Zaproœ znajomego", "W poni¿sze okienko wpisz nick osoby, któr¹ chcesz zaprosiæ do grona swoich znajomych.", "Dodaj", "Wróæ");
				}
			}
		}
		case DIALOG_FRIENDS_LIST: {
			if(response) {
				CFriends_ShowHomePage(playerid);
				return 1;
			}
		}
		case DIALOG_FRIENDS_ACCEPTING: {
			if(!response) {
				CFriends_ShowHomePage(playerid);
				return 1;
			}
			// todo
		}
		case DIALOG_FRIENDS_INVITE: {
			if(!response) {
				CFriends_ShowHomePage(playerid);
				return 1;
			}
			CFriends_InviteFriend(playerid, inputtext);
		}
	}
	return false;
}