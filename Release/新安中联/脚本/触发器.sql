set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

Create TRIGGER [Trig_Organization_Del] ON [dbo].[t_Organization]   
FOR DELETE  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)
  INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
	select 'T_Organization','D',GetDate(),FItemID from DELETED	
end

go

/**************************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


Create TRIGGER [Trig_Organization_Update] ON [dbo].[t_Organization]   
FOR UPDATE  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)

  declare @InsID bigint;
  select @InsID =FItemID from INSERTED
    
  INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
	select 'T_Organization','E',GetDate(),FItemID from DELETED where FItemID=@InsID	
end

/**************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


Create TRIGGER [Trig_Organization_Add] ON [dbo].[t_Organization]   
FOR INSERT  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  begin	
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)
  end
  INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
	select 'T_Organization','A',GetDate(),FItemID from INSERTED	
end


