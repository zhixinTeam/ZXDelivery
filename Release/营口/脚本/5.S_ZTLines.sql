SET   IDENTITY_INSERT   S_ZTLines   ON
--set   nocount   on   select   'insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values('as   '--',R_ID,',',''''+Z_ID+'''',',',''''+Z_Name+'''',',',''''+Z_StockNo+'''',',',''''+Z_Stock+'''',',',''''+Z_StockType+'''',',',Z_PeerWeight,',',Z_QueueMax,',',''''+Z_VIPLine+'''',',',''''+Z_Valid+'''',',',Z_Index,')'   from   S_ZTLines
--                                                                                                                             R_ID                                                                                                                                                                                                          Z_PeerWeight      Z_QueueMax                           Z_Index     
------------------------------------------------------------------------------------------------------------------------------ ----------- ---- ----------------- ---- ---------------------------------- ---- ---------------------- ---- ---------------------------------------------------------------------------------- ---- ---- ---- ------------ ---- ----------- ---- ---- ---- ---- ---- ----------- ----
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 1           ,    'ZT001'           ,    '42.5-1道'                          ,    'BPO-01'                 ,    '袋装_42.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 2           ,    'ZT002'           ,    '42.5-2道'                          ,    'BPO-01'                 ,    '袋装_42.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 3           ,    'ZT003'           ,    '22.5-3道'                          ,    'BPC-03'                 ,    '袋装_22.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 4           ,    'ZT004'           ,    '22.5-4道'                          ,    'BPC-03'                 ,    '袋装_22.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 5           ,    'ZT005'           ,    '32.5-1道'                          ,    'BPC-01'                 ,    '袋装_32.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 6           ,    'ZT006'           ,    '32.5-2道'                          ,    'BPC-01'                 ,    '袋装_32.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 7           ,    'ZT007'           ,    '32.5-3道'                          ,    'BPC-01'                 ,    '袋装_32.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 8           ,    'ZT008'           ,    '32.5-4道'                          ,    'BPC-01'                 ,    '袋装_32.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 9           ,    'FH001'           ,    '散14-42.5'                         ,    'PO-001'                 ,    '散装_42.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 10          ,    'FH002'           ,    '散15-42.5'                         ,    'PO-001'                 ,    '散装_42.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 11          ,    'FH003'           ,    '散16-52.5'                         ,    'PO-002'                 ,    '散装_52.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 12          ,    'FH004'           ,    '散17-42.5'                         ,    'PO-001'                 ,    '散装_42.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 13          ,    'FH005'           ,    '散18-32.5'                         ,    'PC-001'                 ,    '散装_32.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 14          ,    'FH006'           ,    '散19-42.5'                         ,    'PO-001'                 ,    '散装_42.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )
insert   S_ZTLines(R_ID,Z_ID,Z_Name,Z_StockNo,Z_Stock,Z_StockType,Z_PeerWeight,Z_QueueMax,Z_VIPLine,Z_Valid,Z_Index)   values( 15          ,    'FH007'           ,    '散20-42.5'                         ,    'PO-001'                 ,    '散装_42.5'                                                                       ,    NULL ,    50           ,    20          ,    'C'  ,    'Y'  ,    NULL        )

SET   IDENTITY_INSERT   S_ZTLines   OFF
