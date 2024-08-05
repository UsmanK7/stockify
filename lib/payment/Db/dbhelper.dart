import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await initDb();
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "stockfiy.db");

    // Check if the database exists
    final exist = await databaseExists(path);

    if (!exist) {
      // Create a new database or copy the pre-populated database
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load(join("assets", "stockfiy.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print("Database copied");
      await clearAllData();
      await insertRandomNumber();
    } else {
      // If the database exists, clear all data
    }

    // Open the database
    _database = await openDatabase(path);
    return _database!;
  }

  //For creating app id

//   Future<void> insertRandomNumber() async {
//     final db = await database;
//     final randomNumber = generateRandomNumber();

//     await db.insert('app', {'app_id': randomNumber});
//     print("Random number $randomNumber inserted into the database.");
//   }

//   int generateRandomNumber({int min = 1000, int max = 9999}) {
//     final random = Random();
//     return min + random.nextInt(max - min + 1);
//   }
// }

  // Method to delete all data from all tables
  Future<void> clearAllData() async {
    final db = await database;

    // List of tables to clear
    final tables = [
      'product',
      'product_company',
      'product_grouping',
      'user_type',
      'users',
      'firm_setting',
      'area',
      'city',
      'country_state',
      'country',
      'permanent_customer',
    ];

    for (var table in tables) {
      try {
        int count = await db.rawDelete('DELETE FROM $table');
        print("All data from $table has been deleted. Rows affected: $count");
      } catch (e) {
        print("Error clearing table $table: $e");
      }
    }

    // Optional: Reclaim disk space
    await db.execute('VACUUM');
    print("Database has been vacuumed.");
  }

  Future<void> insertRandomNumber() async {
    final db = await database;
    final randomNumber = generateRandomNumber();

    await db.insert('app', {'app_id': randomNumber});
    print("Random number $randomNumber inserted into the database.");
  }

  int generateRandomNumber({int min = 1000, int max = 9999}) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  Future<List<Country>> getCountries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('country');
    return List.generate(maps.length, (i) {
      return Country.fromMap(maps[i]);
    });
  }

  Future<int?> getUserId() async {
    final db = await DBHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['id'],
      limit: 1,
    );

    if (result.isNotEmpty) {
      print("Fetched user ID: ${result.first['id']}");
      return result.first['id'] as int;
    } else {
      print("No user data found in the database.");
    }
    return null;
  }

  Future<List<States>> getStates(int countryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('country_state',
        where: 'iCountryID = ?', whereArgs: [countryId]);
    return List.generate(maps.length, (i) {
      return States.fromMap(maps[i]);
    });
  }

  // getting app id
  Future<int?> getAppId() async {
    final db = await database;
    List<Map<String, dynamic>> ressult = await db.query('app');
    if (ressult.isNotEmpty) {
      return ressult.first['app_id'] as int;
    }
  }

  Future<List<City>> getCities(int stateId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('city', where: 'iCountryStateID = ?', whereArgs: [stateId]);
    return List.generate(maps.length, (i) {
      return City.fromMap(maps[i]);
    });
  }

  Future<List<Area>> getAreas(int cityId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('area', where: 'iCityID = ?', whereArgs: [cityId]);
    return List.generate(maps.length, (i) {
      return Area.fromMap(maps[i]);
    });
  }

  Future<List<Customer>> getCustomerByArea(int areaId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('permanent_customer', where: 'iAreaID=?', whereArgs: [areaId]);
    print("Query result: $maps");
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }

  Future<List<Bank>> getBanks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bank');
    return List.generate(maps.length, (i) {
      return Bank.fromMap(maps[i]);
    });
  }

  Future<int> insertPermanentCustomerPayment(
      PermanentCustomerPayment payment) async {
    print('Inserting payment into database...');
    final db = await this.database;
    int? result =
        await db!.insert('permanent_customer_payments', payment.toMap());
    print('Payment inserted with ID: $result');

    var checkQuery = await db.query(
      'permanent_customer_payments',
      where: 'iPermanentCustomerPaymentsID =?',
      whereArgs: [result],
    );
    print('Payment details: $checkQuery');

    return result;
  }

  Future<List<PermanentCustomerPayment>> getPermanentCustomerPayments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT 
      pcp.iPermanentCustomerPaymentsID,
      pcp.iPermanentCustomerID,
      c.sName AS customerName,
      pcp.iBankID,
      pcp.iSystemUserID,
      pcp.iEmployeeID,
      pcp.iFirmID,
      pcp.iTableID,
      pcp.sTableName,
      pcp.dcPaidAmount,
      pcp.sBank,
      pcp.sCheckNumber,
      pcp.sInvoiceNo,
      pcp.sDescription,
      pcp.sSyncStatus,
      pcp.sEntrySource,
      pcp.sAction,
      pcp.dDate,
      pcp.dtCreatedDate,
      pcp.bStatus,
      pcp.iAddedBy,
      pcp.dtUpdatedDate,
      pcp.iUpdatedBy,
      pcp.dtDeletedDate,
      pcp.iDeletedBy
    FROM permanent_customer_payments pcp
    LEFT JOIN permanent_customer c ON pcp.iPermanentCustomerID = c.iPermanentCustomerID
  ''');
    print('Maps: $maps');
    return List.generate(maps.length, (i) {
      return PermanentCustomerPayment.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getAllPermanentCustomerPayments() async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('permanent_customer_payments');
    print('All payments: $results');
    await db.execute('VACUUM');
    return results;
  }

  Future<void> insertSalesmanLocation(SalesmanLocation location) async {
    final db = await database;
    await db.insert('salesman_location', location.toMap());
    print('Location inserted: $location');
  }

  Future<void> printSalesmanLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('salesman_location');
    print('Salesman Locations: $maps');
  }

  ///--------------------testing will be removed -----------------///
  ///
  ///
  final tables = [
    'product',
    'product_grouping',
    'user_type',
    'users',
    'firm_setting',
    'area',
    'city',
    'country_state',
    'country',
    'permanent_customer',
  ];

  Future<void> firmTable() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    print('Tables : $maps');
  }

//-----------------------------------------------------/////
  Future<void> checkTableExists() async {
    final db = await database;
    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='salesman_location';");
    if (result.isNotEmpty) {
      print("Table exists: $result");
    } else {
      print("Table does not exist.");
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('permanent_customer');
    print("Query result for all customers: $maps");
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }

  Future<List<Customer>>? getallCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('permanent_customer');
    print("Query result for all customers: $maps");
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }

  Future<List<Bank>> getAllBanks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bank');
    print("Querry Resullt for all banks : $maps");
    return List.generate(maps.length, (i) {
      return Bank.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> fetchSaleDataByCustomerId(
      int customerId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%m', dSaleDate) AS dSaleDate,
      SUM(dcTotalBill) AS dcTotalBill
    FROM sale
    WHERE iPermanentCustomerID = ?
    GROUP BY strftime('%Y-%m', dSaleDate)
    ORDER BY strftime('%Y-%m', dSaleDate)
  ''', [customerId]);
  }

  Future<List<Map<String, dynamic>>> fetchPaymentDataByCustomerId(
      int customerId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%m', dDate) AS dDate,
      SUM(dcPaidAmount) AS dcPaidAmount
    FROM permanent_customer_payments
    WHERE iPermanentCustomerID = ?
    GROUP BY strftime('%Y-%m', dDate)
    ORDER BY strftime('%Y-%m', dDate)
  ''', [customerId]);
  }

  Future<int> updateFirmSetting(FirmSetting firmSetting) async {
    final db = await database;

    print(
        'Updating firm setting with ID: ${firmSetting.firmID} (${firmSetting.firmID.runtimeType})');
    print('Data to be updated: ${firmSetting.toJson()}');

    List<Map<String, dynamic>> existingFirmSettings = await db.query(
        'firm_setting',
        where: 'iFirmID = ?',
        whereArgs: [firmSetting.firmID]);

    if (existingFirmSettings.isNotEmpty) {
      final result = await db.update(
        'firm_setting',
        firmSetting.toJson(),
        where: 'iFirmID = ?',
        whereArgs: [firmSetting.firmID],
      );
      print('Firm setting updated');
    } else {
      final result = await db.insert('firm_setting', firmSetting.toJson());
      print('Firm setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> firmSettings = await db.query('firm_setting');
    print('All firm settings:');
    for (var firmSetting in firmSettings) {
      print('  ${firmSetting}');
    }

    return 0;
  }

  // Updating  User Type
  Future<int> updateUserType(UserType userType) async {
    final db = await database;

    print(
        'Updating UserType setting with ID: ${userType.iUserTypeID} (${userType.iUserTypeID.runtimeType})');
    print('Data to be updated: ${userType.toJson()}');

    List<Map<String, dynamic>> existingUserTypes = await db.query('user_type',
        where: 'iUserTypeID = ?', whereArgs: [userType.iUserTypeID]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'user_type',
        userType.toJson(),
        where: 'iUserTypeID = ?', // Fixed typo
        whereArgs: [userType.iUserTypeID],
      );
      print('UserType setting updated');
    } else {
      result = await db.insert('user_type', userType.toJson());
      print('UserType setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> allUserTypes = await db.query('user_type');
    print('All UserType settings:');
    for (var type in allUserTypes) {
      print('  $type');
    }

    return 0;
  }
  //Store List

  Future<int> updateStore(Store store) async {
    final db = await database;

    print(
        'Updating Store setting with ID: ${store.iStoreID} (${store.iStoreID.runtimeType})');
    print('Data to be updated: ${store.toJson()}');

    List<Map<String, dynamic>> existingUserTypes = await db
        .query('store', where: 'iStoreID = ?', whereArgs: [store.iStoreID]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'store',
        store.toJson(),
        where: 'iStoreID = ?', // Fixed typo
        whereArgs: [store.iStoreID],
      );
      print('Store setting updated');
    } else {
      result = await db.insert('store', store.toJson());
      print('Store setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> stores = await db.query('store');
    print('All UserType settings:');
    for (var type in stores) {
      print('  $type');
    }

    return 0;
  }

  //-------------------For Country-------------------//
  Future<int> updateCountry(Country country) async {
    final db = await database;

    print(
        'Updating country setting with ID: ${country.iCountryID} (${country.iCountryID.runtimeType})');
    print('Data to be updated: ${country.toJson()}');

    List<Map<String, dynamic>> existingUserTypes = await db.query('country',
        where: 'iCountryID = ?', whereArgs: [country.iCountryID]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'country',
        country.toJson(),
        where: 'iCountryID = ?', // Fixed typo
        whereArgs: [country.iCountryID],
      );
      print('country setting updated');
    } else {
      result = await db.insert('country', country.toJson());
      print('country setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> countries = await db.query('country');
    print('All Country settings:');
    for (var type in countries) {
      print('  $type');
    }

    return 0;
  }

  //--------------------For States ------------------////
  Future<int> updateState(States state) async {
    final db = await database;

    print(
        'Updating country setting with ID: ${state.id} (${state.id.runtimeType})');
    print('Data to be updated: ${state.toJson()}');

    List<Map<String, dynamic>> existingUserTypes = await db.query(
        'country_state',
        where: 'iCountryStateID = ?',
        whereArgs: [state.id]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'country_state',
        state.toJson(),
        where: 'iCountryStateID = ?', // Fixed typo
        whereArgs: [state.id],
      );
      print('country setting updated');
    } else {
      result = await db.insert('country_state', state.toJson());
      print('state setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> states = await db.query('country_state');
    print('All state settings:');
    for (var type in states) {
      print('  $type');
    }

    return 0;
  }

  //---For  cities ----------------//
  Future<int> updateCities(City city) async {
    final db = await database;

    print('Updating city setting with ID: ${city.id} (${city.id.runtimeType})');
    print('Data to be updated: ${city.toJson()}');

    List<Map<String, dynamic>> existingUserTypes =
        await db.query('city', where: 'iCityID = ?', whereArgs: [city.id]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'city',
        city.toJson(),
        where: 'iCityID = ?', // Fixed typo
        whereArgs: [city.id],
      );
      print('country setting updated');
    } else {
      result = await db.insert('city', city.toJson());
      print('city setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> cities = await db.query('city');
    print('All city settings:');
    for (var type in cities) {
      print('  $type');
    }

    return 0;
  }

  //-----For Areas --------------------------------------//
  Future<int> updateAreas(Area area) async {
    final db = await database;

    print('Updating area setting with ID: ${area.id} (${area.id.runtimeType})');
    print('Data to be updated: ${area.toJson()}');

    List<Map<String, dynamic>> existingUserTypes =
        await db.query('area', where: 'iAreaID = ?', whereArgs: [area.id]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'area',
        area.toJson(),
        where: 'iAreaID = ?', // Fixed typo
        whereArgs: [area.id],
      );
      print('country setting updated');
    } else {
      result = await db.insert('area', area.toJson());
      print('city setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> areas = await db.query('area');
    print('All city settings:');
    for (var type in areas) {
      print('  $type');
    }

    return 0;
  }

  //-------------------For Customer-------------------------------///////////
  Future<int> updateCustomer(Customer customer) async {
    final db = await database;

    print(
        'Updating permanent_customer setting with ID: ${customer.id} (${customer.id.runtimeType})');
    print('Data to be updated: ${customer.toJson()}');

    List<Map<String, dynamic>> existingUserTypes = await db.query(
        'permanent_customer',
        where: 'iPermanentCustomerID = ?',
        whereArgs: [customer.id]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'permanent_customer',
        customer.toJson(),
        where: 'iPermanentCustomerID = ?', // Fixed typo
        whereArgs: [customer.id],
      );
      print('permanent_customer setting updated');
    } else {
      result = await db.insert('permanent_customer', customer.toJson());
      print('city setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> areas = await db.query('permanent_customer');
    print('All permanent_customer settings:');
    for (var type in areas) {
      print('  $type');
    }

    return 0;
  }

  //For Product Companies

  Future<int> updateProductCompanies(ProductCompany pcomp) async {
    final db = await database;

    print(
        'Updating Store setting with ID: ${pcomp.iProductCompanyID} (${pcomp.iProductCompanyID.runtimeType})');
    print('Data to be updated: ${pcomp.toJson()}');

    List<Map<String, dynamic>> existingUserTypes = await db.query(
        'product_company',
        where: 'iProductCompanyID = ?',
        whereArgs: [pcomp.iStoreID]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'product_company',
        pcomp.toJson(),
        where: 'iProductCompanyID = ?', // Fixed typo
        whereArgs: [pcomp.iStoreID],
      );
      print('Store setting updated');
    } else {
      result = await db.insert('product_company', pcomp.toJson());
      print('Procduct comapny setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> pcompn = await db.query('product_company');
    print('All Product Company  settings:');
    for (var type in pcompn) {
      print('  $type');
    }

    return 0;
  }

  //For Company Grouping

  Future<int> updateProductComGrp(ProductGrouping pgrp) async {
    final db = await database;

    print(
        'Updating Store setting with ID: ${pgrp.iProductGroupID} (${pgrp.iProductGroupID.runtimeType})');
    print('Data to be updated: ${pgrp.toJson()}');

    List<Map<String, dynamic>> existingUserTypes = await db.query(
        'product_grouping',
        where: 'iProductGroupID = ?',
        whereArgs: [pgrp.iProductGroupID]);

    int result;
    if (existingUserTypes.isNotEmpty) {
      result = await db.update(
        'product_grouping',
        pgrp.toJson(),
        where: 'iProductGroupID = ?', // Fixed typo
        whereArgs: [pgrp.iProductGroupID],
      );
      print('product_grouping setting updated');
    } else {
      result = await db.insert('product_grouping', pgrp.toJson());
      print('product_grouping comapny setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> pgrpp = await db.query('product_grouping');
    print('All product_grouping Company  settings:');
    for (var type in pgrpp) {
      print('  $type');
    }

    return 0;
  }

  //-----------------For Products---------------------//
  Future<int> updateProducts(Product product) async {
    final db = await database;

    print(
        'Updating Store setting with ID: ${product.iProductID} (${product.iProductID.runtimeType})');
    print('Data to be updated: ${product.toJson()}');

    List<Map<String, dynamic>> existingProducts = await db.query('product',
        where: 'iProductID = ?', whereArgs: [product.iProductID]);

    int result;
    if (existingProducts.isNotEmpty) {
      result = await db.update(
        'product',
        product.toJson(),
        where: 'iProductID = ?', // Fixed typo
        whereArgs: [product.iProductID],
      );
      print('product setting updated');
    } else {
      result = await db.insert('product', product.toJson());
      print('product  setting inserted with ID: $result');
    }

    List<Map<String, dynamic>> prod = await db.query('product');
    print('All product   settings:');
    for (var type in prod) {
      print('  $type');
    }

    return 0;
  }

//UserSetting
  Future<int> updateUserSetting(User user) async {
    final db = await database;

    print('Updating user setting with ID: ${user.id}');
    print('Data to be updated: ${user.toJson()}');

    List<Map<String, dynamic>> existingUsers =
        await db.query('users', where: 'id = ?', whereArgs: [user.id]);

    if (existingUsers.isNotEmpty) {
      await db.update('users', user.toJson(),
          where: 'id = ?', whereArgs: [user.id]);
      print('User updated');
    } else {
      final result = await db.insert('users', user.toJson());
      print('User inserted with ID: $result');
    }

    // Print all entries in the users table
    List<Map<String, dynamic>> users = await db.query('users');
    print('All users:');
    for (var user in users) {
      print('  ${user}');
    }

    return 0;
  }

  Future<void> insertPermissions(List<AuthPermission> permissions) async {
    final db = await database;
    for (var permission in permissions) {
      try {
        await db.insert('auth_permissions', {
          'name': permission.name,
          'description': permission.description,
        });
        print(
            'Inserted permission: ${permission.name} - ${permission.description}');
      } catch (e) {
        print('Error inserting permission: $e');
      }
    }
  }
}
