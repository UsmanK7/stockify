class Country {
  final int iCountryID;
  final int? iFirmID;
  final int iSystemUserID;
  final String? sCountryName;
  final String? sCode;
  final bool bStatus;
  final String? sSyncStatus;
  final String? sEntrySource;
  final String? sAction;
  final DateTime? dtCreatedDate;
  final int? iAddedBy;
  final DateTime? dtUpdatedDate;
  final int? iUpdatedBy;
  final DateTime? dtDeletedDate;
  final int? iDeletedBy;

  Country({
    required this.iCountryID,
    this.iFirmID,
    required this.iSystemUserID,
    this.sCountryName,
    this.sCode,
    required this.bStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
  });

  // Factory method to create a Country object from JSON
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      iCountryID: int.parse(json['iCountryID']),
      iFirmID: json['iFirmID'] != null ? int.tryParse(json['iFirmID']) : null,
      iSystemUserID: int.parse(json['iSystemUserID']),
      sCountryName: json['sCountryName'],
      sCode: json['sCode'],
      bStatus: json['bStatus'] == "1", // Convert string "1" to bool true
      sSyncStatus: json['sSyncStatus'],
      sEntrySource: json['sEntrySource'],
      sAction: json['sAction'],
      dtCreatedDate: json['dtCreatedDate'] != null
          ? DateTime.tryParse(json['dtCreatedDate'])
          : null,
      iAddedBy:
          json['iAddedBy'] != null ? int.tryParse(json['iAddedBy']) : null,
      dtUpdatedDate: json['dtUpdatedDate'] != null
          ? DateTime.tryParse(json['dtUpdatedDate'])
          : null,
      iUpdatedBy:
          json['iUpdatedBy'] != null ? int.tryParse(json['iUpdatedBy']) : null,
      dtDeletedDate: json['dtDeletedDate'] != null
          ? DateTime.tryParse(json['dtDeletedDate'])
          : null,
      iDeletedBy:
          json['iDeletedBy'] != null ? int.tryParse(json['iDeletedBy']) : null,
    );
  }

  // Method to convert Country object to JSON
  Map<String, dynamic> toJson() {
    return {
      'iCountryID': iCountryID.toString(),
      'iFirmID': iFirmID?.toString(),
      'iSystemUserID': iSystemUserID.toString(),
      'sCountryName': sCountryName,
      'sCode': sCode,
      'bStatus': bStatus ? "1" : "0", // Convert bool to string "1" or "0"
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy?.toString(),
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy?.toString(),
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy?.toString(),
    };
  }

  // Factory method to create a Country object from a Map (used for SQLite)
  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      iCountryID: map['iCountryID'],
      iFirmID: map['iFirmID'],
      iSystemUserID: map['iSystemUserID'],
      sCountryName: map['sCountryName'],
      sCode: map['sCode'],
      bStatus: map['bStatus'] == 1, // Convert int 1 to bool true
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      sAction: map['sAction'],
      dtCreatedDate: map['dtCreatedDate'] != null
          ? DateTime.tryParse(map['dtCreatedDate'])
          : null,
      iAddedBy: map['iAddedBy'],
      dtUpdatedDate: map['dtUpdatedDate'] != null
          ? DateTime.tryParse(map['dtUpdatedDate'])
          : null,
      iUpdatedBy: map['iUpdatedBy'],
      dtDeletedDate: map['dtDeletedDate'] != null
          ? DateTime.tryParse(map['dtDeletedDate'])
          : null,
      iDeletedBy: map['iDeletedBy'],
    );
  }

  // Method to convert Country object to a Map (used for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'iCountryID': iCountryID,
      'iFirmID': iFirmID,
      'iSystemUserID': iSystemUserID,
      'sCountryName': sCountryName,
      'sCode': sCode,
      'bStatus': bStatus ? 1 : 0, // Convert bool to int 1 or 0
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
    };
  }
}

class States {
  final int id;
  final int? countryId;
  final int? firmId;
  final int systemUserId;
  final String? stateName;
  final String? code;
  final bool status; // Use bool for binary status
  final String? syncStatus;
  final String? entrySource;
  final String? action;
  final DateTime? createdDate;
  final int? addedBy;
  final DateTime? updatedDate;
  final int? updatedBy;
  final DateTime? deletedDate;
  final int? deletedBy;

  States({
    required this.id,
    this.countryId,
    this.firmId,
    required this.systemUserId,
    this.stateName,
    this.code,
    required this.status,
    this.syncStatus,
    this.entrySource,
    this.action,
    this.createdDate,
    this.addedBy,
    this.updatedDate,
    this.updatedBy,
    this.deletedDate,
    this.deletedBy,
  });

  // Factory method to create a States object from JSON
  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      id: int.parse(json['iCountryStateID']),
      countryId:
          json['iCountryID'] != null ? int.tryParse(json['iCountryID']) : null,
      firmId: json['iFirmID'] != null ? int.tryParse(json['iFirmID']) : null,
      systemUserId: int.parse(json['iSystemUserID']),
      stateName: json['sStateName'],
      code: json['sCode'],
      status: json['bStatus'] == "1", // Convert string "1" to bool true
      syncStatus: json['sSyncStatus'],
      entrySource: json['sEntrySource'],
      action: json['sAction'],
      createdDate: json['dtCreatedDate'] != null
          ? DateTime.tryParse(json['dtCreatedDate'])
          : null,
      addedBy: json['iAddedBy'] != null ? int.tryParse(json['iAddedBy']) : null,
      updatedDate: json['dtUpdatedDate'] != null
          ? DateTime.tryParse(json['dtUpdatedDate'])
          : null,
      updatedBy:
          json['iUpdatedBy'] != null ? int.tryParse(json['iUpdatedBy']) : null,
      deletedDate: json['dtDeletedDate'] != null
          ? DateTime.tryParse(json['dtDeletedDate'])
          : null,
      deletedBy:
          json['iDeletedBy'] != null ? int.tryParse(json['iDeletedBy']) : null,
    );
  }

  // Method to convert States object to JSON
  Map<String, dynamic> toJson() {
    return {
      'iCountryStateID': id.toString(),
      'iCountryID': countryId?.toString(),
      'iFirmID': firmId?.toString(),
      'iSystemUserID': systemUserId.toString(),
      'sStateName': stateName,
      'sCode': code,
      'bStatus': status ? "1" : "0", // Convert bool to string "1" or "0"
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy?.toString(),
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy?.toString(),
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy?.toString(),
    };
  }

  // Factory method to create a States object from a Map (used for SQLite)
  factory States.fromMap(Map<String, dynamic> map) {
    return States(
      id: map['iCountryStateID'],
      countryId: map['iCountryID'],
      firmId: map['iFirmID'],
      systemUserId: map['iSystemUserID'],
      stateName: map['sStateName'],
      code: map['sCode'],
      status: map['bStatus'] == 1, // Convert int 1 to bool true
      syncStatus: map['sSyncStatus'],
      entrySource: map['sEntrySource'],
      action: map['sAction'],
      createdDate: map['dtCreatedDate'] != null
          ? DateTime.tryParse(map['dtCreatedDate'])
          : null,
      addedBy: map['iAddedBy'],
      updatedDate: map['dtUpdatedDate'] != null
          ? DateTime.tryParse(map['dtUpdatedDate'])
          : null,
      updatedBy: map['iUpdatedBy'],
      deletedDate: map['dtDeletedDate'] != null
          ? DateTime.tryParse(map['dtDeletedDate'])
          : null,
      deletedBy: map['iDeletedBy'],
    );
  }

  // Method to convert States object to a Map (used for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'iCountryStateID': id,
      'iCountryID': countryId,
      'iFirmID': firmId,
      'iSystemUserID': systemUserId,
      'sStateName': stateName,
      'sCode': code,
      'bStatus': status ? 1 : 0, // Convert bool to int 1 or 0
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
    };
  }
}

class City {
  final int id;
  final int? firmId;
  final int systemUserId;
  final int? countryStateId;
  final String? name;
  final String? code;
  final bool status; // Use bool for binary status
  final String? syncStatus;
  final String? entrySource;
  final String? action;
  final DateTime? createdDate;
  final int? addedBy;
  final DateTime? updatedDate;
  final int? updatedBy;
  final DateTime? deletedDate;
  final int? deletedBy;

  City({
    required this.id,
    this.firmId,
    required this.systemUserId,
    this.countryStateId,
    this.name,
    this.code,
    required this.status, // Mark as required since it's a bool
    this.syncStatus,
    this.entrySource,
    this.action,
    this.createdDate,
    this.addedBy,
    this.updatedDate,
    this.updatedBy,
    this.deletedDate,
    this.deletedBy,
  });

