/*
	@file: /internal/CWeather.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

stock CWeather_Update()
{
	new hour, randomWeather=random(150);
	gettime(hour);
	SetWorldTime(hour);
	
	static const
		foggy_weather[] = {9, 19, 20, 31, 32},
		fine_weather[] = {1, 2, 3, 4, 5, 6, 7, 12, 13, 14, 15, 17, 18, 24, 25, 26, 27, 29, 30, 40},
		wet_weather[] = {8};
		
	if(randomWeather<60) SetWeather(fine_weather[random(sizeof(fine_weather))]);
	else if(randomWeather<110) SetWeather(foggy_weather[random(sizeof(foggy_weather))]);
	else SetWeather(wet_weather[random(sizeof(wet_weather))]);
}