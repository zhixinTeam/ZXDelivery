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

{$DEFINE XPDS}
//特定系统

//山西声威
{$IFDEF SXSW}
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
  {.$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE SanPreHK}
  //散装开单时预合卡
  {.$DEFINE AutoPoundInManual}
  //自动称重人工干预异常
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {.$DEFINE NoShowPriceChange}
  //不显示价格调整提示
  {.$DEFINE NoCheckOnPayment}
  //退款时不校验资金余额
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE UseCustomertMoney}
  //订单量使用客户余额计算
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE UseUTFDecode}
  //使用UTF解包函数
{$ENDIF}

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
  {$DEFINE UseMHICCard}
  //制卡时写明华IC卡(骨料用)
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

//广西北流
{$IFDEF GXBL}
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
  {.$DEFINE Between2BillTime}
  //同一车两次开单间隔
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
{$ENDIF}
