select top 100 * from ICStockBill b
  left join ICStockBillEntry e on e.fInterId = b.fInterId
  left join t_icitem f on f.Fitemid=e.Fitemid
where f.fparentid='3390' or f.fparentid='3392'