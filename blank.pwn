// this is blank gamemode ;-)

#include <a_samp>
#include "external/funcUtility"

public OnFilterScriptInit() {
	new buf[]="ala ma kota, a kot ma ale";
	new srch[]="kot";
	new rep[]="czop";
	
	string_replace(buf, srch, rep);
	printf(buf);
}