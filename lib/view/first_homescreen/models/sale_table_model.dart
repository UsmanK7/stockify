class SaleTableModel {
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

  SaleTableModel({
    this.iSaleID,
    this.iSystemUserID,
    this.iFirmID,
    this.iPermanentCustomerID,
    this.iEmployeeID,
    this.sCustomerName,
    this.sCustomerFatherName,
    this.sCustomerInvoiceNo,
    this.sMobileNo,
    this.sCustomerCNIC,
    this.sAddress,
    this.dcTotalBill,
    this.dcGrandTotal,
    this.dcPaidBillAmount,
    this.iBankIDPaidAmount,
    this.dcOnProductDiscount,
    this.dcExtraDiscount,
    this.dcTotalDiscount,
    this.dcSaleExpense,
    this.iBankIDExpensAmount,
    this.sTotalBonus,
    this.sTotalItem,
    this.sPaymentStatus,
    required this.dcSaleProfit,
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

  Map<String, dynamic> toMap() {
    return {
      'iSaleID': iSaleID,
      'iSystemUserID': iSystemUserID,
      'iFirmID': iFirmID,
      'iPermanentCustomerID': iPermanentCustomerID,
      'iEmployeeID': iEmployeeID,
      'sCustomerName': sCustomerName,
      'sCustomerFatherName': sCustomerFatherName,
      'sCustomerInvoiceNo': sCustomerInvoiceNo,
      'sMobileNo': sMobileNo,
      'sCustomerCNIC': sCustomerCNIC,
      'sAddress': sAddress,
      'dcTotalBill': dcTotalBill,
      'dcGrandTotal': dcGrandTotal,
      'dcPaidBillAmount': dcPaidBillAmount,
      'iBankIDPaidAmount': iBankIDPaidAmount,
      'dcOnProductDiscount': dcOnProductDiscount,
      'dcExtraDiscount': dcExtraDiscount,
      'dcTotalDiscount': dcTotalDiscount,
      'dcSaleExpense': dcSaleExpense,
      'iBankIDExpensAmount': iBankIDExpensAmount,
      'sTotalBonus': sTotalBonus,
      'sTotalItem': sTotalItem,
      'sPaymentStatus': sPaymentStatus,
      'dcSaleProfit': dcSaleProfit,
      'dcExtraProfit': dcExtraProfit,
      'sSaleType': sSaleType,
      'sSaleDescription': sSaleDescription,
      'bStatus': bStatus,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dSaleDate': dSaleDate,
      'dtDueDate': dtDueDate,
      'dtCreatedDate': dtCreatedDate,
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate,
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate,
      'iDeletedBy': iDeletedBy,
    };
  }

  factory SaleTableModel.fromMap(Map<String, dynamic> map) {
    return SaleTableModel(
      iSaleID: map['iSaleID'],
      iSystemUserID: map['iSystemUserID'],
      iFirmID: map['iFirmID'],
      iPermanentCustomerID: map['iPermanentCustomerID'],
      iEmployeeID: map['iEmployeeID'],
      sCustomerName: map['sCustomerName'],
      sCustomerFatherName: map['sCustomerFatherName'],
      sCustomerInvoiceNo: map['sCustomerInvoiceNo'],
      sMobileNo: map['sMobileNo'],
      sCustomerCNIC: map['sCustomerCNIC'],
      sAddress: map['sAddress'],
      dcTotalBill: map['dcTotalBill'],
      dcGrandTotal: map['dcGrandTotal'],
      dcPaidBillAmount: map['dcPaidBillAmount'],
      iBankIDPaidAmount: map['iBankIDPaidAmount'],
      dcOnProductDiscount: map['dcOnProductDiscount'],
      dcExtraDiscount: map['dcExtraDiscount'],
      dcTotalDiscount: map['dcTotalDiscount'],
      dcSaleExpense: map['dcSaleExpense'],
      iBankIDExpensAmount: map['iBankIDExpensAmount'],
      sTotalBonus: map['sTotalBonus'],
      sTotalItem: map['sTotalItem'],
      sPaymentStatus: map['sPaymentStatus'],
      dcSaleProfit: map['dcSaleProfit'],
      dcExtraProfit: map['dcExtraProfit'],
      sSaleType: map['sSaleType'],
      sSaleDescription: map['sSaleDescription'],
      bStatus: map['bStatus'],
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      sAction: map['sAction'],
      dSaleDate: map['dSaleDate'],
      dtDueDate: map['dtDueDate'],
      dtCreatedDate: map['dtCreatedDate'],
      iAddedBy: map['iAddedBy'],
      dtUpdatedDate: map['dtUpdatedDate'],
      iUpdatedBy: map['iUpdatedBy'],
      dtDeletedDate: map['dtDeletedDate'],
      iDeletedBy: map['iDeletedBy'],
    );
  }
}