  // Factory method to create a City object from a Map (used for SQLite)
  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: int.parse(map['iCityID'].toString()), // Primary Key
      firmId: map['iFirmID'] != null
          ? int.tryParse(map['iFirmID'].toString())
          : null,
      systemUserId:
          int.parse(map['iSystemUserID'].toString()), // Required field
      countryStateId: map['iCountryStateID'] != null
          ? int.tryParse(map['iCountryStateID'].toString())
          : null,
      name: map['sName'], // Nullable field
      code: map['sCode'], // Nullable field
      status: map['bStatus'] == "1", // Convert string "1" to bool true
      syncStatus: map['sSyncStatus'], // Nullable field
      entrySource: map['sEntrySource'], // Nullable field
      action: map['sAction'], // Nullable field
      createdDate: map['dtCreatedDate'] != null
          ? DateTime.tryParse(map['dtCreatedDate'])
          : null,
      addedBy: map['iAddedBy'] != null
          ? int.tryParse(map['iAddedBy'].toString())
          : null,
      updatedDate: map['dtUpdatedDate'] != null
          ? DateTime.tryParse(map['dtUpdatedDate'])
          : null,
      updatedBy: map['iUpdatedBy'] != null
          ? int.tryParse(map['iUpdatedBy'].toString())
          : null,
      deletedDate: map['dtDeletedDate'] != null
          ? DateTime.tryParse(map['dtDeletedDate'])
          : null,
      deletedBy: map['iDeletedBy'] != null
          ? int.tryParse(map['iDeletedBy'].toString())
          : null,
    );
  }

  // Method to convert City object to a Map (used for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'iCityID': id, // Primary Key
      'iFirmID': firmId,
      'iSystemUserID': systemUserId, // Required field
      'iCountryStateID': countryStateId,
      'sName': name,
      'sCode': code,
      'bStatus': status ? "1" : "0", // Convert bool to string "1" or "0"
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
    };
  }

  // Factory method to create a City object from JSON
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.parse(json['iCityID'].toString()), // Primary Key
      firmId: json['iFirmID'] != null
          ? int.tryParse(json['iFirmID'].toString())
          : null,
      systemUserId:
          int.parse(json['iSystemUserID'].toString()), // Required field
      countryStateId: json['iCountryStateID'] != null
          ? int.tryParse(json['iCountryStateID'].toString())
          : null,
      name: json['sName'], // Nullable field
      code: json['sCode'], // Nullable field
      status: json['bStatus'] == "1", // Convert string "1" to bool true
      syncStatus: json['sSyncStatus'], // Nullable field
      entrySource: json['sEntrySource'], // Nullable field
      action: json['sAction'], // Nullable field
      createdDate: json['dtCreatedDate'] != null
          ? DateTime.tryParse(json['dtCreatedDate'])
          : null,
      addedBy: json['iAddedBy'] != null
          ? int.tryParse(json['iAddedBy'].toString())
          : null,
      updatedDate: json['dtUpdatedDate'] != null
          ? DateTime.tryParse(json['dtUpdatedDate'])
          : null,
      updatedBy: json['iUpdatedBy'] != null
          ? int.tryParse(json['iUpdatedBy'].toString())
          : null,
      deletedDate: json['dtDeletedDate'] != null
          ? DateTime.tryParse(json['dtDeletedDate'])
          : null,
      deletedBy: json['iDeletedBy'] != null
          ? int.tryParse(json['iDeletedBy'].toString())
          : null,
    );
  }

  // Method to convert City object to JSON
  Map<String, dynamic> toJson() {
    return {
      'iCityID': id, // Primary Key
      'iFirmID': firmId,
      'iSystemUserID': systemUserId, // Required field
      'iCountryStateID': countryStateId,
      'sName': name,
      'sCode': code,
      'bStatus': status ? "1" : "0", // Convert bool to string "1" or "0"
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
    };
  }
}

class Area {
  final int id;
  final int? firmId;
  final int systemUserId;
  final int? cityId;
  final String? name;
  final String? code;
  final String? status;
  final String? syncStatus;
  final String? entrySource;
  final String? action;
  final DateTime? createdDate;
  final int? addedBy;
  final DateTime? updatedDate;
  final int? updatedBy;
  final DateTime? deletedDate;
  final int? deletedBy;
  final int? storeId;

  Area({
    required this.id,
    this.firmId,
    required this.systemUserId,
    this.cityId,
    this.name,
    this.code,
    this.status,
    this.syncStatus,
    this.entrySource,
    this.action,
    this.createdDate,
    this.addedBy,
    this.updatedDate,
    this.updatedBy,
    this.deletedDate,
    this.deletedBy,
    this.storeId,
  });

  /// Converts a map to an Area instance
  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: int.parse(map['iAreaID'].toString()), // Primary Key
      firmId:
          map['iFirmID'] != null ? int.parse(map['iFirmID'].toString()) : null,
      cityId:
          map['iCityID'] != null ? int.parse(map['iCityID'].toString()) : null,
      systemUserId:
          int.parse(map['iSystemUserID'].toString()), // Required field
      name: map['sName'], // Nullable field
      code: map['sCode'], // Nullable field
      status: map['bStatus'], // Nullable field
      syncStatus: map['sSyncStatus'], // Nullable field
      entrySource: map['sEntrySource'], // Nullable field
      action: map['sAction'], // Nullable field
      createdDate: map['dtCreatedDate'] != null
          ? DateTime.tryParse(map['dtCreatedDate'])
          : null,
      addedBy: map['iAddedBy'] != null
          ? int.parse(map['iAddedBy'].toString())
          : null,
      updatedDate: map['dtUpdatedDate'] != null
          ? DateTime.tryParse(map['dtUpdatedDate'])
          : null,
      updatedBy: map['iUpdatedBy'] != null
          ? int.parse(map['iUpdatedBy'].toString())
          : null,
      deletedDate: map['dtDeletedDate'] != null
          ? DateTime.tryParse(map['dtDeletedDate'])
          : null,
      deletedBy: map['iDeletedBy'] != null
          ? int.parse(map['iDeletedBy'].toString())
          : null,
      storeId: map['iStoreID'] != null
          ? int.parse(map['iStoreID'].toString())
          : null,
    );
  }

  /// Converts an Area instance to a map
  Map<String, dynamic> toMap() {
    return {
      'iAreaID': id, // Primary Key
      'iFirmID': firmId,
      'iCityID': cityId,
      'iSystemUserID': systemUserId, // Required field
      'sName': name,
      'sCode': code,
      'bStatus': status,
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
      'iStoreID': storeId,
    };
  }

  /// Converts a JSON map to an Area instance
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: int.parse(json['iAreaID'].toString()), // Primary Key
      firmId: json['iFirmID'] != null
          ? int.parse(json['iFirmID'].toString())
          : null,
      cityId: json['iCityID'] != null
          ? int.parse(json['iCityID'].toString())
          : null,
      systemUserId:
          int.parse(json['iSystemUserID'].toString()), // Required field
      name: json['sName'], // Nullable field
      code: json['sCode'], // Nullable field
      status: json['bStatus'], // Nullable field
      syncStatus: json['sSyncStatus'], // Nullable field
      entrySource: json['sEntrySource'], // Nullable field
      action: json['sAction'], // Nullable field
      createdDate: json['dtCreatedDate'] != null
          ? DateTime.tryParse(json['dtCreatedDate'])
          : null,
      addedBy: json['iAddedBy'] != null
          ? int.parse(json['iAddedBy'].toString())
          : null,
      updatedDate: json['dtUpdatedDate'] != null
          ? DateTime.tryParse(json['dtUpdatedDate'])
          : null,
      updatedBy: json['iUpdatedBy'] != null
          ? int.parse(json['iUpdatedBy'].toString())
          : null,
      deletedDate: json['dtDeletedDate'] != null
          ? DateTime.tryParse(json['dtDeletedDate'])
          : null,
      deletedBy: json['iDeletedBy'] != null
          ? int.parse(json['iDeletedBy'].toString())
          : null,
      storeId: json['iStoreID'] != null
          ? int.parse(json['iStoreID'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iAreaID': id, // Primary Key
      'iFirmID': firmId,
      'iCityID': cityId,
      'iSystemUserID': systemUserId, // Required field
      'sName': name,
      'sCode': code,
      'bStatus': status,
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
      'iStoreID': storeId,
    };
  }
}

class Customer {
  final int id;
  final int? systemUserId;
  final int? areaId;
  final int? firmId;
  final String? name;
  final String? shopName;
  final String? email;
  final String? code;
  final String? address;
  final String? phone;
  final String? mobile;
  final String? description;
  final double? defaultAmount;
  final double? previousAmount;
  final int? totalRemainingAmount;
  final String? status;
  final String? syncStatus;
  final String? entrySource;
  final String? action;
  final String? type;
  final DateTime? createdDate;
  final int? addedBy;
  final DateTime? updatedDate;
  final int? updatedBy;
  final DateTime? deletedDate;
  final int? deletedBy;
  final int? storeId;

