//----------------------------------- 通用 -------------------------------------
{.$DEFINE DEBUG}
//调试模式

{.$DEFINE TrialVersion}
//试用版本

{$DEFINE UseReport}
//报表支持

{.$DEFINE RandomID}
//使用随机编号

{$DEFINE cxLibrary42}
//Ver4.2编译环境
{$DEFINE RemObjects}
{$DEFINE RO_v90}
//XE.Lib启用RO支持

{$DEFINE EnableBackupDB}
//备用数据库支持
{.$DEFINE EnableDoubleDB}
//双数据库支持

//---------------------------------- 中间件 ------------------------------------
{.$DEFINE ClientMon}
//进程守护客户端

{$DEFINE HardMon}
//编译硬件守护

{.$DEFINE GenRODL}
//生成RODL资源

{$DEFINE COM_MIT}
//定义系统模式

//通用中间件
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //启用数据库支持
  {.$DEFINE ChannelPool}
  //启用通道支持
  {.$DEFINE AutoChannel}
  //启用通道平衡
  {.$DEFINE SAP}
  //启用SAP支持
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

//--------------------------------- 特定系统 -----------------------------------
{.$DEFINE COMMON}
//通用版本

{$DEFINE QJXY}
{$DEFINE JZZJ}
//特定系统

//新乡春江
{$IFDEF XXCJ}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE TruckProberEx}
  //车检光栅状态判断扩展(此开关启用时建议同时启用MITTruckProber开关)
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE ForceEleCard}
  //强制车辆办理和启用电子标签
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE KuangFa}
  //矿发信息
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE SpecialControl}
  //春江特殊要求
  {$DEFINE FixLoad}
  //定制放灰
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
   {$DEFINE SaveCusMoneyByOutFact}
   //出厂随车保存可用余额
   {$DEFINE HuaYanAddKindType}
   //化验单增加是否补单类型
   {$DEFINE DaiWCInManual}
   //超发后人工干预后才能出行
   {$DEFINE UseTruckXTNum}
   //启用车辆限提量
{$ENDIF}

//郑州上街
{$IFDEF ZZSJ}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE AutoProId}
  //自动生成供应商编号
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE BFLED}
  //磅房小屏
  {$DEFINE BDAUDIT}
  //补单审核
{$ENDIF}

//辽宁营口
{$IFDEF LNYK}
  {$DEFINE COMMON}
{$ENDIF}

//当阳骨料
{$IFDEF DYGL}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE PrintGLF}
  //打印过路费
  {$DEFINE TruckInNow}
  //开单立即进厂,需要采用厂内排队模式
  {$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE TTCEM100}
  //自动收卡票箱
 {$DEFINE UseBXFontLED}
 //使用出厂小屏展示
{$ENDIF}

//如东海鑫
{$IFDEF RDHX}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
{$ENDIF}

//新安中联
{$IFDEF XAZL}
  {$DEFINE UseERP_K3}
  //使用k3
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE VerifyK3Stock}
  //开单时验证品种
  {$DEFINE MicroMsg}
  //微信支持
  {$DEFINE BlueCard}
  //蓝卡抬杆
{$ENDIF}

//济源中联
{$IFDEF JYZL}
  {$DEFINE UseERP_K3}
  //使用k3
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE VerifyK3Stock}
  //开单时验证品种
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE AppAtTaskBar}
  //状态栏显示
  {$DEFINE PrintBillMoney}
  //打印时显金额
  {$DEFINE HR1847}
  //北京科瑞车检
{$ENDIF}

//红塔骨料
{$IFDEF YNHT_GL}
  {$DEFINE YNHT}
  //标准业务
  {$DEFINE UseMHICCard}
  //制卡时写明华IC卡(骨料用) 
  {$DEFINE UseMHICCard}
  //制卡时写明华IC卡(骨料用) 
{$ENDIF}

//云南红塔
{$IFDEF YNHT}
  {$DEFINE UseERP_K3}
  //使用k3
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE AppAtTaskBar}
  //状态栏显示
  {$DEFINE PrintBillMoney}
  //打印时显金额
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE UseK3SalePlan}
  //K3销售计划
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE PrintHYEach}
  //随车开化验单
  {$DEFINE PrintHeGeZheng}
  {.$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE HeGeZhengSimpleData}
  //使用简单合格证数据(无检验结果)
  {.$DEFINE UseUTFDecode}
  //使用UTF解包函数
  {$DEFINE MicroMsg}
  //使用微信
  {.$DEFINE UseMHICCard}
  //制卡时写明华IC卡(骨料用)
  {$DEFINE TruckAutoIn}
  //自动进厂
  {$DEFINE TTCEM100}
  //自动收卡票箱
{$ENDIF}

