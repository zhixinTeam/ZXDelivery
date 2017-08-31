select e.FInterID,e.FEntryID,i.FItemID as StockID,
  i.FName as StockName,org.FItemID CusID,org.FName as CusName,
  e.FQty as StockValue,e.FNote as Truck from SEOrderEntry e
	left join SEOrder o on o.FInterID=e.FInterID
	left join t_Organization org on org.FItemID=o.FcustID
	left join t_ICItem i on i.FItemID=e.FItemID
WHERE e.FInterID = 289459 AND e.FEntryID=2 

select o.FBillNo,e.FInterID,e.FEntryID,i.FItemID as StockID,
  i.FName as StockName,org.FItemID CusID,org.FName as CusName,
  e.FQty as StockValue,e.FNote as Truck from SEOrderEntry e
   left join SEOrder o on o.fInterID=e.fInterID
  left join t_Organization org on org.FItemID=o.FcustID
  left join t_ICItem i on i.FItemID=e.FItemID
WHERE e.FDate>=getDate()-10 and o.FcustID='36540' and o.FCancellation=0 and o.FStatus=1