  Customer({
    required this.id,
    this.systemUserId,
    this.areaId,
    this.firmId,
    required this.name,
    this.shopName,
    this.email,
    this.code,
    this.address,
    this.phone,
    this.mobile,
    this.description,
    this.defaultAmount,
    this.previousAmount,
    this.totalRemainingAmount,
    this.status,
    this.syncStatus,
    this.entrySource,
    this.action,
    this.type,
    this.createdDate,
    this.addedBy,
    this.updatedDate,
    this.updatedBy,
    this.deletedDate,
    this.deletedBy,
    this.storeId,
  });

  /// Converts a map to a Customer instance
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: int.parse(map['iPermanentCustomerID'].toString()), // Primary Key
      systemUserId: map['iSystemUserID'] != null
          ? int.parse(map['iSystemUserID'].toString())
          : null,
      areaId:
          map['iAreaID'] != null ? int.parse(map['iAreaID'].toString()) : null,
      firmId:
          map['iFirmID'] != null ? int.parse(map['iFirmID'].toString()) : null,
      name: map['sName'], // Required field
      shopName: map['sShopName'],
      email: map['sEmail'],
      code: map['sCode'],
      address: map['sAddress'],
      phone: map['sPhone'],
      mobile: map['sMobile'],
      description: map['sDescription'],
      defaultAmount: map['dcDefaultAmount'] != null
          ? double.tryParse(map['dcDefaultAmount'].toString())
          : null,
      previousAmount: map['dcPreviousAmount'] != null
          ? double.tryParse(map['dcPreviousAmount'].toString())
          : null,
      totalRemainingAmount: map['dcTotalRemaningAmount'] != null
          ? int.tryParse(map['dcTotalRemaningAmount'].toString())
          : null,
      status: map['bStatus'],
      syncStatus: map['sSyncStatus'],
      entrySource: map['sEntrySource'],
      action: map['sAction'],
      type: map['sType'],
      createdDate: map['dtCreatedDate'] != null
          ? DateTime.tryParse(map['dtCreatedDate'])
          : null,
      addedBy: map['iAddedBy'] != null
          ? int.parse(map['iAddedBy'].toString())
          : null,
      updatedDate: map['dtUpdatedDate'] != null
          ? DateTime.tryParse(map['dtUpdatedDate'])
          : null,
      updatedBy: map['iUpdatedBy'] != null
          ? int.parse(map['iUpdatedBy'].toString())
          : null,
      deletedDate: map['dtDeletedDate'] != null
          ? DateTime.tryParse(map['dtDeletedDate'])
          : null,
      deletedBy: map['iDeletedBy'] != null
          ? int.parse(map['iDeletedBy'].toString())
          : null,
      storeId: map['iStoreID'] != null
          ? int.parse(map['iStoreID'].toString())
          : null,
    );
  }

  /// Converts a Customer instance to a map
  Map<String, dynamic> toMap() {
    return {
      'iPermanentCustomerID': id, // Primary Key
      'iSystemUserID': systemUserId,
      'iAreaID': areaId,
      'iFirmID': firmId,
      'sName': name, // Required field
      'sShopName': shopName,
      'sEmail': email,
      'sCode': code,
      'sAddress': address,
      'sPhone': phone,
      'sMobile': mobile,
      'sDescription': description,
      'dcDefaultAmount': defaultAmount,
      'dcPreviousAmount': previousAmount,
      'dcTotalRemaningAmount': totalRemainingAmount,
      'bStatus': status,
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'sType': type,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
      'iStoreID': storeId,
    };
  }

  /// Converts a JSON map to a Customer instance
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: int.parse(json['iPermanentCustomerID'].toString()), // Primary Key
      systemUserId: json['iSystemUserID'] != null
          ? int.parse(json['iSystemUserID'].toString())
          : null,
      areaId: json['iAreaID'] != null
          ? int.parse(json['iAreaID'].toString())
          : null,
      firmId: json['iFirmID'] != null
          ? int.parse(json['iFirmID'].toString())
          : null,
      name: json['sName'], // Required field
      shopName: json['sShopName'],
      email: json['sEmail'],
      code: json['sCode'],
      address: json['sAddress'],
      phone: json['sPhone'],
      mobile: json['sMobile'],
      description: json['sDescription'],
      defaultAmount: json['dcDefaultAmount'] != null
          ? double.tryParse(json['dcDefaultAmount'].toString())
          : null,
      previousAmount: json['dcPreviousAmount'] != null
          ? double.tryParse(json['dcPreviousAmount'].toString())
          : null,
      totalRemainingAmount: json['dcTotalRemaningAmount'] != null
          ? int.tryParse(json['dcTotalRemaningAmount'].toString())
          : null,
      status: json['bStatus'],
      syncStatus: json['sSyncStatus'],
      entrySource: json['sEntrySource'],
      action: json['sAction'],
      type: json['sType'],
      createdDate: json['dtCreatedDate'] != null
          ? DateTime.tryParse(json['dtCreatedDate'])
          : null,
      addedBy: json['iAddedBy'] != null
          ? int.parse(json['iAddedBy'].toString())
          : null,
      updatedDate: json['dtUpdatedDate'] != null
          ? DateTime.tryParse(json['dtUpdatedDate'])
          : null,
      updatedBy: json['iUpdatedBy'] != null
          ? int.parse(json['iUpdatedBy'].toString())
          : null,
      deletedDate: json['dtDeletedDate'] != null
          ? DateTime.tryParse(json['dtDeletedDate'])
          : null,
      deletedBy: json['iDeletedBy'] != null
          ? int.parse(json['iDeletedBy'].toString())
          : null,
      storeId: json['iStoreID'] != null
          ? int.parse(json['iStoreID'].toString())
          : null,
    );
  }

  /// Converts a Customer instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'iPermanentCustomerID': id, // Primary Key
      'iSystemUserID': systemUserId,
      'iAreaID': areaId,
      'iFirmID': firmId,
      'sName': name, // Required field
      'sShopName': shopName,
      'sEmail': email,
      'sCode': code,
      'sAddress': address,
      'sPhone': phone,
      'sMobile': mobile,
      'sDescription': description,
      'dcDefaultAmount': defaultAmount,
      'dcPreviousAmount': previousAmount,
      'dcTotalRemaningAmount': totalRemainingAmount,
      'bStatus': status,
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'sType': type,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
      'iStoreID': storeId,
    };
  }
}

class Bank {
  final int id;
  final int iSystemUserID;
  final int iFirmID;
  final String name;
  final String? sCode;
  final String? sAddress;
  final String? sPhone;
  final String? sAccountNo;
  final String? sDescription;
  final double? dcDefaultAmount;
  final double? dcPreviousAmount;
  final double? dcTotalRemainingAmount;
  final String? bStatus;
  final String? sSyncStatus;
  final String? sEntrySource;
  final String? sAction;
  final String? sType;
  final DateTime? dtCreatedDate;
  final int? iAddedBy;
  final DateTime? dtUpdatedDate;
  final int? iUpdatedBy;
  final DateTime? dtDeletedDate;
  final int? iDeletedBy;

  Bank({
    required this.id,
    required this.iSystemUserID,
    required this.iFirmID,
    required this.name,
    this.sCode,
    this.sAddress,
    this.sPhone,
    this.sAccountNo,
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

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      id: map['iBankID'],
      iSystemUserID: map['iSystemUserID'],
      iFirmID: map['iFirmID'],
      name: map['sName'],
      sCode: map['sCode'],
      sAddress: map['sAddress'],
      sPhone: map['sPhone'],
      sAccountNo: map['sAccountNo'],
      sDescription: map['sDescription'],
      dcDefaultAmount: map['dcDefaultAmount']?.toDouble(),
      dcPreviousAmount: map['dcPreviousAmount']?.toDouble(),
      dcTotalRemainingAmount: map['dcTotalRemainingAmount']?.toDouble(),
      bStatus: map['bStatus'],
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      sAction: map['sAction'],
      sType: map['sType'],
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
    );
  }
}

class PermanentCustomerPayment {
  int? iPermanentCustomerPaymentsID;
  int? iPermanentCustomerID;
  String? customerName;
  int? iBankID;
  int? iSystemUserID;
  int? iEmployeeID;
  int? iFirmID;
  int? iTableID;
  String? sTableName;
  double? dcPaidAmount;
  String? sBank;
  String? sCheckNumber;
  String? sInvoiceNo;
  String? sDescription;
  String? sSyncStatus;
  String? sEntrySource;
  String? sAction;
  DateTime? dDate;
  DateTime? dtCreatedDate;
  String? bStatus;
  int? iAddedBy;
  DateTime? dtUpdatedDate;
  int? iUpdatedBy;
  DateTime? dtDeletedDate;
  int? iDeletedBy;

  PermanentCustomerPayment({
    this.iPermanentCustomerPaymentsID,
    this.iPermanentCustomerID,
    this.customerName,
    this.iBankID,
    this.iSystemUserID,
    this.iEmployeeID,
    this.iFirmID,
    this.iTableID,
    this.sTableName,
    this.dcPaidAmount,
    this.sBank,
    this.sCheckNumber,
    this.sInvoiceNo,
    this.sDescription,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.dDate,
    this.dtCreatedDate,
    this.bStatus,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
  });