//桐乡羔羊
{$IFDEF TXGY}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE SpecialControl}
  //春江特殊要求
  {.$DEFINE FixLoad}
  //定制放灰
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE StockKuWeiEx}
  //物料所属库位
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {$DEFINE IdentCard}
  
  //身份证信息
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
 {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
  {$DEFINE UseXHSpot}
  //卸货地点
{$ENDIF}

//山西东义
{$IFDEF SXDY}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {.$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {.$DEFINE ForceEleCard}
  //强制车辆办理和启用电子标签
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE FixLoad}
  //定制放灰
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {$DEFINE CustomerType}
  //客户分类
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
  {$DEFINE Between2BillTime}
  //同一车两次开单间隔
 {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
  //备份销售单到备用库
  {$DEFINE SendBillToBakDB}
{$ENDIF}

//新乡孟电
{$IFDEF XXMD}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {.$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {.$DEFINE ForceEleCard}
  //强制车辆办理和启用电子标签
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {.$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
  {$DEFINE Between2BillTime}
  //同一车两次开单间隔
 {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
  {$DEFINE SaveCusMoneyByOutFact}
   //出厂随车保存可用余额
  {$DEFINE UseSelectDateTime}
   //启用查询日期包含时分秒
  {$DEFINE UseXHSpot}
  //卸货地点
  {$DEFINE UseYCLHY}
  //使用录入原材料化验记录  
 {$DEFINE TruckAutoIn}
 //车辆自动进厂
 {$DEFINE SendMsgInOutMoney}
 //货款回收发送消息到销售部电脑
 {$DEFINE NoCheckMemo}
 //处理待办事项备注不校验
 {$DEFINE UseWebYYOrder}
 //使用商城预约下单
 {$DEFINE UseOrderNoPrint}
 //原材料出厂不打印磅单
 {$DEFINE UseKuangDian}
 //原材料开单使用矿点
{$ENDIF}

//湘潭恒宇建材
{$IFDEF HYJC}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {$DEFINE CustomerType}
  //客户分类
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
  {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
  {$DEFINE DoubleCheck}
  //采购两次验收
  {$DEFINE NoCheckPound}
  //使用业务员授信
  {$DEFINE UseSalesCredit}
  //备份销售单到备用库
  {$DEFINE SendBillToBakDB}
  //启用袋装不同重量设置
  {$DEFINE ChkPeerWeight}
  //启用ModusBus计数
  {$DEFINE UseModbusJS}
  //纸卡调价时修改已提货单据价格
  {$DEFINE ChangeBillWhenPriceAdjust}
  //补单可以修改补单日期
  {$DEFINE BuDanChangeDate} 
  //补单可以修改补单日期
  {$DEFINE DaiOnceLade} 
  //袋装装车道只允许装一次
{$ENDIF}

//溆浦大盛
{$IFDEF XPDS}
  {.$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
   {$DEFINE HuaYanAddKindType}
   //化验单增加是否补单类型
   {.$DEFINE DaiWCInManual}
   //超发后人工干预后才能出行
  {$DEFINE UseERP_K3}
  //使用k3
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE VerifyK3Stock}
  //开单时验证品种
  {$DEFINE NoSyncPurK3}
  //原材料不同步K3
  {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
  {$DEFINE SendUnLoadPlace}
  //发货卸货地点录入
  {$DEFINE DDChangeOrder}
  //短倒订单可更改
  {$DEFINE WebOrderAutoLoss}
  //申请单自动失效
 {$DEFINE BasisWeightWithPM}
 //库底计量: 定量装车时过皮毛中
 {$DEFINE BasisWeight}
 //库底计量: 定量装车
  {$DEFINE TruckAutoIn}
  //自动进厂
{$ENDIF}

//锦荣骨料高疙瘩，上牛
{$IFDEF JRGL}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {.$DEFINE UseFreight}
  //使用运费
  {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
  {$DEFINE BuDanChangeDate} 
  //补单可以修改补单日期
{$ENDIF}

//焦作中晶
{$IFDEF JZZJ}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE UseCustomerFixMoney}
  //微信订单量限提纸卡做区分

  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {.$DEFINE FixLoad}
  //定制放灰
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {.$DEFINE IdentCard}
  //身份证信息
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
 {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
 {$DEFINE PoundMAfterAutoOutFact}
  //销售单过毛重后自动出厂
 {$DEFINE UseBXFontLED}
  //出厂票箱小屏
  {$DEFINE RemoteSnap}
  //车牌识别
  {$DEFINE LimitedLoadMValueChk}
  //毛重限载检查
  {$DEFINE PoundOpenBackGate}
  //过磅异常倒车下磅
  {$DEFINE HYPrintNum}
  //化验单打印次数	
  {$DEFINE UseJSLogin}
  //计数器登录模块	
  {$DEFINE MoreBeltLine}
  //销售不同生产线或厂区批次编号不同
  {$DEFINE ShowSelfData}
  //化验室数据只显示个人数据
  {$DEFINE UseOPCMode}
  //计数器OPC通信
  {.$DEFINE ZJModBusTCPJSQ}
  //ModBusTCP计数器
  {$DEFINE JSQUseMITService}
  //计数器与MIT交互
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE XTaskThread}
  //定时任务线程
  {$DEFINE SanOutTimeFHTruck}
  //定时扫码放灰超时车辆
  {$DEFINE AllowUnsettlement}
  //发票允许之前周期未结算
  {$DEFINE NotZZCombine}
  //发票不做之前周期结算合并
  {$DEFINE SRecordNeedDistinguish}
  //化验批次编号需要每年区分
  {$DEFINE TruckAutoIn}
  //磅房自动进厂
  {$DEFINE ShowHYAVG}
  //化验室检验记录显示抗折、抗压平均值
  {$DEFINE FPAllowEditPrice}
  //开发票允许调整单价
{$ENDIF}

//辉县太阳石
{$IFDEF HXTYS}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE UseCustomerFixMoney}
  //微信订单量限提纸卡做区分

  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {.$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {.$DEFINE FixLoad}
  //定制放灰
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {.$DEFINE IdentCard}
  //身份证信息
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
 {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
 {.$DEFINE PoundMAfterAutoOutFact}
  //销售单过毛重后自动出厂
 {$DEFINE UseBXFontLED}
  //出厂票箱小屏
  {.$DEFINE RemoteSnap}
  //车牌识别
  {.$DEFINE PoundOpenBackGate}
  //过磅异常倒车下磅
  {$DEFINE HYPrintNum}
  //化验单打印次数	
  {.$DEFINE UseJSLogin}
  //计数器登录模块	
  {$DEFINE JSQUseMITService}
  //计数器与MIT交互
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE ScanTimingTask}
  //定时调价
  {$DEFINE SRecordNeedDistinguish}
  //化验批次编号需要每年区分
  {$DEFINE TruckAutoIn}
  //磅房自动进厂
  {$DEFINE BasisWeight}
  //启用定量装车
  {.$DEFINE BasisWeightWithPM}
  //库底计量: 定量装车时过皮毛中
  {$DEFINE SaveBillStatusFH}
  //更新车辆为放灰状态
  {$DEFINE MValueAddPersonWeight}
  //车辆过毛重时补增毛重
  {$DEFINE AutoEmptyOutChk}
  //自动称重空车出
  {$DEFINE BuDanChangeDate} 
  //补单可指定日期
  {$DEFINE BehalfConsignor} 
  //代发货打印不同厂票据
  {$DEFINE DaiPrintBillRt} 
  //袋装取卡打印入厂小票
  {.$DEFINE StockSerialNo} 
  //原料根据物料号生成订单编号
  {$DEFINE PayMentZhika} 
  //缴款充值纸卡
  {$DEFINE BatCodeAddYMD} 
  //喷码添加年月日
  {$DEFINE ShouJuAddMID} 
  //缴款关联收据
  {$DEFINE JoinShouJuInfo} 
  //收款关联收据信息
  {$DEFINE FixMoneyAddCredit} 
  //现金限提纸卡可用授信额度
  {$DEFINE BuDanPValue} 
  //补单检查皮重
  {$DEFINE PurYSAfterAutoPoundP} 
  //验收后对设置预置皮重订单，自动做重量结算
  {.$DEFINE SalePlanCheck} 
  //销售限量计划控制
  {$DEFINE APPUseBluetoothPrint} 
  //手持程序支持蓝牙打印（xPrinter）
  {$DEFINE YSAddMemo} 
  //验收加备注
  {$DEFINE PurHYNoUseEncode} 
  //原料质检组批后不用加密
  {$DEFINE AICMPrint28HYDan} 
  //自助机打印28天化验单
  {$DEFINE BillAutoPoundPUPDatePrice} 
  //销售过皮重，检查更新订单价格
{$ENDIF}

//辉县振新
{$IFDEF HXZX}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE UseCustomerFixMoney}
  //微信订单量限提纸卡做区分

  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {.$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE FixLoad}
  //定制放灰 转子秤
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {$DEFINE AllowMultiM}
  //允许多次过重车
  {.$DEFINE IdentCard}
  //身份证信息
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
 {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
 {.$DEFINE PoundMAfterAutoOutFact}
  //销售单过毛重后自动出厂
 {$DEFINE UseBXFontLED}
  //出厂票箱小屏
  {.$DEFINE RemoteSnap}
  //车牌识别
  {.$DEFINE PoundOpenBackGate}
  //过磅异常倒车下磅
  {$DEFINE HYPrintNum}
  //化验单打印次数	
  {.$DEFINE UseJSLogin}
  //计数器登录模块	
  {.$DEFINE MoreBeltLine}
  //销售不同生产线或厂区批次编号不同
  {.$DEFINE ShowSelfData}
  //化验室数据只显示个人数据
  {.$DEFINE UseOPCMode}
  //计数器OPC通信
  {.$DEFINE ZJModBusTCPJSQ}
  //ModBusTCP计数器
  {$DEFINE JSQUseMITService}
  //计数器与MIT交互
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE ScanTimingTask}
  //定时调价
  {$DEFINE SRecordNeedDistinguish}
  //化验批次编号需要每年区分
  {$DEFINE TruckAutoIn}
  //磅房自动进厂
  {$DEFINE BasisWeight}
  //启用定量装车
  {.$DEFINE BasisWeightWithPM}
  //库底计量: 定量装车时过皮毛中
  {$DEFINE SaveBillStatusFH}
  //更新车辆为放灰状态
  {$DEFINE MValueAddPersonWeight}
  //车辆过毛重时补增毛重
  {$DEFINE AutoEmptyOutChk}
  //自动称重空车出
  {$DEFINE BuDanChangeDate} 
  //补单可指定日期
  {$DEFINE BehalfConsignor} 
  //代发货打印不同厂票据
  {$DEFINE DaiPrintBillRt} 
  //袋装取卡打印入厂小票
  {$DEFINE HYRecordNoAutoFill} 
  //化验数据不自动填充
  {$DEFINE PayMentZhika} 
  //缴款充值纸卡
  {$DEFINE BatCodeAddYMD} 
  //喷码添加年月日
  {$DEFINE ShouJuAddMID} 
  //缴款关联收据
  {$DEFINE SalePlanCheck} 
  //销售限量计划控制
  {$DEFINE YSAddMemo} 
  //验收加备注
  {$DEFINE AICMPrint28HYDan} 
  //自助机打印28天化验单
  {$DEFINE HasDaiWCNoOpenGate} 
  //袋装误差不抬杆
  {$DEFINE JoinShouJuInfo} 
  //收款关联收据信息
  {$DEFINE SalePlanCheckByMoney} 
  //收款关联收据信息
{$ENDIF}

//曲靖雄业水泥
{$IFDEF QJXY}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE TTCEM100}
  //自动收卡票箱
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE SaveHyDanEvent}
  //生成推送化验单事件
  {$DEFINE WxShowCusMoney}
  //微信端显示客户金额
  {$DEFINE CastMoney}
  //对吨位及金额小数位后2位四舍五入
  {$DEFINE NoCheckOrderValue}
  //自助机原材料开卡不检查订单剩余量
  {$DEFINE ProberShow}
  //车检发送小屏
  {$DEFINE OrderNoMulCard}
  //采购禁止一车多单
  {$DEFINE CapturePictureEx}
  //磅房抓拍模式扩展
  {$DEFINE BusinessOnly}
  //车辆同一时间只能进行1种业务
  {$DEFINE ForceMemo}
  //强制输入备注
  {$DEFINE InfoOnly}
  //档案信息唯一
  {$DEFINE AlwaysUseDate}
  //报表查询始终使用日期条件
  {.$DEFINE AllowMultiM}
  //允许多次过重车
  {$DEFINE CustomerType}
  //客户分类
  {$DEFINE ChangeBillWhenPriceAdjust}
  //纸卡调价时修改已提货单据价格
  {$DEFINE UseFreight}
  //使用运费
  {$DEFINE UseWXServiceEx}
  //使用二期微信中间件
  {.$DEFINE DoubleCheck}
  //采购两次验收
  {.$DEFINE NoCheckPound}
  //使用业务员授信
  {.$DEFINE UseSalesCredit}
  //备份销售单到备用库
  {.$DEFINE SendBillToBakDB}
  //启用袋装不同重量设置
  {.$DEFINE ChkPeerWeight}
  //纸卡调价时修改已提货单据价格
  {$DEFINE ChangeBillWhenPriceAdjust}
  //补单可以修改补单日期
  {$DEFINE BuDanChangeDate} 
  //补单可以修改补单日期
  {.$DEFINE DaiOnceLade} 
  //袋装装车道只允许装一次
  {$DEFINE UseELabel} 
  //电子标签办临时卡
  {$DEFINE UseBXFontLED} 
  //电子标签办临时卡
  {.$DEFINE EnableAlivision}
  {.$DEFINE AlivisionInClient}
  //启用阿里图像识别
  {$DEFINE DiffCusTypeForBillNo}
  //不同客户采用不同单据编号
  {$DEFINE GetBatCodeByTunnel}
  //根据通道获取批次号
{$ENDIF}