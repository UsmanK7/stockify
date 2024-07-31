class Sale {
  final iSaleID;
  final iSystemUserID;
  final iFirmID;
  final iPermanentCustomerID;
  final iEmployeeID;
  final sCustomerName;
  final sCustomerFatherName;
  final sCustomerInvoiceNo;
  final sMobileNo;
  final sCustomerCNIC;
  final sAddress;
  final dcTotalBill;
  final dcGrandTotal;
  final dcPaidBillAmount;
  final iBankIDPaidAmount;
  final dcOnProductDiscount;
  final dcExtraDiscount;
  final dcTotalDiscount;
  final dcSaleExpense;
  final iBankIDExpensAmount;
  final sTotalBonus;
  final sTotalItem;
  final sPaymentStatus;
  final dcSaleProfit;
  final dcExtraProfit;
  final sSaleType;
  final sSaleDescription;
  final bStatus;
  final sSyncStatus;
  final sEntrySource;
  final sAction;
  final dSaleDate;
  final dtDueDate;
  final dtCreatedDate;
  final iAddedBy;
  final dtUpdatedDate;
  final iUpdatedBy;
  final dtDeletedDate;
  final iDeletedBy;

  Sale({
    required this.iSaleID,
    this.iSystemUserID,
    this.iFirmID,
    this.iPermanentCustomerID,
    this.iEmployeeID = 1,
    this.sCustomerName,
    this.sCustomerFatherName,
    this.sCustomerInvoiceNo,
    this.sMobileNo,
    this.sCustomerCNIC,
    this.sAddress,
    this.dcTotalBill,
    this.dcGrandTotal,
    this.dcPaidBillAmount = 0.0,
    this.iBankIDPaidAmount,
    this.dcOnProductDiscount,
    this.dcExtraDiscount,
    this.dcTotalDiscount,
    this.dcSaleExpense,
    this.iBankIDExpensAmount,
    this.sTotalBonus,
    this.sTotalItem,
    this.sPaymentStatus,
    this.dcSaleProfit = 0.0,
    this.dcExtraProfit,
    this.sSaleType,
    this.sSaleDescription,
    this.bStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.dSaleDate,
    this.dtDueDate,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
  });
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
  final Sale sale;
  final PermanentCustomer? customer;

  SaleWithCustomer({
    required this.sale,
    this.customer,
  });
}

class SaleProduct {
  final int iSaleProductID;
  final int iSaleID;
  final int iProductID;
  final int iSystemUserID;
  final int iFirmID;
  final int iEmployeeID;
  final String sSaleQtyInBaseUnit;
  final String sSaleQtyInSecUnit;
  final String sSaleBonusInBaseUnit;
  final String sSaleBonusInSecUnit;
  final String sSaleTotalInBaseUnitQty;
  final String sSaleTotalInSecUnitQty;
  final double dcSalePricePerBaseUnit;
  final double dcSalePriceSecUnit;
  final int iPermanentCustomerID;
  final double dcToalSalePriceInBaseUnit;
  final double dcToalSalePriceInSecUnit;
  final double dcPurchaseValuePricePerBaseUnit;
  final double dcPurchaseValuePerSecUnit;
  final double dcProfitValuePricePerBaeUnit;
  final double dcProfitValuePerSecUnit;
  final double dcTotalProductSaleProfit;
  final int iTaxCodeID;
  final double dcSaleTax;
  final String sDiscountInPercentage;
  final double dcDiscountInAmount;
  final double dcExtraDiscount;
  final double dcTotalDiscountInVal;
  final int iExtra_Charges_ID;
  final String sExtraChargesAmount;
  final String dSaleDate;
  final String sCustomerInvoiceNo;
  final String sSaleStatus;
  final String sSaleType;
  final String sClaim;
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

  SaleProduct({
    required this.iSaleProductID,
    required this.iSaleID,
    required this.iProductID,
    required this.iSystemUserID,
    required this.iFirmID,
    required this.iEmployeeID,
    required this.sSaleQtyInBaseUnit,
    required this.sSaleQtyInSecUnit,
    required this.sSaleBonusInBaseUnit,
    required this.sSaleBonusInSecUnit,
    required this.sSaleTotalInBaseUnitQty,
    required this.sSaleTotalInSecUnitQty,
    required this.dcSalePricePerBaseUnit,
    required this.dcSalePriceSecUnit,
    required this.iPermanentCustomerID,
    required this.dcToalSalePriceInBaseUnit,
    required this.dcToalSalePriceInSecUnit,
    required this.dcPurchaseValuePricePerBaseUnit,
    required this.dcPurchaseValuePerSecUnit,
    required this.dcProfitValuePricePerBaeUnit,
    required this.dcProfitValuePerSecUnit,
    required this.dcTotalProductSaleProfit,
    required this.iTaxCodeID,
    required this.dcSaleTax,
    required this.sDiscountInPercentage,
    required this.dcDiscountInAmount,
    required this.dcExtraDiscount,
    required this.dcTotalDiscountInVal,
    required this.iExtra_Charges_ID,
    required this.sExtraChargesAmount,
    required this.dSaleDate,
    required this.sCustomerInvoiceNo,
    required this.sSaleStatus,
    required this.sSaleType,
    required this.sClaim,
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
