class SaleOrder {
  final iSaleOrderID;
  final iSystemUserID;
  final iFirmID;
  final iPermanentCustomerID;
  final sAddress;
  final dcTotalBill;
  final dcGrandTotal;
  final dcOnProuctDiscount;
  final dcExtraDiscount;
  final dcTotalDiscount;
  final sTotalBonus;
  final sTotal_Item;
  final sSaleType;
  final sSaleDescription;
  final bStatus;
  final sNoficationStatus;
  final sReadStatus;
  final sSyncStatus;
  final sEntrySource;
  final sAction;
  final dSaleOrderDate;
  final dtDueDate;
  final dtCreatedDate;
  final iAddedBy;
  final dtUpdatedDate;
  final iUpdatedBy;
  final dtDeletedDate;
  final iDeletedBy;
  final iStoreID;

  SaleOrder({
    required this.iSaleOrderID,
    this.iSystemUserID,
    this.iFirmID,
    this.iPermanentCustomerID,
    this.sAddress,
    this.dcTotalBill,
    this.dcGrandTotal,
    this.dcOnProuctDiscount,
    this.dcExtraDiscount,
    this.dcTotalDiscount,
    this.sTotalBonus,
    this.sTotal_Item,
    this.sSaleType,
    this.sSaleDescription,
    this.bStatus,
    this.sNoficationStatus,
    this.sReadStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.dSaleOrderDate,
    this.dtDueDate,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
    this.iStoreID,
  });

  factory SaleOrder.fromMap(Map<String, dynamic> map) {
    return SaleOrder(
      iSaleOrderID: map['iSaleOrderID'],
      iSystemUserID: map['iSystemUserID'],
      iFirmID: map['iFirmID'],
      iPermanentCustomerID: map['iPermanentCustomerID'],
      sAddress: map['sAddress'],
      dcTotalBill: map['dcTotalBill'],
      dcGrandTotal: map['dcGrandTotal'],
      dcOnProuctDiscount: map['dcOnProuctDiscount'],
      dcExtraDiscount: map['dcExtraDiscount'],
      dcTotalDiscount: map['dcTotalDiscount'],
      sTotalBonus: map['sTotalBonus'],
      sTotal_Item: map['sTotal_Item'],
      sSaleType: map['sSaleType'],
      sSaleDescription: map['sSaleDescription'],
      bStatus: map['bStatus'],
      sNoficationStatus: map['sNoficationStatus'],
      sReadStatus: map['sReadStatus'],
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      sAction: map['sAction'],
      dSaleOrderDate: map['dSaleOrderDate'],
      dtDueDate: map['dtDueDate'],
      dtCreatedDate: map['dtCreatedDate'],
      iAddedBy: map['iAddedBy'],
      dtUpdatedDate: map['dtUpdatedDate'],
      iUpdatedBy: map['iUpdatedBy'],
      dtDeletedDate: map['dtDeletedDate'],
      iDeletedBy: map['iDeletedBy'],
      iStoreID: map['iStoreID'],
    );
  }
}

class PermanentCustomer {
  final iPermanentCustomerID;
  final iSystemUserID;
  final iAreaID;
  final iFirmID;
  final sName;
  final sShopName;
  final sEmail;
  final sCode;
  final sAddress;
  final sPhone;
  final sMobile;
  final sDescription;
  final dcDefaultAmount;
  final dcPreviousAmount;
  final dcTotalRemainingAmount;
  final bStatus;
  final sSyncStatus;
  final sEntrySource;
  final sAction;
  final sType;
  final dtCreatedDate;
  final iAddedBy;
  final dtUpdatedDate;
  final iUpdatedBy;
  final dtDeletedDate;
  final iDeletedBy;

  PermanentCustomer({
    required this.iPermanentCustomerID,
    this.iSystemUserID,
    this.iAreaID,
    this.iFirmID,
    required this.sName,
    this.sShopName,
    this.sEmail,
    this.sCode,
    this.sAddress,
    this.sPhone,
    this.sMobile,
    this.sDescription,
    this.dcDefaultAmount,
    this.dcPreviousAmount,
    this.dcTotalRemainingAmount,
    this.bStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.sType,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
  });
}

class SaleWithCustomer {
  final SaleOrder sale;
  final PermanentCustomer? customer;

  SaleWithCustomer({
    required this.sale,
    this.customer,
  });
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
}

