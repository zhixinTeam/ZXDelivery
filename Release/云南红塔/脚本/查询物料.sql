select FItemID,FName,FFullName,FDefaultLoc from t_icitem where fparentid='3380'or fparentid='3390' or fparentid='3392' order by FItemID
--查询物料

select 'StockItem' as D_Name, FName as D_Value, FFullName as D_Desc,
	(case when CharIndex('包装', FFullName) > 0 then 'D' else 'S' end) as D_Memo,	
	FDefaultLoc as D_ParamA, FItemID as D_ParamB from dbo.Sys_Dict_Stock
--导入字典