/**--------------------------------------------------------------------------**\
                              =====================
                               YSI - Version Check
                              =====================
Description:
	Checks online to see if there is a newer version of YSI available.
Legal:
	Version: MPL 1.1
	
	The contents of this file are subject to the Mozilla Public License Version 
	1.1 (the "License"); you may not use this file except in compliance with 
	the License. You may obtain a copy of the License at 
	http://www.mozilla.org/MPL/
	
	Software distributed under the License is distributed on an "AS IS" basis,
	WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
	for the specific language governing rights and limitations under the
	License.
	
	The Original Code is the YSI version check include.
	
	The Initial Developer of the Original Code is Alex "Y_Less" Cole.
	Portions created by the Initial Developer are Copyright (C) 2011
	the Initial Developer. All Rights Reserved.
	
	Contributors:
		ZeeX, koolk, JoeBullet/Google63, g_aSlice/Slice
	
	Thanks:
		JoeBullet/Google63 - Handy arbitrary ASM jump code using SCTRL.
		ZeeX - Very productive conversations.
		koolk - IsPlayerinAreaEx code.
		TheAlpha - Danish translation.
		breadfish - German translation.
		Fireburn - Dutch translation.
		yom - French translation.
		50p - Polish translation.
		Zamaroht - Spanish translation.
		Dracoblue, sintax, mabako, Xtreme, other coders - Producing other modes
			for me to strive to better.
		Pixels^ - Running XScripters where the idea was born.
		Matite - Pestering me to release it and using it.
	
	Very special thanks to:
		Thiadmer - PAWN, whose limits continue to amaze me!
		Kye/Kalcor - SA:MP.
		SA:MP Team past, present and future - SA:MP.
	
Version:
	0.2
Changelog:
	26/10/10:
		Added changelog capabilities.
	22/10/10:
		First version.
Functions:
	Public:
		-
	Core:
		-
	Stock:
		-
	Static:
		-
	Inline:
		-
	API:
		-
	Hooks:
		OnGameModeInit
Callbacks:
	-
Definitions:
	-
Enums:
	-
Macros:
	-
Tags:
	-
Variables:
	Global:
		-
	Static:
		-
Commands:
	-
Compile options:
	-
Operators:
	-
Natives:
	-
</remarks>
\**--------------------------------------------------------------------------**/

#include <a_samp>
#tryinclude <a_http>
#include "y_natives"

#if MAX_PLAYER_NAME != (24)
	#error Unknown MAX_PLAYER_NAME size.
#else
	// Strip the brackets off.
	#undef MAX_PLAYER_NAME
	#define MAX_PLAYER_NAME 24
#endif

#include "..\y_scriptinit"

#define YSI_VERSION_RESPO               2

#define YSI_VERSION_MAJOR               1
#define YSI_VERSION_MINOR               06
#define YSI_VERSION_BUILD               0002

#define YSI_VERSION                     #YSI_VERSION_MAJOR "." #YSI_VERSION_MINOR "." #YSI_VERSION_BUILD

#if defined _YSI_NO_VERSION_CHECK
	
	public OnScriptInit()
	{
		#if defined YSI_LOCK_MODE
			new
				x = 10;
			YSI_gLockData[YSI_gLockData[2]++] += (YSI_gLockData[3] = floatround(floatpower(x, 2))) - 2;
			YSI_gLockData[YSI_gLockData[2]++] = (YSI_gLockData[3] | 0x09) & ~0x04;
			YSI_gLockData[2] *= (6 * x) - 5;
		#endif
		#if defined YVers_OnScriptInit
			YVers_OnScriptInit();
		#endif
		return 1;
	}
	
	#undef OnScriptInit
	#define OnScriptInit YVers_OnScriptInit
	#if defined YVers_OnScriptInit
		forward YVers_OnScriptInit();
	#endif
	
#else
/**----------------------------------------------------------------------**\
	Hook:
		OnScriptInit
	</returns>
<remarks>
		Constructor.  Checks to see if there is a new version available.  This
		code can not use ANY of the rest of YSI as it needs to be included by
		everything first.
</remarks>
\**----------------------------------------------------------------------**/
	
	#if !defined _inc_a_http
	
		public OnScriptInit()
		{
			#if defined YSI_LOCK_MODE
				new
					x = 10;
				YSI_gLockData[0] = 'a' + 1;
				YSI_gLockData[YSI_gLockData[0] - 0x60] = x * 11;
				YSI_gLockData[x / 3] = x * 10;
				YSI_gLockData[1] = (YSI_gLockData[2] - YSI_gLockData[3]) / 2 + YSI_gLockData[3];
			#endif
			print(" ");
			print(" ");
			print(" ");
			print(" ======================================= ");
			print(" |                                     | ");
			print(" |        YSI version " YSI_VERSION "        | ");
			print(" |        By Alex \"Y_Less\" Cole        | ");
			print(" |                                     | ");
			print(" |   Unable to check the latest YSI    | ");
			print(" |  version, please watch the forums.  | ");
			print(" |                                     | ");
			print(" ======================================= ");
			print(" ");
			#if defined YVers_OnScriptInit
				YVers_OnScriptInit();
			#endif
			return 1;
		}
		
		#undef OnScriptInit
		#define OnScriptInit YVers_OnScriptInit
		#if defined YVers_OnScriptInit
			forward YVers_OnScriptInit();
		#endif
		
		#endinput
	#endif
	
	forward YVers_Callback(index, code, data[]);
	
	public OnScriptInit()
	{
		#if defined YSI_LOCK_MODE
			YSI_gLockData[0] += 1;
			for (new i = 0; i != 2; ++i)
			{
				YSI_gLockData[0] = YSI_gLockData[0] * 9 + 2;
			}
			YSI_gLockData[0] -= 1;
			YSI_gLockData[3] = YSI_gLockData[0];
			YSI_gLockData[0] -= 1;
			YSI_gLockData[2] = YSI_gLockData[0] + 11;
			YSI_gLockData[0] -= 1;
			YSI_gLockData[1] = YSI_gLockData[0] + 7;
		#endif
		HTTP(0, HTTP_GET, "ysi-version.y-less.com/index.php?c=" #YSI_VERSION_RESPO "&v=" YSI_VERSION, "", "YVers_Callback");
		#if defined YVers_OnScriptInit
			YVers_OnScriptInit();
		#endif
		return 1;
	}
	
	#undef OnScriptInit
	#define OnScriptInit YVers_OnScriptInit
	#if defined YVers_OnScriptInit
		forward YVers_OnScriptInit();
	#endif
	
	/**----------------------------------------------------------------------**\
	<summary>YVers_Callback</summary>
	<param name="	index">Not used.</param>
	<param name="	code">Response code from the server.</param>
	<param name="	data[]">HTTP data sent from the server.</param>
	<returns>
		-
	</returns>
	<remarks>
		This is called when my server responds to the HTTP request sent above
		(or when it doesn't).  This prints information on the current and any
		future versions of YSI.  Note that it only does a strcmp to determine if
		the version is newer - people can't have versions newer than the latest,
		onlyolder or equal (unless they play with the version numbers, but then
		that's their own fault).
	</remarks>
	\**----------------------------------------------------------------------**/
	
	public YVers_Callback(index, code, data[])
	{
	}
	
#endif
