/*
	@file: /internal/CTimers.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
	
	Notatka:
		Funkcje, ktore wymagaja powtorzenia co jakis czas - umieszczac wlasnie tutaj
*/

#define MAX_CTIMERS (10)

#define timer:%0(%1)\
		forward public @%0(%1);\
		public @%0(%1)

#define CTIMER_LOCKCALL(%0) \
	if(TimersData[%0][etd_timerCalled]) return;\
	else TimersData[%0][etd_timerCalled]=true

#define CTIMER_FREECALL(%0,%1)\
	TimersData[%0][etd_timerCalled]=false;\
	CTimers_Call(%0, #%1)
	
enum e_TimersData
{
	bool:etd_timerRunning,
	bool:etd_timerCalled,
	etd_timerID,
	etd_timerInterval, // czas powtarzania + randomowe milisekundy
	etd_timerTick
};

static stock
	TimersData[MAX_CTIMERS][e_TimersData];
	
stock CTimers_Init()
{
	CTimers_Add(0, "@GameLoop", 990);
	CTimers_Add(1, "@Weather", DURATION(30 minutes));
}

stock CTimers_Exit()
{
	for(new i; i<MAX_CTIMERS; i++)
	{
		if(TimersData[i][etd_timerRunning]) 
		{
			KillTimer(TimersData[i][etd_timerID]);
			TimersData[i][etd_timerID]=-1;
			TimersData[i][etd_timerInterval]=0;
			TimersData[i][etd_timerTick]=0;
			TimersData[i][etd_timerRunning]=false;
			TimersData[i][etd_timerCalled]=false;
		}
	}
}

static stock CTimers_Add(timerid, funcname[], interval)
{
	TimersData[timerid][etd_timerID]=SetTimer(funcname, interval+random(14-7), false);
	TimersData[timerid][etd_timerInterval]=interval;
	TimersData[timerid][etd_timerTick]=0;
	TimersData[timerid][etd_timerRunning]=true;
	TimersData[timerid][etd_timerCalled]=false;
}

static stock CTimers_Call(timerid, funcname[])
{
	if(!TimersData[timerid][etd_timerRunning]) return;
	if(GetTickCount()-TimersData[timerid][etd_timerTick]<TimersData[timerid][etd_timerInterval]) 
	{
		CTimers_Call(timerid, funcname);
		return;
	}
	
	TimersData[timerid][etd_timerID]=SetTimer(funcname, TimersData[timerid][etd_timerInterval]+random(14-7), false);
	TimersData[timerid][etd_timerTick]=GetTickCount();
}
 
// Timers callbacks
timer:Weather()
{
	CTIMER_LOCKCALL(1);
	
	
	CTIMER_FREECALL(1, @Weather);
}

timer:GameLoop()
{
	CTIMER_LOCKCALL(0);
	
	new tick=tickcount();
	
	
	CTIMER_FREECALL(0, @GameLoop);
}

#undef MAX_CTIMERS
#undef CTIMER_LOCKCALL
#undef CTIMER_FREECALL