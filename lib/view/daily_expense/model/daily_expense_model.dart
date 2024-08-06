class DailyExpense {
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
  final transactionId;

  DailyExpense({
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
    this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return {
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
      'transactionId': transactionId,
    };
  }

  factory DailyExpense.fromMap(Map<String, dynamic> map) {
    return DailyExpense(
      iExpenseTypeID: map['iExpenseTypeID'],
      iBankID: map['iBankID'],
      iTableID: map['iTableID'],
      sTableName: map['sTableName'],
      sExpenseFor: map['sExpenseFor'],
      sVocherNo: map['sVocherNo'],
      sVocherScanImagePath: map['sVocherScanImagePath'],
      dcAmount: map['dcAmount'],
      sDescription: map['sDescription'],
      iFirmID: map['iFirmID'],
      iSystemUserID: map['iSystemUserID'],
      dDate: map['dDate'],
      sEtc: map['sEtc'],
      bStatus: map['bStatus'],
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      sAction: map['sAction'],
      dtCreatedDate: map['dtCreatedDate'],
      iAddedBy: map['iAddedBy'],
      dtUpdatedDate: map['dtUpdatedDate'],
      iUpdatedBy: map['iUpdatedBy'],
      dtDeletedDate: map['dtDeletedDate'],
      iDeletedBy: map['iDeletedBy'],
      iStoreID: map['iStoreID'],
      transactionId: map['transactionId'],
    );
  }
}

class ExpenseTypeModel {
  final int iExpenseTypeID;
  final int? iFirmID;
  final String sTypeName;
  final String? sCode;
  final String? bStatus;
  final String? sSyncStatus;
  final String? sEntrySource;
  final String? sAction;
  final DateTime? dtCreatedDate;
  final int? iAddedBy;
  final DateTime? dtUpdatedDate;
  final int? iUpdatedBy;
  final DateTime? dtDeletedDate;
  final int? iDeletedBy;
  final int? transaction_id;

  ExpenseTypeModel({
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

  // Convert a map to an ExpenseType object
  factory ExpenseTypeModel.fromMap(Map<String, dynamic> map) {
    return ExpenseTypeModel(
      iExpenseTypeID: map['iExpenseTypeID'],
      iFirmID: map['iFirmID'],
      sTypeName: map['sTypeName'],
      sCode: map['sCode'],
      bStatus: map['bStatus'],
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      sAction: map['sAction'],
      dtCreatedDate: map['dtCreatedDate'] != null
          ? DateTime.parse(map['dtCreatedDate'])
          : null,
      iAddedBy: map['iAddedBy'],
      dtUpdatedDate: map['dtUpdatedDate'] != null
          ? DateTime.parse(map['dtUpdatedDate'])
          : null,
      iUpdatedBy: map['iUpdatedBy'],
      dtDeletedDate: map['dtDeletedDate'] != null
          ? DateTime.parse(map['dtDeletedDate'])
          : null,
      iDeletedBy: map['iDeletedBy'],
      transaction_id: map['transaction_id'],
    );
  }

  // Convert an ExpenseType object to a map
  Map<String, dynamic> toMap() {
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
