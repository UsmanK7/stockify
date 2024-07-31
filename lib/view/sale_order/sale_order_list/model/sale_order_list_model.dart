class SaleOrderListModel {
  final saleId;
  final invoice_price;
  final customer_Name;
  final total_discount;
  final sale_date;

  final sSyncStatus;

  SaleOrderListModel(
      {required this.invoice_price,
      required this.saleId,
      required this.customer_Name,
      required this.sale_date,
      required this.sSyncStatus,
      required this.total_discount});
}

class SaleOrderProduct {
  final iSaleOrderProductID;
  final iSaleOrderID;
  final iProductID;
  final iSystemUserID;
  final iFirmID;
  final sSaleQtyInBaseUnit;
  final sSaleQtyInSecUnit;
  final sSaleBonusInBaseUnit;
  final sSaleBonusInSecUnit;
  final sSaleTotalInBaseUnitQty;
  final sSaleTotalInSecUnitQty;
  final dcSalePricePerBaseUnit;
  final dcSalePriceSecUnit;
  final iPermanentCustomerID;
  final dcToalSalePriceInBaseUnit;
  final dcToalSalePriceInSecUnit;
  final dcPurchaseValuePricePerBaseUnit;
  final dcPurchaseValuePerSecUnit;
  final dcProfitValuePricePerBaeUnit;
  final dcProfitValuePerSecUnit;
  final dcTotalProductSaleProfit;
  final iTaxCodeID;
  final dcSaleTax;
  final sDiscountInPercentage;
  final dcDiscountInAmount;
  final dcExtraDiscount;
  final dcTotalDiscountInVal;
  final iExtra_Charges_ID;
  final sExtraChargesAmount;
  final dSaleDate;
  final sCustomerInvoiceNo;
  final sSaleStatus;
  final sSaleType;
  final sClaim;
  final sSyncStatus;
  final sEntrySource;
  final bStatus;
  final sAction;
  final dtCreatedDate;
  final iAddedBy;
  final dtUpdatedDate;
  final iUpdatedBy;
  final dtDeletedDate;
  final iDeletedBy;
  final sCartonQty;
  final sPacking;

  SaleOrderProduct({
    required this.iSaleOrderProductID,
    this.iSaleOrderID,
    this.iProductID,
    this.iSystemUserID,
    this.iFirmID,
    this.sSaleQtyInBaseUnit,
    this.sSaleQtyInSecUnit,
    this.sSaleBonusInBaseUnit,
    this.sSaleBonusInSecUnit,
    this.sSaleTotalInBaseUnitQty,
    this.sSaleTotalInSecUnitQty,
    this.dcSalePricePerBaseUnit,
    this.dcSalePriceSecUnit,
    this.iPermanentCustomerID,
    this.dcToalSalePriceInBaseUnit,
    this.dcToalSalePriceInSecUnit,
    this.dcPurchaseValuePricePerBaseUnit,
    this.dcPurchaseValuePerSecUnit,
    this.dcProfitValuePricePerBaeUnit,
    this.dcProfitValuePerSecUnit,
    this.dcTotalProductSaleProfit,
    this.iTaxCodeID,
    this.dcSaleTax,
    this.sDiscountInPercentage,
    this.dcDiscountInAmount,
    this.dcExtraDiscount,
    this.dcTotalDiscountInVal,
    this.iExtra_Charges_ID,
    this.sExtraChargesAmount,
    this.dSaleDate,
    this.sCustomerInvoiceNo,
    this.sSaleStatus,
    this.sSaleType,
    this.sClaim,
    this.sSyncStatus,
    this.sEntrySource,
    this.bStatus,
    this.sAction,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
    this.sCartonQty,
    this.sPacking,
  });

  factory SaleOrderProduct.fromMap(Map<String, dynamic> map) {
    return SaleOrderProduct(
      iSaleOrderProductID: map['iSaleOrderProductID'],
      iSaleOrderID: map['iSaleOrderID'],
      iProductID: map['iProductID'],
      iSystemUserID: map['iSystemUserID'],
      iFirmID: map['iFirmID'],
      sSaleQtyInBaseUnit: map['sSaleQtyInBaseUnit'],
      sSaleQtyInSecUnit: map['sSaleQtyInSecUnit'],
      sSaleBonusInBaseUnit: map['sSaleBonusInBaseUnit'],
      sSaleBonusInSecUnit: map['sSaleBonusInSecUnit'],
      sSaleTotalInBaseUnitQty: map['sSaleTotalInBaseUnitQty'],
      sSaleTotalInSecUnitQty: map['sSaleTotalInSecUnitQty'],
      dcSalePricePerBaseUnit: map['dcSalePricePerBaseUnit'],
      dcSalePriceSecUnit: map['dcSalePriceSecUnit'],
      iPermanentCustomerID: map['iPermanentCustomerID'],
      dcToalSalePriceInBaseUnit: map['dcToalSalePriceInBaseUnit'],
      dcToalSalePriceInSecUnit: map['dcToalSalePriceInSecUnit'],
      dcPurchaseValuePricePerBaseUnit: map['dcPurchaseValuePricePerBaseUnit'],
      dcPurchaseValuePerSecUnit: map['dcPurchaseValuePerSecUnit'],
      dcProfitValuePricePerBaeUnit: map['dcProfitValuePricePerBaeUnit'],
      dcProfitValuePerSecUnit: map['dcProfitValuePerSecUnit'],
      dcTotalProductSaleProfit: map['dcTotalProductSaleProfit'],
      iTaxCodeID: map['iTaxCodeID'],
      dcSaleTax: map['dcSaleTax'],
      sDiscountInPercentage: map['sDiscountInPercentage'],
      dcDiscountInAmount: map['dcDiscountInAmount'],
      dcExtraDiscount: map['dcExtraDiscount'],
      dcTotalDiscountInVal: map['dcTotalDiscountInVal'],
      iExtra_Charges_ID: map['iExtra_Charges_ID'],
      sExtraChargesAmount: map['sExtraChargesAmount'],
      dSaleDate: map['dSaleDate'],
      sCustomerInvoiceNo: map['sCustomerInvoiceNo'],
      sSaleStatus: map['sSaleStatus'],
      sSaleType: map['sSaleType'],
      sClaim: map['sClaim'],
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      bStatus: map['bStatus'],
      sAction: map['sAction'],
      dtCreatedDate: map['dtCreatedDate'],
      iAddedBy: map['iAddedBy'],
      dtUpdatedDate: map['dtUpdatedDate'],
      iUpdatedBy: map['iUpdatedBy'],
      dtDeletedDate: map['dtDeletedDate'],
      iDeletedBy: map['iDeletedBy'],
      sCartonQty: map['sCartonQty'],
      sPacking: map['sPacking'],
    );
  }
}
