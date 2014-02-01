/*
	@file: /internal/CObjects.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

stock CObjects_Init()
{
	printf("[CObjects]: was loaded. Creating objects wait...");
	CObject_Load();
}

stock CObjects_Exit()
{
	DestroyAllDynamicObjects();
	printf("[CObjects]: was unloaded");
}

stock CObject_Load()
{
	new object, count, tmpBuf[255], Float:fPos[6], mt_idx, mt_modelid, mt_txdname[32], mt_texture[32],
		mt_color, mtxt_idx, mtxt_text[64], mtxt_msize, mtxt_font[18], mtxt_fisze, mtxt_fbold, 
		mtxt_fcolor, mtxt_fbcolor, mtxt_falign, vw, interior;
		
	CMySQL_Query("SELECT modelid,fX,fY,fZ,fRX,fRY,fRZ,mt_idx,mt_modelid,mt_texture,mt_color,mtxt_idx,mtxt_text,mtxt_msize,mtxt_font,mtxt_fsize,mtxt_fbold,mtxt_color,mtxt_fbcolor,mtxt_falign,vw,interior FROM objects WHERE spawn=1", -1);
	mysql_store_result();
	while(mysql_fetch_row(tmpBuf, "|"))
	{
		if(sscanf(tmpBuf, "p<|>dffffffdds[32]s[32]dds[64]ds[18]ddxxdd",
			fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5],
			mt_idx, mt_modelid, mt_txdname, mt_texture,
			mt_color, mtxt_idx, mtxt_text, mtxt_msize, mtxt_font,
			mtxt_fisze, mtxt_fbold, mtxt_fcolor, mtxt_fbcolor, mtxt_falign, vw, interior
		)) continue;
		
		object=CreateDynamicObject(fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], vw, interior, _, 300);
		if(mtxt_idx != -1)
		{
			SetDynamicObjectMaterial(object, mtxt_idx, mt_modelid, mt_txdname, mt_texture, mt_color);
		}
		if(mtxt_idx != -1)
		{
			SetDynamicObjectMaterialText(object, mtxt_idx, mtxt_text, mtxt_msize, mtxt_font, mtxt_fisze, mtxt_fbold, mtxt_fcolor, mtxt_fbcolor, mtxt_falign);
		}
		count++;
	}
	mysql_free_result();
	printf("[CObjects]: Created %d objects in the map", count);
}