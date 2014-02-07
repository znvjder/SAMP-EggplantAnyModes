/*
	@file: /internal/CTimers.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
	
*/

#define MAX_CTIMERS (10)

#define timer:%0(%1)\
		forward public @%0(%1);\
		public @%0(%1)

	
enum 
{
	TIMER_GAMELOOP=0,
	TIMER_WEATHER
};

static stock
	TimerUniqueID[MAX_CTIMERS] = {-1, ...};
	
stock CTimers_Init()
{
	TimerUniqueID[TIMER_GAMELOOP]=SetTimer("@GameLoop", 990+random(14-7), true);
	TimerUniqueID[TIMER_WEATHER]=SetTimer("@Weather", 0, false);
}

stock CTimers_Exit()
{
	for(new i; i<MAX_CTIMERS; i++)
	{
		if(TimerUniqueID[i]) 
		{
			KillTimer(TimerUniqueID[i]);
			TimerUniqueID[i]=-1;
		}
	}
}

stock CTimers_Call(timerid, funcname[], interval, repeat)
{
	TimerUniqueID[timerid]=SetTimer(funcname, interval, repeat);
}

#undef MAX_CTIMERS