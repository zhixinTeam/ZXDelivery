Delete From Sys_Dict Where D_Name='StockItem'

--set   nocount   on   select   'insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('as   '--',''''+D_Name+'''',',',''''+D_Desc+'''',',',''''+D_Value+'''',',',''''+D_Memo+'''',',',D_ParamA,',',''''+D_ParamB+'''',',',D_Index,')'   from   Sys_Dict
--                                                                                                                                                                                                                                     D_ParamA                                                                                               D_Index     
----------------------------------------------------------------------------------- ----------------- ---- -------------------------------- ---- ---------------------------------------------------- ---- ---------------------- ---- --------------------------------------- ---- ---------------------------------------------------- ---- ----------- ----
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO32.5R散'                       ,    '散装_PO32.5R散'                                        ,    'S'                    ,    NULL                                    ,    '6059'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO32.5散'                        ,    '散装_PO32.5散'                                         ,    'S'                    ,    NULL                                    ,    '6061'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PC32.5散'                        ,    '散装_PC32.5散'                                         ,    'S'                    ,    NULL                                    ,    '6063'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PII42.5R散'                      ,    '散装_PII42.5R散'                                       ,    'S'                    ,    NULL                                    ,    '6065'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO42.5散'                        ,    '散装_PO42.5散'                                         ,    'S'                    ,    NULL                                    ,    '6067'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PII52.5散'                       ,    '散装_PII52.5散'                                        ,    'S'                    ,    NULL                                    ,    '6069'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO52.5R散'                       ,    '散装_PO52.5R散'                                        ,    'S'                    ,    NULL                                    ,    '6071'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO52.5＃散'                       ,    '散装_PO52.5＃散'                                        ,    'S'                    ,    NULL                                    ,    '6073'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO32.5R袋'                       ,    '袋装_PO32.5R袋'                                        ,    'D'                    ,    NULL                                    ,    '6077'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO32.5袋'                        ,    '袋装_PO32.5袋'                                         ,    'D'                    ,    NULL                                    ,    '6079'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PC32.5袋'                        ,    '袋装_PC32.5袋'                                         ,    'D'                    ,    NULL                                    ,    '6081'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PII42.5R袋'                      ,    '袋装_PII42.5R袋'                                       ,    'D'                    ,    NULL                                    ,    '6083'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO42.5袋'                        ,    '袋装_PO42.5袋'                                         ,    'D'                    ,    NULL                                    ,    '6085'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PII52.5袋'                       ,    '袋装_PII52.5袋'                                        ,    'D'                    ,    NULL                                    ,    '6087'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO52.5R袋'                       ,    '袋装_PO52.5R袋'                                        ,    'D'                    ,    NULL                                    ,    '6089'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    'PO52.5＃袋'                       ,    '袋装_PO52.5＃袋'                                        ,    'D'                    ,    NULL                                    ,    '6091'                                               ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values('StockItem'       ,    '熟料'                             ,    '自制半成品_熟料'                                           ,    'S'                    ,    NULL                                    ,    '6053'                                               ,    0           )