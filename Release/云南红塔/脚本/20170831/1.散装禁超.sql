delete from sys_dict where d_name='SysParam' and d_memo='StrictSanVal'
insert into sys_dict(d_name,d_desc,d_value,d_memo) values('SysParam', '禁止散装超发', 'Y', 'StrictSanVal')