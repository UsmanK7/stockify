class DailyExpense {
  final iDailyExpenseID;
  final iExpenseTypeID;
  final iBankID;
  final iTableID;
  final sTableName;
  final sExpenseFor;
  final sVocherNo;
  final sVocherScanImagePath;
  final dcAmount;
  final sDescription;
  final iFirmID;
  final iSystemUserID;
  final dDate;
  final sEtc;
  final bStatus;
  final sSyncStatus;
  final sEntrySource;
  final sAction;
  final dtCreatedDate;
  final iAddedBy;
  final dtUpdatedDate;
  final iUpdatedBy;
  final dtDeletedDate;
  final iDeletedBy;
  final iStoreID;
  final transaction_id;

  DailyExpense({
    required this.iDailyExpenseID,
    this.iExpenseTypeID,
    this.iBankID,
    this.iTableID,
    this.sTableName,
    this.sExpenseFor,
    this.sVocherNo,
    this.sVocherScanImagePath,
    this.dcAmount,
    this.sDescription,
    this.iFirmID,
    this.iSystemUserID,
    this.dDate,
    this.sEtc,
    this.bStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
    this.iStoreID,
    this.transaction_id,
  });

  // From JSON
  factory DailyExpense.fromJson(Map<String, dynamic> json) {
    return DailyExpense(
      iDailyExpenseID: json['iDailyExpenseID'],
      iExpenseTypeID: json['iExpenseTypeID'],
      iBankID: json['iBankID'],
      iTableID: json['iTableID'],
      sTableName: json['sTableName'],
      sExpenseFor: json['sExpenseFor'],
      sVocherNo: json['sVocherNo'],
      sVocherScanImagePath: json['sVocherScanImagePath'],
      dcAmount: json['dcAmount'],
      sDescription: json['sDescription'],
      iFirmID: json['iFirmID'],
      iSystemUserID: json['iSystemUserID'],
      dDate: json['dDate'],
      sEtc: json['sEtc'],
      bStatus: json['bStatus'],
      sSyncStatus: json['sSyncStatus'],
      sEntrySource: json['sEntrySource'],
      sAction: json['sAction'],
      dtCreatedDate: json['dtCreatedDate'],
      iAddedBy: json['iAddedBy'],
      dtUpdatedDate: json['dtUpdatedDate'],
      iUpdatedBy: json['iUpdatedBy'],
      dtDeletedDate: json['dtDeletedDate'],
      iDeletedBy: json['iDeletedBy'],
      iStoreID: json['iStoreID'],
      transaction_id: json['transaction_id'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'iDailyExpenseID': iDailyExpenseID,
      'iExpenseTypeID': iExpenseTypeID,
      'iBankID': iBankID,
      'iTableID': iTableID,
      'sTableName': sTableName,
      'sExpenseFor': sExpenseFor,
      'sVocherNo': sVocherNo,
      'sVocherScanImagePath': sVocherScanImagePath,
      'dcAmount': dcAmount,
      'sDescription': sDescription,
      'iFirmID': iFirmID,
      'iSystemUserID': iSystemUserID,
      'dDate': dDate,
      'sEtc': sEtc,
      'bStatus': bStatus,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate,
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate,
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate,
      'iDeletedBy': iDeletedBy,
      'iStoreID': iStoreID,
      'transaction_id': transaction_id,
    };
  }
}

class ExpenseType {
  final iExpenseTypeID;
  final iFirmID;
  final sTypeName;
  final sCode;
  final bStatus;
  final sSyncStatus;
  final sEntrySource;
  final sAction;
  final dtCreatedDate;
  final iAddedBy;
  final dtUpdatedDate;
  final iUpdatedBy;
  final dtDeletedDate;
  final iDeletedBy;
  final transaction_id;

  ExpenseType({
    required this.iExpenseTypeID,
    this.iFirmID,
    required this.sTypeName,
    this.sCode,
    this.bStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
    this.transaction_id,
  });

  // From JSON
  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      iExpenseTypeID: json['iExpenseTypeID'],
      iFirmID: json['iFirmID'],
      sTypeName: json['sTypeName'],
      sCode: json['sCode'],
      bStatus: json['bStatus'],
      sSyncStatus: json['sSyncStatus'],
      sEntrySource: json['sEntrySource'],
      sAction: json['sAction'],
      dtCreatedDate: json['dtCreatedDate'] != null
          ? DateTime.parse(json['dtCreatedDate'])
          : null,
      iAddedBy: json['iAddedBy'],
      dtUpdatedDate: json['dtUpdatedDate'] != null
          ? DateTime.parse(json['dtUpdatedDate'])
          : null,
      iUpdatedBy: json['iUpdatedBy'],
      dtDeletedDate: json['dtDeletedDate'] != null
          ? DateTime.parse(json['dtDeletedDate'])
          : null,
      iDeletedBy: json['iDeletedBy'],
      transaction_id: json['transaction_id'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'iExpenseTypeID': iExpenseTypeID,
      'iFirmID': iFirmID,
      'sTypeName': sTypeName,
      'sCode': sCode,
      'bStatus': bStatus,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
      'transaction_id': transaction_id,
    };
  }
}
