create nonclustered index idx_card on dbo.S_Bill(L_Card)with(allow_page_locks=off)
create nonclustered index idx_customer on dbo.S_Bill(L_CusName,L_CusPY)with(allow_page_locks=off)
create nonclustered index idx_date on dbo.S_Bill(L_Date desc)with(allow_page_locks=off)
create nonclustered index idx_id on dbo.S_Bill(L_ID desc)
create nonclustered index idx_inout_time on dbo.S_Bill(L_InTime desc,L_OutFact desc)with(allow_page_locks=off)
create nonclustered index idx_status on dbo.S_Bill(L_Status)with(allow_page_locks=off)
create nonclustered index idx_status_all on dbo.S_Bill(L_Status,L_NextStatus)with(allow_page_locks=off)
create nonclustered index idx_status_next on dbo.S_Bill(L_NextStatus desc)with(allow_page_locks=off)
create nonclustered index idx_truck on dbo.S_Bill(L_Truck)with(allow_page_locks=off)
create nonclustered index idx_zhika on dbo.S_Bill(L_ZhiKa)with(allow_page_locks=off)
create nonclustered index idx_card on dbo.S_BillBak(L_Card)with(allow_page_locks=off)
create nonclustered index idx_customer on dbo.S_BillBak(L_CusName,L_CusPY)with(allow_page_locks=off)
create nonclustered index idx_date on dbo.S_BillBak(L_Date desc)with(allow_page_locks=off)
create nonclustered index idx_id on dbo.S_BillBak(L_ID desc)
create nonclustered index idx_inout_time on dbo.S_BillBak(L_InTime desc,L_OutFact desc)with(allow_page_locks=off)
create nonclustered index idx_status on dbo.S_BillBak(L_Status)with(allow_page_locks=off)
create nonclustered index idx_status_all on dbo.S_BillBak(L_Status,L_NextStatus)with(allow_page_locks=off)
create nonclustered index idx_status_next on dbo.S_BillBak(L_NextStatus desc)with(allow_page_locks=off)
create nonclustered index idx_truck on dbo.S_BillBak(L_Truck)with(allow_page_locks=off)
create nonclustered index idx_zhika on dbo.S_BillBak(L_ZhiKa)with(allow_page_locks=off)
create nonclustered index idx_customer on dbo.S_StockHuaYan(H_Custom,H_CusName)with(allow_page_locks=off)
create nonclustered index idx_date on dbo.S_StockHuaYan(H_ReportDate desc)with(allow_page_locks=off)
create nonclustered index idx_no on dbo.S_StockHuaYan(H_No)with(allow_page_locks=off)
create nonclustered index idx_serial on dbo.S_StockHuaYan(H_SerialNo)with(allow_page_locks=off)
create nonclustered index idx_date on dbo.S_StockRecord(R_Date desc)with(allow_page_locks=off)
create nonclustered index idx_no on dbo.S_StockRecord(R_SerialNo)with(allow_page_locks=off)
create nonclustered index idx_customer on dbo.S_ZhiKa(Z_Customer)with(allow_page_locks=off)
create nonclustered index idx_date on dbo.S_ZhiKa(Z_Date desc)with(allow_page_locks=off)
create nonclustered index idx_id on dbo.S_ZhiKa(Z_ID desc)with(allow_page_locks=off)
create nonclustered index idx_invalid on dbo.S_ZhiKa(Z_InValid desc)with(allow_page_locks=off)
create nonclustered index idx_valid on dbo.S_ZhiKa(Z_ValidDays desc)with(allow_page_locks=off)
create nonclustered index idx_stock on dbo.S_ZhiKaDtl(D_StockNo)with(allow_page_locks=off)
create nonclustered index idx_zhika on dbo.S_ZhiKaDtl(D_ZID desc)
create nonclustered index idx_bill on dbo.S_ZTTrucks(T_Bill)with(allow_page_locks=off)
create nonclustered index idx_truck on dbo.S_ZTTrucks(T_Truck)with(allow_page_locks=off)
create nonclustered index idx_type on dbo.Sys_CustomerInOutMoney(M_Type)with(allow_page_locks=off)
create nonclustered index idx_query on dbo.Sys_EventLog(L_Date desc)with(allow_page_locks=off)
create nonclustered index idx_bill on dbo.Sys_PoundLog(P_Bill desc)with(allow_page_locks=off)
create nonclustered index idx_id on dbo.Sys_PoundLog(P_ID desc)with(allow_page_locks=off)
create nonclustered index idx_mdate on dbo.Sys_PoundLog(P_MDate desc)
create nonclustered index idx_pdate on dbo.Sys_PoundLog(P_PDate desc)
create nonclustered index idx_pmdate on dbo.Sys_PoundLog(P_PDate desc,P_MDate desc)with(allow_page_locks=off)
create nonclustered index idx_truck on dbo.Sys_PoundLog(P_Truck)with(allow_page_locks=off)
create nonclustered index idx_type on dbo.Sys_PoundLog(P_Type)with(allow_page_locks=off)