class Product {
  final int iProductID;
  final int iSystemUserID;
  final int iFirmID;
  final int isProductCompanyID;
  final int isProductGroupID;
  final int isTaxcodeID;
  final int isExtraChargesID;
  final String sProductName;
  final String sProductLocation;
  final String sCode;
  final String sBarCode;
  final int iBaseUnit;
  final int iSecondaryUnit;
  final String sPeacePerSize;
  final String sTotalPeace;
  final String sTotalUnitSize;
  final String sWhatSecUnitIs;
  final double dcPurcasePerBaseUnitPrice;
  final double dcPurchasePerSecondaryUnitPrice;
  final double dcDellerSalePerBaseUnitPrice;
  final double dcDellerSalePerSecondaryUnitPrice;
  final double dcSalePerBaseUnitPrice;
  final String dSalePerSecondaryUnitPrice;
  final String sProduct_image;
  final String sImage_Thumbnail;
  final String sOpeningStockBaseUnit;
  final String sOpeningStockSecondaryUnit;
  final String sOpeningStockPurchase_At;
  final String sTotalBaseUnitStockQty;
  final String sTotalSecondaryUnitStockQty;
  final String sTotalBaseUnitPurchaseValue;
  final String sTotalSecondaryUnitPurchaseValue;
  final String sProducttype;
  final String sBaseUnitProfitRatio;
  final String sSecoundaryUnitProfitRatio;
  final String sTotalBaseUnitAvgPP;
  final String sTotalSecUnitAvgPP;
  final String sBonusRecivedStockInBaseUnit;
  final String sBonusRecivedStockInSecondaryUnit;
  final String sTotalBonusGivenStockOutInBaseUnit;
  final String sTotalBonusGivenStockOutInSecUnit;
  final String sTotalStockWithBonusInBaseUnitQty;
  final String sTotalStockWithBonusInSecUnitQty;
  final bool bStatus;
  final String sSyncStatus;
  final String sEntrySource;
  final String sAction;
  final String dtCreatedDate;
  final int iAddedBy;
  final String dtUpdatedDate;
  final int iUpdatedBy;
  final String dtDeletedDate;
  final int iDeletedBy;

  Product({
    required this.iProductID,
    required this.iSystemUserID,
    required this.iFirmID,
    required this.isProductCompanyID,
    required this.isProductGroupID,
    required this.isTaxcodeID,
    required this.isExtraChargesID,
    required this.sProductName,
    required this.sProductLocation,
    required this.sCode,
    required this.sBarCode,
    required this.iBaseUnit,
    required this.iSecondaryUnit,
    required this.sPeacePerSize,
    required this.sTotalPeace,
    required this.sTotalUnitSize,
    required this.sWhatSecUnitIs,
    required this.dcPurcasePerBaseUnitPrice,
    required this.dcPurchasePerSecondaryUnitPrice,
    required this.dcDellerSalePerBaseUnitPrice,
    required this.dcDellerSalePerSecondaryUnitPrice,
    required this.dcSalePerBaseUnitPrice,
    required this.dSalePerSecondaryUnitPrice,
    required this.sProduct_image,
    required this.sImage_Thumbnail,
    required this.sOpeningStockBaseUnit,
    required this.sOpeningStockSecondaryUnit,
    required this.sOpeningStockPurchase_At,
    required this.sTotalBaseUnitStockQty,
    required this.sTotalSecondaryUnitStockQty,
    required this.sTotalBaseUnitPurchaseValue,
    required this.sTotalSecondaryUnitPurchaseValue,
    required this.sProducttype,
    required this.sBaseUnitProfitRatio,
    required this.sSecoundaryUnitProfitRatio,
    required this.sTotalBaseUnitAvgPP,
    required this.sTotalSecUnitAvgPP,
    required this.sBonusRecivedStockInBaseUnit,
    required this.sBonusRecivedStockInSecondaryUnit,
    required this.sTotalBonusGivenStockOutInBaseUnit,
    required this.sTotalBonusGivenStockOutInSecUnit,
    required this.sTotalStockWithBonusInBaseUnitQty,
    required this.sTotalStockWithBonusInSecUnitQty,
    required this.bStatus,
    required this.sSyncStatus,
    required this.sEntrySource,
    required this.sAction,
    required this.dtCreatedDate,
    required this.iAddedBy,
    required this.dtUpdatedDate,
    required this.iUpdatedBy,
    required this.dtDeletedDate,
    required this.iDeletedBy,
  });
}

class ProductUnit {
  final int iItemUnitID;
  final int iFirmID;
  final String sUnitName;
  final String sUnitShortName;
  final String sActive;
  final bool bStatus;
  final String sSyncStatus;
  final String sEntrySource;
  final String sAction;
  final String dtCreatedDate;
  final int iAddedBy;
  final String dtUpdatedDate;
  final int iUpdatedBy;
  final String dtDeletedDate;
  final int iDeletedBy;

  ProductUnit({
    required this.iItemUnitID,
    required this.iFirmID,
    required this.sUnitName,
    required this.sUnitShortName,
    required this.sActive,
    required this.bStatus,
    required this.sSyncStatus,
    required this.sEntrySource,
    required this.sAction,
    required this.dtCreatedDate,
    required this.iAddedBy,
    required this.dtUpdatedDate,
    required this.iUpdatedBy,
    required this.dtDeletedDate,
    required this.iDeletedBy,
  });
}