  factory PermanentCustomerPayment.fromMap(Map<String, dynamic> map) {
    return PermanentCustomerPayment(
      iPermanentCustomerPaymentsID: map['iPermanentCustomerPaymentsID'] ?? 0,
      iPermanentCustomerID: map['iPermanentCustomerID'] ?? 0,
      customerName: map['customerName'] ?? '', // Add this line
      iBankID: map['iBankID'],
      iSystemUserID: map['iSystemUserID'],
      iEmployeeID: map['iEmployeeID'] ?? 0,
      iFirmID: map['iFirmID'],
      iTableID: map['iTableID'],
      sTableName: map['sTableName'] ?? '',
      dcPaidAmount: map['dcPaidAmount']?.toDouble(),
      sBank: map['sBank'] ?? '',
      sCheckNumber: map['sCheckNumber'] ?? '',
      sInvoiceNo: map['sInvoiceNo'] ?? '',
      sDescription: map['sDescription'] ?? '',
      sSyncStatus: map['sSyncStatus'] ?? '',
      sEntrySource: map['sEntrySource'] ?? '',
      sAction: map['sAction'] ?? '',
      dDate: map['dDate'] != null ? DateTime.parse(map['dDate']) : null,
      dtCreatedDate: map['dtCreatedDate'] != null
          ? DateTime.parse(map['dtCreatedDate'])
          : null,
      bStatus: map['bStatus'],
      iAddedBy: map['iAddedBy'],
      dtUpdatedDate: map['dtUpdatedDate'] != null
          ? DateTime.parse(map['dtUpdatedDate'])
          : null,
      iUpdatedBy: map['iUpdatedBy'],
      dtDeletedDate: map['dtDeletedDate'] != null
          ? DateTime.parse(map['dtDeletedDate'])
          : null,
      iDeletedBy: map['iDeletedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iPermanentCustomerID': iPermanentCustomerID,
      'iBankID': iBankID,
      'iSystemUserID': iSystemUserID,
      'iEmployeeID': iEmployeeID,
      'iFirmID': iFirmID,
      'iTableID': iTableID,
      'sTableName': sTableName,
      'dcPaidAmount': dcPaidAmount,
      'sBank': sBank,
      'sCheckNumber': sCheckNumber,
      'sInvoiceNo': sInvoiceNo,
      'sDescription': sDescription,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dDate': dDate?.toIso8601String(),
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'bStatus': bStatus,
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
    };
  }
}

class SalesmanLocation {
  int? iSalemanLocationId;
  int? iTableID;
  String? sTableName;
  String? sLongitude;
  String? sLatitude;
  String? sLocation;
  String? sDateTime;

  SalesmanLocation({
    this.iSalemanLocationId,
    this.iTableID,
    this.sTableName,
    this.sLongitude,
    this.sLatitude,
    this.sLocation,
    this.sDateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'iSalemanLocationId': iSalemanLocationId,
      'iTableID': iTableID,
      'sTableName': sTableName,
      'sLongitude': sLongitude,
      'sLatitude': sLatitude,
      'sLocation': sLocation,
      'sDateTime': sDateTime,
    };
  }

  @override
  String toString() {
    return 'SalesmanLocation{iSalemanLocationId: $iSalemanLocationId, iTableID: $iTableID, sTableName: $sTableName, sLongitude: $sLongitude, sLatitude: $sLatitude, sLocation: $sLocation, sDateTime: $sDateTime}';
  }

  factory SalesmanLocation.fromMap(Map<String, dynamic> map) {
    return SalesmanLocation(
      iSalemanLocationId: map['iSalemanLocationId'],
      iTableID: map['iTableID'],
      sTableName: map['sTableName'],
      sLongitude: map['sLongitude'],
      sLatitude: map['sLatitude'],
      sLocation: map['sLocation'],
      sDateTime: map['sDateTime'],
    );
  }
}

class FirmSetting {
  final int firmID;
  final String firmName;
  final String? firmInvoicePrefix;
  final String? firmTA;
  final String? firmGSTNO;
  final String? firmEmail;
  final String? firmPhone1;
  final String? firmPhone2;
  final String? firmMob1;
  final String? firmMob2;
  final String? firmAddress;
  final String? firmHomeAddress;
  final String? firmTINNO;
  final String? firmLogo;
  final String? firmWebsite;
  final String? firmState;
  final String? firmCity;
  final String? firmBranchName;
  final String? firmBankAccountNo;
  final String? firmBankName;
  final String? firmBankCode;
  final String? firmDetail;
  final String? firmBussinessType;
  final DateTime? registeredDate;
  final int? softwarePackageID;
  final DateTime? licenseStartDate;
  final DateTime? licenseEndDate;
  final String? registrationKey;
  final String? totalPaidAmount;
  final String? remainingAmount;
  final String? active;
  final int? status;
  final String? syncStatus;
  final String? entrySource;
  final String? action;
  final DateTime? createdDate;
  final int? addedBy;
  final DateTime? updatedDate;
  final int? updatedBy;
  final DateTime? deletedDate;
  final int? deletedBy;

  FirmSetting({
    required this.firmID,
    required this.firmName,
    this.firmInvoicePrefix,
    this.firmTA,
    this.firmGSTNO,
    this.firmEmail,
    this.firmPhone1,
    this.firmPhone2,
    this.firmMob1,
    this.firmMob2,
    this.firmAddress,
    this.firmHomeAddress,
    this.firmTINNO,
    this.firmLogo,
    this.firmWebsite,
    this.firmState,
    this.firmCity,
    this.firmBranchName,
    this.firmBankAccountNo,
    this.firmBankName,
    this.firmBankCode,
    this.firmDetail,
    this.firmBussinessType,
    this.registeredDate,
    this.softwarePackageID,
    this.licenseStartDate,
    this.licenseEndDate,
    this.registrationKey,
    this.totalPaidAmount,
    this.remainingAmount,
    this.active,
    this.status,
    this.syncStatus,
    this.entrySource,
    this.action,
    this.createdDate,
    this.addedBy,
    this.updatedDate,
    this.updatedBy,
    this.deletedDate,
    this.deletedBy,
  });

