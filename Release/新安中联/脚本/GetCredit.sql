set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[GetCredit]

	@Cust varchar(50),
	@Credit decimal(28, 10) output,
	@Balance decimal(28,10) output
AS
BEGIN
	SET NOCOUNT ON;

declare @CustId int

select @CustId = (select fitemid from t_organization where fnumber = @Cust)

declare @CurYear nvarchar(255)
declare @CurPeriod nvarchar(255)

select @CurYear = (select fvalue from t_rp_systemprofile where fkey = 'FARCurYear')
select @CurPeriod = (select fvalue from t_rp_systemprofile where fkey = 'FARCurperiod')

declare @BBAL decimal(18,4)--期初余额
declare @rec1 decimal(18,4)--收款单
declare @rec2 decimal(18,4)--预收单
declare @sale decimal(18,4)--发票
declare @icstock decimal(18,4)--出库单
declare @seout decimal(18,4)--发货单
declare @arp decimal(18,4)--其他应收
declare @aosh decimal(18,4)--退款单

--期初余额
select @BBAL = (select isnull(SUM(FBEGINBALANCEFOR),0) 
FROM T_RP_CONTACTBAL t
--left join t_perioddate p on t.fyear = p.fyear and t.fperiod = p.fperiod 
 --WHERE t.FCUSTOMER = @CustId AND p.fstartdate <= GetDate() and fenddate >= GetDate())
WHERE t.FCUSTOMER = @CustId and t.fyear = @CurYear and t.fperiod = @CurPeriod)

--收款单预收单
select @rec1 = (select isnull(sum(famount),0)
from t_rp_newreceivebill t
--left join t_perioddate p on t.fyear = p.fyear and t.fperiod = p.fperiod 
--where t.fcustomer = @CustId and p.fstartdate <= GetDate() and fenddate >= GetDate() AND T.FCLASSTYPEID = 1000014)
WHERE t.FCUSTOMER = @CustId AND T.FCLASSTYPEID = 1000014
	and t.fdate >= (select fstartdate from t_perioddate where fyear = @CurYear and fperiod = @CurPeriod)
	and t.fdate <= (select fenddate from t_perioddate where fstartdate <= GetDate() and fenddate >= convert(varchar(100),GetDate(),23)))

select @rec2 = (select isnull(sum(famount),0)
from t_rp_newreceivebill t
--left join t_perioddate p on t.fyear = p.fyear and t.fperiod = p.fperiod 
--where t.fcustomer = @CustId and p.fstartdate <= GetDate() and fenddate >= GetDate() AND T.FCLASSTYPEID = 1000005)
WHERE t.FCUSTOMER = @CustId AND T.FCLASSTYPEID = 1000005
	and t.fdate >= (select fstartdate from t_perioddate where fyear = @CurYear and fperiod = @CurPeriod)
	and t.fdate <= (select fenddate from t_perioddate where fstartdate <= GetDate() and fenddate >= convert(varchar(100),GetDate(),23)))

--发票
select @sale = (select isnull(sum(FQty * FTaxPrice),0)
from ICSALEentry e
left join ICSALE s on e.finterid = s.finterid
--left join t_perioddate p on s.fyear = p.fyear and s.fperiod = p.fperiod 
--where s.fcustid = @CustId and p.fstartdate <= GetDate() and fenddate >= GetDate())
WHERE s.fcustid = @CustId
	and s.fdate >= (select fstartdate from t_perioddate where fyear = @CurYear and fperiod = @CurPeriod)
	and s.fdate <= (select fenddate from t_perioddate where fstartdate <= GetDate() and fenddate >= convert(varchar(100),GetDate(),23)))


--出库单
select @icstock = (select isnull(sum(fconsignamount),0) from icstockbillentry e 
left join icstockbill i on e.finterid = i.finterid
where i.fchildren = 0 and i.ftrantype = 21 and i.fsupplyid = @CustId
--and i.fdate >= (select fstartdate from t_perioddate where fstartdate <= GetDate() and fenddate >= GetDate())
	and i.fdate >= (select fstartdate from t_perioddate where fyear = @CurYear and fperiod = @CurPeriod)
	and i.fdate <= (select fenddate from t_perioddate where fstartdate <= GetDate() and fenddate >= convert(varchar(100),GetDate(),23)))

--发货单
select @seout = (select isnull(sum(e.famount),0) from seoutstockentry e
left join seoutstock s on e.finterid = s.finterid
where s.fclosed = 0 and s.fcustid = @CustId
--and s.fdate >= (select fstartdate from t_perioddate where fstartdate <= GetDate() and fenddate >= GetDate())
	and s.fdate >= (select fstartdate from t_perioddate where fyear = @CurYear and fperiod = @CurPeriod)
	and s.fdate <= (select fenddate from t_perioddate where fstartdate <= GetDate() and fenddate >= convert(varchar(100),GetDate(),23)))

--其他应收
select @arp = (select isnull(sum(e.famount),0) from t_rp_arpbillentry e
left join t_rp_arpbill a on e.fbillid = a.fbillid
--left join t_perioddate p on a.fyear = p.fyear and a.fperiod = p.fperiod 
where a.fitemclassid = 1 and a.fcustomer = @CustId and a.fbilltype = 995
--and a.fcustomer = @CustId and p.fstartdate <= GetDate() and fenddate >= GetDate() and a.fbilltype = 995)
	and a.fdate >= (select fstartdate from t_perioddate where fyear = @CurYear and fperiod = @CurPeriod)
	and a.fdate <= (select fenddate from t_perioddate where fstartdate <= GetDate() and fenddate >= convert(varchar(100),GetDate(),23)))

--退款单
select @aosh = (select isnull(sum(famount_entry),0) from t_rp_arbillofsh a
left join t_rp_newreceivebill n on a.fbillid = n.fbillid
--left join t_perioddate p on n.fyear = p.fyear and n.fperiod = p.fperiod 
where n.FCLASSTYPEID = 1000015 and n.fitemclassid = 1 and n.fcustomer = @CustId
--and p.fstartdate <= GetDate() and fenddate >= GetDate())
	and n.fdate >= (select fstartdate from t_perioddate where fyear = @CurYear and fperiod = @CurPeriod)
	and n.fdate <= (select fenddate from t_perioddate where fstartdate <= GetDate() and fenddate >= convert(varchar(100),GetDate(),23)))

select @Balance = @BBAL-@rec1-@rec2+@sale+@icstock+@seout+@arp+@aosh

select @Credit = (select isnull(famount,0) as cre from iccreditobject where fitemid = @CustId and fcreditclass = 0)

if @Credit = null
begin
	set @Credit = 0
end

end






