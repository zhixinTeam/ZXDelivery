{*******************************************************************************
  作者: dmzn@163.com 2018-04-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可
*******************************************************************************}
unit USysModule;

interface

uses
  UClientWorker, UClientPacker, UFormChangePwd, UFormOptions, UFormExit,
  UFrameCustomer, UFormCustomer, UFrameContract, UFormContract, UFormDateFilter,
  UFrameZhiKa, UFormZhiKa, UFrameZhiKaDetail, UFormZhiKaFreeze, UFormZhiKaPrice,
  UFormZhiKaFixMoney, UFormGetContract, UFrameCustomerCredit, UFormCreditDetail,
  UFormCustomerCredit, UFramePayment, UFormPayment, UFrameSalesMan,
  UFormSalesMan, UFormSysLog,
//--------------------------------- report -------------------------------------
  UFrameBill, UFrameQueryDiapatch, UFrameTruckQuery, UFrameCusAccount,
  UFrameCusInOutMoney, UFrameQuerySaleDetail, UFrameQuerySaleTotal,
  UFrameOrderDetail;

implementation

end.
