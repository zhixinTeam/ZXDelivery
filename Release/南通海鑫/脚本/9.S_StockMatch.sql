Delete From S_StockMatch

SET   IDENTITY_INSERT   S_StockMatch   ON
--set   nocount   on   select   'insert   S_StockMatch(R_ID,M_Group,M_ID,M_Name,M_Status)   values('as   '--',R_ID,',',''''+M_Group+'''',',',''''+M_ID+'''',',',''''+M_Name+'''',',',''''+M_Status+'''',')'   from   S_StockMatch
--                                                                 R_ID                                                                                                                                                      
------------------------------------------------------------------ ----------- ---- ---------- ---- ---------------------- ---- ---------------------------------------------------------------------------------- ---- ---- ----
insert   S_StockMatch(R_ID,M_Group,M_ID,M_Name,M_Status)   values( 1           ,    'BZ01'     ,    'BPC-01'               ,    '袋装_32.5'                                                                          ,    'Y'  )
insert   S_StockMatch(R_ID,M_Group,M_ID,M_Name,M_Status)   values( 2           ,    'BZ01'     ,    'BPO-01'               ,    '袋装_42.5'                                                                          ,    'Y'  )
insert   S_StockMatch(R_ID,M_Group,M_ID,M_Name,M_Status)   values( 3           ,    'BZ01'     ,    'BPOS-01'              ,    '袋装_42.5缓凝'                                                                        ,    'N'  )

SET   IDENTITY_INSERT   S_StockMatch   OFF
