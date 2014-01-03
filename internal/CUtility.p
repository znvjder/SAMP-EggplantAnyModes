/*
	@file: /internal/CUtility.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013, l0nger.programmer@gmail.com
*/

stock strcpy(dest[], const source[], length = sizeof(source)) // by promsters
{
	strins((dest[0] = EOS, dest), source, 0, length);
}