  factory FirmSetting.fromMap(Map<String, dynamic> map) {
    return FirmSetting(
      firmID: map['iFirmID'],
      firmName: map['sFirmName'],
      firmInvoicePrefix: map['sFirmInvoicePrefix'],
      firmTA: map['sFirmTA'],
      firmGSTNO: map['sFirmGSTNO'],
      firmEmail: map['sFirmEmail'],
      firmPhone1: map['sFirmPhone1'],
      firmPhone2: map['sFirmPhone2'],
      firmMob1: map['sFirmMob1'],
      firmMob2: map['sFirmMob2'],
      firmAddress: map['sFirmAddress'],
      firmHomeAddress: map['sFirmHomeAddress'],
      firmTINNO: map['sFirmTINNO'],
      firmLogo: map['sFirmLogo'],
      firmWebsite: map['sFirmWebsite'],
      firmState: map['sFirmState'],
      firmCity: map['sFirmCity'],
      firmBranchName: map['sFirmBranchName'],
      firmBankAccountNo: map['sFirmBankAccountNo'],
      firmBankName: map['sFirmBankName'],
      firmBankCode: map['sFirmBankCode'],
      firmDetail: map['sFirmDetail'],
      firmBussinessType: map['sFirmBussinessType'],
      registeredDate: map['dtRegisteredDate'] != null
          ? DateTime.parse(map['dtRegisteredDate'])
          : null,
      softwarePackageID: map['iSoftwarePackageID'],
      licenseStartDate: map['dtLicenseStartDate'] != null
          ? DateTime.parse(map['dtLicenseStartDate'])
          : null,
      licenseEndDate: map['dtLicenseEndDate'] != null
          ? DateTime.parse(map['dtLicenseEndDate'])
          : null,
      registrationKey: map['sRegistrationKey'],
      totalPaidAmount: map['sTotalPaidAmount'],
      remainingAmount: map['sRemainingAmount'],
      active: map['sActive'],
      status: map['bStatus'],
      syncStatus: map['sSyncStatus'],
      entrySource: map['sEntrySource'],
      action: map['sAction'],
      createdDate: map['dtCreatedDate'] != null
          ? DateTime.parse(map['dtCreatedDate'])
          : null,
      addedBy: map['iAddedBy'],
      updatedDate: map['dtUpdatedDate'] != null
          ? DateTime.parse(map['dtUpdatedDate'])
          : null,
      updatedBy: map['iUpdatedBy'],
      deletedDate: map['dtDeletedDate'] != null
          ? DateTime.parse(map['dtDeletedDate'])
          : null,
      deletedBy: map['iDeletedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iFirmID': firmID,
      'sFirmName': firmName,
      'sFirmInvoicePrefix': firmInvoicePrefix,
      'sFirmTA': firmTA,
      'sFirmGSTNO': firmGSTNO,
      'sFirmEmail': firmEmail,
      'sFirmPhone1': firmPhone1,
      'sFirmPhone2': firmPhone2,
      'sFirmMob1': firmMob1,
      'sFirmMob2': firmMob2,
      'sFirmAddress': firmAddress,
      'sFirmHomeAddress': firmHomeAddress,
      'sFirmTINNO': firmTINNO,
      'sFirmLogo': firmLogo,
      'sFirmWebsite': firmWebsite,
      'sFirmState': firmState,
      'sFirmCity': firmCity,
      'sFirmBranchName': firmBranchName,
      'sFirmBankAccountNo': firmBankAccountNo,
      'sFirmBankName': firmBankName,
      'sFirmBankCode': firmBankCode,
      'sFirmDetail': firmDetail,
      'sFirmBussinessType': firmBussinessType,
      'dtRegisteredDate': registeredDate?.toIso8601String(),
      'iSoftwarePackageID': softwarePackageID,
      'dtLicenseStartDate': licenseStartDate?.toIso8601String(),
      'dtLicenseEndDate': licenseEndDate?.toIso8601String(),
      'sRegistrationKey': registrationKey,
      'sTotalPaidAmount': totalPaidAmount,
      'sRemainingAmount': remainingAmount,
      'sActive': active,
      'bStatus': status,
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
    };
  }

  factory FirmSetting.fromJson(Map<String, dynamic> json) {
    return FirmSetting(
      firmID: int.parse(json['iFirmID'].toString()),
      firmName: json['sFirmName'],
      firmInvoicePrefix: json['sFirmInvoicePrefix'],
      firmTA: json['sFirmTA'],
      firmGSTNO: json['sFirmGSTNO'],
      firmEmail: json['sFirmEmail'],
      firmPhone1: json['sFirmPhone1'],
      firmPhone2: json['sFirmPhone2'],
      firmMob1: json['sFirmMob1'],
      firmMob2: json['sFirmMob2'],
      firmAddress: json['sFirmAddress'],
      firmHomeAddress: json['sFirmHomeAddress'],
      firmTINNO: json['sFirmTINNO'],
      firmLogo: json['sFirmLogo'],
      firmWebsite: json['sFirmWebsite'],
      firmState: json['sFirmState'],
      firmCity: json['sFirmCity'],
      firmBranchName: json['sFirmBranchName'],
      firmBankAccountNo: json['sFirmBankAccountNo'],
      firmBankName: json['sFirmBankName'],
      firmBankCode: json['sFirmBankCode'],
      firmDetail: json['sFirmDetail'],
      firmBussinessType: json['sFirmBussinessType'],
      registeredDate: json['dtRegisteredDate'] != null
          ? DateTime.parse(json['dtRegisteredDate'])
          : null,
      softwarePackageID: json['iSoftwarePackageID'] != null
          ? int.parse(json['iSoftwarePackageID'].toString())
          : null,
      licenseStartDate: json['dtLicenseStartDate'] != null
          ? DateTime.parse(json['dtLicenseStartDate'])
          : null,
      licenseEndDate: json['dtLicenseEndDate'] != null
          ? DateTime.parse(json['dtLicenseEndDate'])
          : null,
      registrationKey: json['sRegistrationKey'],
      totalPaidAmount: json['sTotalPaidAmount'],
      remainingAmount: json['sRemainingAmount'],
      active: json['sActive'],
      status: json['bStatus'] != null
          ? int.parse(json['bStatus'].toString())
          : null,
      syncStatus: json['sSyncStatus'],
      entrySource: json['sEntrySource'],
      action: json['sAction'],
      createdDate: json['dtCreatedDate'] != null
          ? DateTime.parse(json['dtCreatedDate'])
          : null,
      addedBy: json['iAddedBy'] != null
          ? int.parse(json['iAddedBy'].toString())
          : null,
      updatedDate: json['dtUpdatedDate'] != null
          ? DateTime.parse(json['dtUpdatedDate'])
          : null,
      updatedBy: json['iUpdatedBy'] != null
          ? int.parse(json['iUpdatedBy'].toString())
          : null,
      deletedDate: json['dtDeletedDate'] != null
          ? DateTime.parse(json['dtDeletedDate'])
          : null,
      deletedBy: json['iDeletedBy'] != null
          ? int.parse(json['iDeletedBy'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iFirmID': firmID,
      'sFirmName': firmName,
      'sFirmInvoicePrefix': firmInvoicePrefix,
      'sFirmTA': firmTA,
      'sFirmGSTNO': firmGSTNO,
      'sFirmEmail': firmEmail,
      'sFirmPhone1': firmPhone1,
      'sFirmPhone2': firmPhone2,
      'sFirmMob1': firmMob1,
      'sFirmMob2': firmMob2,
      'sFirmAddress': firmAddress,
      'sFirmHomeAddress': firmHomeAddress,
      'sFirmTINNO': firmTINNO,
      'sFirmLogo': firmLogo,
      'sFirmWebsite': firmWebsite,
      'sFirmState': firmState,
      'sFirmCity': firmCity,
      'sFirmBranchName': firmBranchName,
      'sFirmBankAccountNo': firmBankAccountNo,
      'sFirmBankName': firmBankName,
      'sFirmBankCode': firmBankCode,
      'sFirmDetail': firmDetail,
      'sFirmBussinessType': firmBussinessType,
      'dtRegisteredDate': registeredDate?.toIso8601String(),
      'iSoftwarePackageID': softwarePackageID,
      'dtLicenseStartDate': licenseStartDate?.toIso8601String(),
      'dtLicenseEndDate': licenseEndDate?.toIso8601String(),
      'sRegistrationKey': registrationKey,
      'sTotalPaidAmount': totalPaidAmount,
      'sRemainingAmount': remainingAmount,
      'sActive': active,
      'bStatus': status,
      'sSyncStatus': syncStatus,
      'sEntrySource': entrySource,
      'sAction': action,
      'dtCreatedDate': createdDate?.toIso8601String(),
      'iAddedBy': addedBy,
      'dtUpdatedDate': updatedDate?.toIso8601String(),
      'iUpdatedBy': updatedBy,
      'dtDeletedDate': deletedDate?.toIso8601String(),
      'iDeletedBy': deletedBy,
    };
  }
}

class User {
  final int id;
  final int? iFirmID;
  final int iStoreID;
  final int? iUserTypeID;

  final String? firstname;
  final String? lastname;
  final String? sMobileNO;
  final String? sPhone;
  final String? sAddress;
  final String email;
  final String? username;
  final String passwordHash;
  final String? sUserImagePath;
  final String? sUserThumnailPath;
  final String? sUserSignature;
  final String? sUserThumnailSignature;
  final String? resetHash;
  final DateTime? resetAt;
  final DateTime? resetExpires;
  final String? activateHash;
  final String? status;
  final String? sSyncStatus;
  final String? sEntrySource;
  final String? sAction;
  final String? statusMessage;
  final int active;
  final int forcePassReset;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  User({
    required this.id,
    this.iFirmID,
    this.iStoreID = 0,
    this.iUserTypeID,
    this.firstname,
    this.lastname,
    this.sMobileNO,
    this.sPhone,
    this.sAddress,
    required this.email,
    this.username,
    required this.passwordHash,
    this.sUserImagePath,
    this.sUserThumnailPath,
    this.sUserSignature,
    this.sUserThumnailSignature,
    this.resetHash,
    this.resetAt,
    this.resetExpires,
    this.activateHash,
    this.status,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.statusMessage,
    this.active = 0,
    this.forcePassReset = 0,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      iFirmID: map['iFirmID'] != null
          ? int.tryParse(map['iFirmID'].toString())
          : null,
      iStoreID:
          map['iStoreID'] != null ? int.parse(map['iStoreID'].toString()) : 0,
      iUserTypeID: map['iUserTypeID'] != null
          ? int.tryParse(map['iUserTypeID'].toString())
          : null,
      firstname: map['firstname'],
      lastname: map['lastname'],
      sMobileNO: map['sMobileNO'],
      sPhone: map['sPhone'],
      sAddress: map['sAddress'],
      email: map['email'],
      username: map['username'],
      passwordHash: map['password_hash'] ?? '',
      sUserImagePath: map['sUserImagePath'],
      sUserThumnailPath: map['sUserThumnailPath'],
      sUserSignature: map['SUserSignature'],
      sUserThumnailSignature: map['SUserThumnailSignature'],
      resetHash: map['reset_hash'],
      resetAt:
          map['reset_at'] != null ? DateTime.tryParse(map['reset_at']) : null,
      resetExpires: map['reset_expires'] != null
          ? DateTime.tryParse(map['reset_expires'])
          : null,
      activateHash: map['activate_hash'],
      status: map['status'],
      sSyncStatus: map['sSyncStatus'],
      sEntrySource: map['sEntrySource'],
      sAction: map['sAction'],
      statusMessage: map['status_message'],
      active: map['active'] != null ? int.parse(map['active'].toString()) : 0,
      forcePassReset: map['force_pass_reset'] != null
          ? int.parse(map['force_pass_reset'].toString())
          : 0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.tryParse(map['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'iFirmID': iFirmID,
      'iStoreID': iStoreID,
      'iUserTypeID': iUserTypeID,
      'firstname': firstname,
      'lastname': lastname,
      'sMobileNO': sMobileNO,
      'sPhone': sPhone,
      'sAddress': sAddress,
      'email': email,
      'username': username,
      'password_hash': passwordHash,
      'sUserImagePath': sUserImagePath,
      'sUserThumnailPath': sUserThumnailPath,
      'SUserSignature': sUserSignature,
      'SUserThumnailSignature': sUserThumnailSignature,
      'reset_hash': resetHash,
      'reset_at': resetAt?.toIso8601String(),
      'reset_expires': resetExpires?.toIso8601String(),
      'activate_hash': activateHash,
      'status': status,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'status_message': statusMessage,
      'active': active,
      'force_pass_reset': forcePassReset,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      iFirmID: json['iFirmID'] != null
          ? int.tryParse(json['iFirmID'].toString())
          : null,
      iStoreID:
          json['iStoreID'] != null ? int.parse(json['iStoreID'].toString()) : 0,
      iUserTypeID: json['iUserTypeID'] != null
          ? int.tryParse(json['iUserTypeID'].toString())
          : null,
      firstname: json['firstname'],
      lastname: json['lastname'],
      sMobileNO: json['sMobileNO'],
      sPhone: json['sPhone'],
      sAddress: json['sAddress'],
      email: json['email'],
      username: json['username'],
      passwordHash: json['password_hash'] ?? '',
      sUserImagePath: json['sUserImagePath'],
      sUserThumnailPath: json['sUserThumnailPath'],
      sUserSignature: json['SUserSignature'],
      sUserThumnailSignature: json['SUserThumnailSignature'],
      resetHash: json['reset_hash'],
      resetAt:
          json['reset_at'] != null ? DateTime.tryParse(json['reset_at']) : null,
      resetExpires: json['reset_expires'] != null
          ? DateTime.tryParse(json['reset_expires'])
          : null,
      activateHash: json['activate_hash'],
      status: json['status'],
      sSyncStatus: json['sSyncStatus'],
      sEntrySource: json['sEntrySource'],
      sAction: json['sAction'],
      statusMessage: json['status_message'],
      active: json['active'] != null ? int.parse(json['active'].toString()) : 0,
      forcePassReset: json['force_pass_reset'] != null
          ? int.parse(json['force_pass_reset'].toString())
          : 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iFirmID': iFirmID,
      'iStoreID': iStoreID,
      'iUserTypeID': iUserTypeID,
      'firstname': firstname,
      'lastname': lastname,
      'sMobileNO': sMobileNO,
      'sPhone': sPhone,
      'sAddress': sAddress,
      'email': email,
      'username': username,
      'password_hash': passwordHash,
      'sUserImagePath': sUserImagePath,
      'sUserThumnailPath': sUserThumnailPath,
      'SUserSignature': sUserSignature,
      'SUserThumnailSignature': sUserThumnailSignature,
      'reset_hash': resetHash,
      'reset_at': resetAt?.toIso8601String(),
      'reset_expires': resetExpires?.toIso8601String(),
      'activate_hash': activateHash,
      'status': status,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'status_message': statusMessage,
      'active': active,
      'force_pass_reset': forcePassReset,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

class UserType {
  int iUserTypeID;
  int? iFirmID;
  String sUserType;
  bool bStatus;
  String? sSyncStatus;
  String? sEntrySource;
  String? sAction;
  DateTime? dtCreatedDate;
  int? iAddedBy;
  DateTime? dtUpdatedDate;
  int? iUpdatedBy;
  DateTime? dtDeletedDate;
  int? iDeletedBy;

  UserType({
    required this.iUserTypeID,
    this.iFirmID,
    required this.sUserType,
    required this.bStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      iUserTypeID: int.parse(json['iUserTypeID'].toString()),
      iFirmID: json['iFirmID'] != null
          ? int.tryParse(json['iFirmID'].toString())
          : null,
      sUserType: json['sUserType'],
      bStatus: json['bStatus'] == 1,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iUserTypeID': iUserTypeID,
      'iFirmID': iFirmID,
      'sUserType': sUserType,
      'bStatus': bStatus ? 1 : 0,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
    };
  }

  factory UserType.fromMap(Map<String, dynamic> map) {
    return UserType(
      iUserTypeID: map['iUserTypeID'],
      iFirmID: map['iFirmID'],
      sUserType: map['sUserType'],
      bStatus: map['bStatus'] == 1,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iUserTypeID': iUserTypeID,
      'iFirmID': iFirmID,
      'sUserType': sUserType,
      'bStatus': bStatus ? 1 : 0,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
    };
  }
}

class Store {
  int iStoreID;
  int? iFirmID;
  int? iCityID;
  int? iSystemUserID;
  String? sName;
  String? sCode;
  bool? bStatus;
  String? sSyncStatus;
  String? sEntrySource;
  String? sAction;
  DateTime? dtCreatedDate;
  int? iAddedBy;
  DateTime? dtUpdatedDate;
  int? iUpdatedBy;
  DateTime? dtDeletedDate;
  int? iDeletedBy;

  Store({
    required this.iStoreID,
    this.iFirmID,
    this.iCityID,
    required this.iSystemUserID,
    this.sName,
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
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      iStoreID: int.parse(json['iStoreID'].toString()),
      iFirmID: json['iFirmID'] != null
          ? int.tryParse(json['iFirmID'].toString())
          : null,

      // int.parse(map['iCityID'].toString()),iSystemUserID
      iCityID: json['iCityID'] != null
          ? int.tryParse(json['iCityID'].toString())
          : null,
      iSystemUserID: json['iSystemUserID'] != null
          ? int.tryParse(json['iSystemUserID'].toString())
          : null,
      sName: json['sName'],
      sCode: json['sCode'],
      bStatus: json['bStatus'] == 1,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iStoreID': iStoreID,
      'iFirmID': iFirmID,
      'iCityID': iCityID,
      'iSystemUserID': iSystemUserID,
      'sName': sName,
      'sCode': sCode,
      'bStatus': bStatus == true ? 1 : 0,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      iStoreID: map['iStoreID'],
      iFirmID: map['iFirmID'],
      iCityID: map['iCityID'],
      iSystemUserID: map['iSystemUserID'],
      sName: map['sName'],
      sCode: map['sCode'],
      bStatus: map['bStatus'] == 1,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iStoreID': iStoreID,
      'iFirmID': iFirmID,
      'iCityID': iCityID,
      'iSystemUserID': iSystemUserID,
      'sName': sName,
      'sCode': sCode,
      'bStatus': bStatus == true ? 1 : 0,
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
    };
  }
}

class ProductCompany {
  final int iProductCompanyID;
  final int iSystemUserID;
  final int? iFirmID;
  final String sCompanyName;
  final String? sCode;
  final String? sAddress;
  final String? sPhone;
  final String? sMobile;
  final bool? bStatus;
  final String? sSyncStatus;
  final String? sEntrySource;
  final String? sAction;
  final String? sDescription;
  final DateTime? dtCreatedDate;
  final int? iAddedBy;
  final DateTime? dtUpdatedDate;
  final int? iUpdatedBy;
  final DateTime? dtDeletedDate;
  final int? iDeletedBy;
  final int? iStoreID;

  ProductCompany({
    required this.iProductCompanyID,
    required this.iSystemUserID,
    this.iFirmID,
    required this.sCompanyName,
    this.sCode,
    this.sAddress,
    this.sPhone,
    this.sMobile,
    this.bStatus,
    this.sSyncStatus,
    this.sEntrySource,
    this.sAction,
    this.sDescription,
    this.dtCreatedDate,
    this.iAddedBy,
    this.dtUpdatedDate,
    this.iUpdatedBy,
    this.dtDeletedDate,
    this.iDeletedBy,
    this.iStoreID,
  });

  factory ProductCompany.fromJson(Map<String, dynamic> json) {
    return ProductCompany(
      iProductCompanyID: int.parse(json['iProductCompanyID']),
      iSystemUserID: int.parse(json['iSystemUserID']),
      iFirmID: json['iFirmID'] != null ? int.tryParse(json['iFirmID']) : null,
      sCompanyName: json['sCompanyName'],
      sCode: json['sCode'],
      sAddress: json['sAddress'],
      sPhone: json['sPhone'],
      sMobile: json['sMobile'],
      bStatus: json['bStatus'] == "1", // Convert string "1" to bool true
      sSyncStatus: json['sSyncStatus'],
      sEntrySource: json['sEntrySource'],
      sAction: json['sAction'],
      sDescription: json['sDescription'],
      dtCreatedDate: json['dtCreatedDate'] != null
          ? DateTime.parse(json['dtCreatedDate'])
          : null,
      iAddedBy:
          json['iAddedBy'] != null ? int.tryParse(json['iAddedBy']) : null,
      dtUpdatedDate: json['dtUpdatedDate'] != null
          ? DateTime.parse(json['dtUpdatedDate'])
          : null,
      iUpdatedBy:
          json['iUpdatedBy'] != null ? int.tryParse(json['iUpdatedBy']) : null,
      dtDeletedDate: json['dtDeletedDate'] != null
          ? DateTime.parse(json['dtDeletedDate'])
          : null,
      iDeletedBy:
          json['iDeletedBy'] != null ? int.tryParse(json['iDeletedBy']) : null,
      iStoreID:
          json['iStoreID'] != null ? int.tryParse(json['iStoreID']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iProductCompanyID': iProductCompanyID,
      'iSystemUserID': iSystemUserID,
      'iFirmID': iFirmID,
      'sCompanyName': sCompanyName,
      'sCode': sCode,
      'sAddress': sAddress,
      'sPhone': sPhone,
      'sMobile': sMobile,
      'bStatus': bStatus == true ? "1" : "0", // Store bool as string "1" or "0"
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'sDescription': sDescription,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
      'iStoreID': iStoreID,
    };
  }
}

class ProductGrouping {
  final int iProductGroupID;
  final String sGroupName;
  final String? sCode;
  final String? sActive;
  final bool? bStatus;
  final String? sSyncStatus;
  final String? sEntrySource;
  final String? sAction;
  final DateTime? dtCreatedDate;
  final int? iAddedBy;
  final DateTime? dtUpdatedDate;
  final int? iUpdatedBy;
  final DateTime? dtDeletedDate;
  final int? iDeletedBy;

  ProductGrouping({
    required this.iProductGroupID,
    required this.sGroupName,
    this.sCode,
    this.sActive,
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
  });

  factory ProductGrouping.fromJson(Map<String, dynamic> json) {
    return ProductGrouping(
      iProductGroupID: int.parse(json['iProductGroupID']),
      sGroupName: json['sGroupName'],
      sCode: json['sCode'],
      sActive: json['sActive'],
      bStatus: json['bStatus'] == "1", // Convert string "1" to bool true
      sSyncStatus: json['sSyncStatus'],
      sEntrySource: json['sEntrySource'],
      sAction: json['sAction'],
      dtCreatedDate: json['dtCreatedDate'] != null
          ? DateTime.parse(json['dtCreatedDate'])
          : null,
      iAddedBy:
          json['iAddedBy'] != null ? int.tryParse(json['iAddedBy']) : null,
      dtUpdatedDate: json['dtUpdatedDate'] != null
          ? DateTime.parse(json['dtUpdatedDate'])
          : null,
      iUpdatedBy:
          json['iUpdatedBy'] != null ? int.tryParse(json['iUpdatedBy']) : null,
      dtDeletedDate: json['dtDeletedDate'] != null
          ? DateTime.parse(json['dtDeletedDate'])
          : null,
      iDeletedBy:
          json['iDeletedBy'] != null ? int.tryParse(json['iDeletedBy']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iProductGroupID': iProductGroupID,
      'sGroupName': sGroupName,
      'sCode': sCode,
      'sActive': sActive,
      'bStatus': bStatus == true ? "1" : "0", // Store bool as string "1" or "0"
      'sSyncStatus': sSyncStatus,
      'sEntrySource': sEntrySource,
      'sAction': sAction,
      'dtCreatedDate': dtCreatedDate?.toIso8601String(),
      'iAddedBy': iAddedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'iUpdatedBy': iUpdatedBy,
      'dtDeletedDate': dtDeletedDate?.toIso8601String(),
      'iDeletedBy': iDeletedBy,
    };
  }
}

class Product {
  final int iProductID;
  final int? iSystemUserID;
  final int? iFirmID;
  final int? isProductCompanyID;
  final int? isProductGroupID;
  final int? isTaxcodeID;
  final int? isExtraChargesID;
  final String sProductName;
  final String? sProductLocation;
  final String? sCode;
  final String? sBarCode;
  final int? iBaseUnit;
  final int? iSecondaryUnit;
  final String? sPeacePerSize;
  final String? sTotalPeace;
  final String? sTotalUnitSize;
  final String? sWhatSecUnitIs;
  final double? dcPurcasePerBaseUnitPrice;
  final double? dcPurchasePerSecondaryUnitPrice;
  final double? dcDellerSalePerBaseUnitPrice;
  final double? dcDellerSalePerSecondaryUnitPrice;
  final double? dcSalePerBaseUnitPrice;
  final double? dSalePerSecondaryUnitPrice;
  final String? sProductImage;
  final String? sImageThumbnail;
  final String? sOpeningStockBaseUnit;
  final String? sOpeningStockSecondaryUnit;
  final String? sOpeningStockPurchaseAt;
  final String? sTotalBaseUnitStockQty;
  final String? sTotalSecondaryUnitStockQty;
  final String? sTotalBaseUnitPurchaseValue;
  final String? sTotalSecondaryUnitPurchaseValue;
  final String? sProducttype;
  final String? sBaseUnitProfitRatio;
  final String? sSecondaryUnitProfitRatio;
  final String? sTotalBaseUnitAvgPP;
  final String? sTotalSecUnitAvgPP;
  final String? sBonusRecivedStockInBaseUnit;
  final String? sBonusRecivedStockInSecondaryUnit;
  final String? sTotalBonusGivenStockOutInBaseUnit;
  final String? sTotalBonusGivenStockOutInSecUnit;
  final String? sTotalStockWithBonusInBaseUnitQty;
  final String? sTotalStockWithBonusInSecUnitQty;
  final bool? bStatus;
  final String? sSyncStatus;
  final String? sEntrySource;
  final String? sAction;
  final DateTime? dtCreatedDate;
  final int? iAddedBy;
  final DateTime? dtUpdatedDate;
  final int? iUpdatedBy;
  final DateTime? dtDeletedDate;
  final int? iDeletedBy;
  final int? iStoreID;

  Product({
    required this.iProductID,
    this.iSystemUserID,
    this.iFirmID,
    this.isProductCompanyID,
    this.isProductGroupID,
    this.isTaxcodeID,
    this.isExtraChargesID,
    required this.sProductName,
    this.sProductLocation,
    this.sCode,
    this.sBarCode,
    this.iBaseUnit,
    this.iSecondaryUnit,
    this.sPeacePerSize,
    this.sTotalPeace,
    this.sTotalUnitSize,
    this.sWhatSecUnitIs,
    this.dcPurcasePerBaseUnitPrice,
    this.dcPurchasePerSecondaryUnitPrice,
    this.dcDellerSalePerBaseUnitPrice,
    this.dcDellerSalePerSecondaryUnitPrice,
    this.dcSalePerBaseUnitPrice,
    this.dSalePerSecondaryUnitPrice,
    this.sProductImage,
    this.sImageThumbnail,
    this.sOpeningStockBaseUnit,
    this.sOpeningStockSecondaryUnit,
    this.sOpeningStockPurchaseAt,
    this.sTotalBaseUnitStockQty,
    this.sTotalSecondaryUnitStockQty,
    this.sTotalBaseUnitPurchaseValue,
    this.sTotalSecondaryUnitPurchaseValue,
    this.sProducttype,
    this.sBaseUnitProfitRatio,
    this.sSecondaryUnitProfitRatio,
    this.sTotalBaseUnitAvgPP,
    this.sTotalSecUnitAvgPP,
    this.sBonusRecivedStockInBaseUnit,
    this.sBonusRecivedStockInSecondaryUnit,
    this.sTotalBonusGivenStockOutInBaseUnit,
    this.sTotalBonusGivenStockOutInSecUnit,
    this.sTotalStockWithBonusInBaseUnitQty,
    this.sTotalStockWithBonusInSecUnitQty,
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
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      iProductID: int.parse(json['iProductID']),
      iSystemUserID: json['iSystemUserID'] != null
          ? int.tryParse(json['iSystemUserID'])
          : null,
      iFirmID: json['iFirmID'] != null ? int.tryParse(json['iFirmID']) : null,
      isProductCompanyID: json['isProductCompanyID'] != null
          ? int.tryParse(json['isProductCompanyID'])
          : null,
      isProductGroupID: json['isProductGroupID'] != null
          ? int.tryParse(json['isProductGroupID'])
          : null,
      isTaxcodeID: json['isTaxcodeID'] != null
          ? int.tryParse(json['isTaxcodeID'])
          : null,
      isExtraChargesID: json['isExtraChargesID'] != null
          ? int.tryParse(json['isExtraChargesID'])
          : null,
      sProductName: json['sProductName'],
      sProductLocation: json['sProductLocation'],
      sCode: json['sCode'],
      sBarCode: json['sBarCode'],
      iBaseUnit:
          json['iBaseUnit'] != null ? int.tryParse(json['iBaseUnit']) : null,
      iSecondaryUnit: json['iSecondaryUnit'] != null
          ? int.tryParse(json['iSecondaryUnit'])
          : null,
      sPeacePerSize: json['sPeacePerSize'],
      sTotalPeace: json['sTotalPeace'],
      sTotalUnitSize: json['sTotalUnitSize'],
      sWhatSecUnitIs: json['sWhatSecUnitIs'],
      dcPurcasePerBaseUnitPrice: json['dcPurcasePerBaseUnitPrice'] != null
          ? double.tryParse(json['dcPurcasePerBaseUnitPrice'])
          : null,
      dcPurchasePerSecondaryUnitPrice:
          json['dcPurchasePerSecondaryUnitPrice'] != null
              ? double.tryParse(json['dcPurchasePerSecondaryUnitPrice'])
              : null,
      dcDellerSalePerBaseUnitPrice: json['dcDellerSalePerBaseUnitPrice'] != null
          ? double.tryParse(json['dcDellerSalePerBaseUnitPrice'])
          : null,
      dcDellerSalePerSecondaryUnitPrice:
          json['dcDellerSalePerSecondaryUnitPrice'] != null
              ? double.tryParse(json['dcDellerSalePerSecondaryUnitPrice'])
              : null,
      dcSalePerBaseUnitPrice: json['dcSalePerBaseUnitPrice'] != null
          ? double.tryParse(json['dcSalePerBaseUnitPrice'])
          : null,
      dSalePerSecondaryUnitPrice: json['dSalePerSecondaryUnitPrice'] != null
          ? double.tryParse(json['dSalePerSecondaryUnitPrice'])
          : null,
      sProductImage: json['sProduct_image'],
      sImageThumbnail: json['sImage_Thumbnail'],
      sOpeningStockBaseUnit: json['sOpeningStockBaseUnit'],
      sOpeningStockSecondaryUnit: json['sOpeningStockSecondaryUnit'],
      sOpeningStockPurchaseAt: json['sOpeningStockPurchase_At'],
      sTotalBaseUnitStockQty: json['sTotalBaseUnitStockQty'],
      sTotalSecondaryUnitStockQty: json['sTotalSecondaryUnitStockQty'],
      sTotalBaseUnitPurchaseValue: json['sTotalBaseUnitPurchaseValue'],
      sTotalSecondaryUnitPurchaseValue:
          json['sTotalSecondaryUnitPurchaseValue'],
      sProducttype: json['sProducttype'],
      sBaseUnitProfitRatio: json['sBaseUnitProfitRatio'],
      sSecondaryUnitProfitRatio: json['sSecoundaryUnitProfitRatio'],
      sTotalBaseUnitAvgPP: json['sTotalBaseUnitAvgPP'],
      sTotalSecUnitAvgPP: json['sTotalSecUnitAvgPP'],
      sBonusRecivedStockInBaseUnit: json['sBonusRecivedStockInBaseUnit'],
      sBonusRecivedStockInSecondaryUnit:
          json['sBonusRecivedStockInSecondaryUnit'],
      sTotalBonusGivenStockOutInBaseUnit:
          json['sTotalBonusGivenStockOutInBaseUnit'],
      sTotalBonusGivenStockOutInSecUnit:
          json['sTotalBonusGivenStockOutInSecUnit'],
      sTotalStockWithBonusInBaseUnitQty:
          json['sTotalStockWithBonusInBaseUnitQty'],
      sTotalStockWithBonusInSecUnitQty:
          json['sTotalStockWithBonusInSecUnitQty'],
      bStatus: json['bStatus'] == "1", // Convert string "1" to bool true
      sSyncStatus: json['sSyncStatus'],
      sEntrySource: json['sEntrySource'],
      sAction: json['sAction'],
      dtCreatedDate: json['dtCreatedDate'] != null
          ? DateTime.tryParse(json['dtCreatedDate'])
          : null,
      iAddedBy:
          json['iAddedBy'] != null ? int.tryParse(json['iAddedBy']) : null,
      dtUpdatedDate: json['dtUpdatedDate'] != null
          ? DateTime.tryParse(json['dtUpdatedDate'])
          : null,
      iUpdatedBy:
          json['iUpdatedBy'] != null ? int.tryParse(json['iUpdatedBy']) : null,
      dtDeletedDate: json['dtDeletedDate'] != null &&
              json['dtDeletedDate'] != "0000-00-00 00:00:00"
          ? DateTime.tryParse(json['dtDeletedDate'])
          : null,
      iDeletedBy:
          json['iDeletedBy'] != null ? int.tryParse(json['iDeletedBy']) : null,
      iStoreID:
          json['iStoreID'] != null ? int.tryParse(json['iStoreID']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iProductID': iProductID,
      'iSystemUserID': iSystemUserID,
      'iFirmID': iFirmID,
      'isProductCompanyID': isProductCompanyID,
      'isProductGroupID': isProductGroupID,
      'isTaxcodeID': isTaxcodeID,
      'isExtraChargesID': isExtraChargesID,
      'sProductName': sProductName,
      'sProductLocation': sProductLocation,
      'sCode': sCode,
      'sBarCode': sBarCode,
      'iBaseUnit': iBaseUnit,
      'iSecondaryUnit': iSecondaryUnit,
      'sPeacePerSize': sPeacePerSize,
      'sTotalPeace': sTotalPeace,
      'sTotalUnitSize': sTotalUnitSize,
      'sWhatSecUnitIs': sWhatSecUnitIs,
      'dcPurcasePerBaseUnitPrice': dcPurcasePerBaseUnitPrice,
      'dcPurchasePerSecondaryUnitPrice': dcPurchasePerSecondaryUnitPrice,
      'dcDellerSalePerBaseUnitPrice': dcDellerSalePerBaseUnitPrice,
      'dcDellerSalePerSecondaryUnitPrice': dcDellerSalePerSecondaryUnitPrice,
      'dcSalePerBaseUnitPrice': dcSalePerBaseUnitPrice,
      'dSalePerSecondaryUnitPrice': dSalePerSecondaryUnitPrice,
      'sProduct_image': sProductImage,
      'sImage_Thumbnail': sImageThumbnail,
      'sOpeningStockBaseUnit': sOpeningStockBaseUnit,
      'sOpeningStockSecondaryUnit': sOpeningStockSecondaryUnit,
      'sOpeningStockPurchase_At': sOpeningStockPurchaseAt,
      'sTotalBaseUnitStockQty': sTotalBaseUnitStockQty,
      'sTotalSecondaryUnitStockQty': sTotalSecondaryUnitStockQty,
      'sTotalBaseUnitPurchaseValue': sTotalBaseUnitPurchaseValue,
      'sTotalSecondaryUnitPurchaseValue': sTotalSecondaryUnitPurchaseValue,
      'sProducttype': sProducttype,
      'sBaseUnitProfitRatio': sBaseUnitProfitRatio,
      'sSecoundaryUnitProfitRatio': sSecondaryUnitProfitRatio,
      'sTotalBaseUnitAvgPP': sTotalBaseUnitAvgPP,
      'sTotalSecUnitAvgPP': sTotalSecUnitAvgPP,
      'sBonusRecivedStockInBaseUnit': sBonusRecivedStockInBaseUnit,
      'sBonusRecivedStockInSecondaryUnit': sBonusRecivedStockInSecondaryUnit,
      'sTotalBonusGivenStockOutInBaseUnit': sTotalBonusGivenStockOutInBaseUnit,
      'sTotalBonusGivenStockOutInSecUnit': sTotalBonusGivenStockOutInSecUnit,
      'sTotalStockWithBonusInBaseUnitQty': sTotalStockWithBonusInBaseUnitQty,
      'sTotalStockWithBonusInSecUnitQty': sTotalStockWithBonusInSecUnitQty,
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
      'iStoreID': iStoreID,
    };
  }
}

class AuthPermission {
  final int id;
  final String name;
  final String? description;

  AuthPermission({
    required this.id,
    required this.name,
    this.description,
  });

  factory AuthPermission.fromMap(Map<String, dynamic> map) {
    return AuthPermission(
      id: int.parse(map['id'].toString()), // Primary Key
      name: map['name'], // Required field
      description: map['description'], // Nullable field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Primary Key
      'name': name, // Required field
      'description': description, // Nullable field
    };
  }

  factory AuthPermission.fromJson(Map<String, dynamic> json) {
    return AuthPermission(
      id: int.parse(json['id'].toString()), // Primary Key
      name: json['name'], // Required field
      description: json['description'], // Nullable field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Primary Key
      'name': name, // Required field
      'description': description, // Nullable field
    };
  }
}
