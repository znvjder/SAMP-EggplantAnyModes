/*
	@file: /internal/CMessages.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

static stock
	string_MessagesBuffer[160];
	
stock theplayer::sendMessage(playerid, color, bool:makeBrighter=true, text[], va_args<>) {
	string_MessagesBuffer[0]=EOS;
	if(numargs()>4) {
		//CMessages_BoldText(color, makeBrighter, text);
		return SendClientMessage(playerid, color, va_return(string_MessagesBuffer, va_start<4>));
	} else {
		//CMessages_BoldText(color, makeBrighter, text);
		return SendClientMessage(playerid, color, text);
	}
}

stock theplayer::sendMessageToAll(color, bool:makeBrighter=true, text[], va_args<>) {
	string_MessagesBuffer[0]=EOS;
	if(numargs()>3) {
		//CMessages_BoldText(color, makeBrighter, text);
		return SendClientMessageToAll(color, va_return(string_MessagesBuffer, va_start<3>));
	} else {
		//CMessages_BoldText(color, makeBrighter, text);
		return SendClientMessageToAll(color, text);
	}
}

// TODO: funkcja do poprawy
stock CMessages_BoldText(color, bool:makeBrighter=true, text[]) {
	new color_transform[1];
	color_transform[0]=color;

	if(makeBrighter) {
		// brighter
		color_transform{0}=floatround((float(255-color_transform{0})*0.18)+float(color_transform{0}));
		color_transform{1}=floatround((float(255-color_transform{1})*0.18)+float(color_transform{1}));
		color_transform{2}=floatround((float(255-color_transform{2})*0.18)+float(color_transform{2}));
	} else {
		// darker
		color_transform{0}=floatround(float(color_transform{0})-(float(color_transform{0})*0.60));
		color_transform{1}=floatround(float(color_transform{1})-(float(color_transform{1})*0.60));
		color_transform{2}=floatround(float(color_transform{2})-(float(color_transform{2})*0.60));
	}
	
	new findpos=-1, tmpBuf[9];
	while((findpos=strfind(text, "<b>")) != -1) {
		format(tmpBuf, sizeof(tmpBuf), "{%06x}", color_transform[0]>>>8);
		strdel(text, findpos, findpos+3);
		strins(text, tmpBuf, findpos, strlen(text)+sizeof(tmpBuf));
		findpos=strfind(text, "<b>");
	}
	
	findpos=-1;
	while((findpos=strfind(text, "</b>")) != -1) {
		format(tmpBuf, sizeof(tmpBuf), "{%06x}", color>>>8);
		strdel(text, findpos, findpos+4);
		strins(text, tmpBuf, findpos, strlen(text)+sizeof(tmpBuf));
		findpos=strfind(text, "</b>");
	}
}
