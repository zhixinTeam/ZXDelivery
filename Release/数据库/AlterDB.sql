--2018.05.27: 添加返利和运费
if not exists (select * from syscolumns where name='D_FLPrice' and id=object_id('S_ZhiKaDtl'))
begin
  alter table S_ZhiKaDtl add D_FLPrice decimal(15, 5) Default 0;
  update S_ZhiKaDtl set D_FLPrice=0;
end

if not exists (select * from syscolumns where name='D_YunFei' and id=object_id('S_ZhiKaDtl'))
begin
  alter table S_ZhiKaDtl add D_YunFei decimal(15, 5) Default 0;
  update S_ZhiKaDtl set D_YunFei=0;
end