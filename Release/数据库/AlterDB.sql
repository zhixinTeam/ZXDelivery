-----------------------------------------------------------------------------------------------------------
--2018.05.27: 添加返利和运费
if not exists (select * from syscolumns where name='D_FLPrice' and id=object_id('S_ZhiKaDtl'))
begin
  alter table S_ZhiKaDtl add D_FLPrice decimal(15, 5) Default 0
  EXEC('update S_ZhiKaDtl set D_FLPrice=0')
end

if not exists (select * from syscolumns where name='D_YunFei' and id=object_id('S_ZhiKaDtl'))
begin
  alter table S_ZhiKaDtl add D_YunFei decimal(15, 5) Default 0
  EXEC('update S_ZhiKaDtl set D_YunFei=0')
end

------------------------------------------------------------------------------------------------------------
--2018.05.28: 添加组用途标识
if not exists (select * from syscolumns where name='G_Flag' and id=object_id('Sys_Group'))
begin
  alter table Sys_Group add G_Flag varChar(32)
  --web组使用web标记
end

if not exists (select * from syscolumns where name='R_YunFei' and id=object_id('Sys_InvoiceRequst'))
begin
  alter table Sys_InvoiceRequst add R_YunFei decimal(15, 5) Default 0
  EXEC('update Sys_InvoiceRequst set R_YunFei=0')
end

if not exists (select * from syscolumns where name='R_YunFei' and id=object_id('Sys_InvoiceReqtemp'))
begin
  alter table Sys_InvoiceReqtemp add R_YunFei decimal(15, 5) Default 0
  EXEC('update Sys_InvoiceReqtemp set R_YunFei=0')
end

if not exists (select * from syscolumns where name='S_YunFei' and id=object_id('Sys_InvoiceSettle'))
begin
  alter table Sys_InvoiceSettle add S_YunFei decimal(15, 5) Default 0
  EXEC('update Sys_InvoiceSettle set S_YunFei=0')
end