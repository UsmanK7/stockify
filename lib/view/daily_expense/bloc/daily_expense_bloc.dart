import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:http/http.dart' as http;

import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/view/daily_expense/bloc/daily_expense_event.dart';
import 'package:okra_distributer/view/daily_expense/bloc/daily_expense_state.dart';

class DailyExpenseBloc extends Bloc<DailyExpenseEvent, DailyExpenseState> {
  DailyExpenseBloc() : super(DailyExpenseInitialState()) {
    on<AddDailyExpenseEvent>(addDailyExpenseEvent);
  }

  FutureOr<void> addDailyExpenseEvent(
      AddDailyExpenseEvent event, Emitter<DailyExpenseState> emit) async {
    emit(DailyExpenseLoadingState());
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    // Convert DailyExpense object to a map for insertion
    final dailyExpense = event.dailyExpense;
    final values = {
      'iExpenseTypeID': dailyExpense.iExpenseTypeID ?? 00,
      'iBankID': dailyExpense.iBankID ?? 00,
      'iTableID': dailyExpense.iTableID ?? 00,
      'sTableName': dailyExpense.sTableName ?? 00,
      'sExpenseFor': dailyExpense.sExpenseFor ?? '00',
      'sVocherNo': dailyExpense.sVocherNo ?? '00',
      'sVocherScanImagePath': dailyExpense.sVocherScanImagePath ?? '',
      'dcAmount': dailyExpense.dcAmount ?? 00,
      'sDescription': dailyExpense.sDescription ?? '00',
      'iFirmID': dailyExpense.iFirmID ?? 00,
      'iSystemUserID': dailyExpense.iSystemUserID ?? 00,
      'dDate': dailyExpense.dDate ?? '00',
      'sEtc': dailyExpense.sEtc ?? '00',
      'bStatus': dailyExpense.bStatus ?? '00',
      'sSyncStatus': dailyExpense.sSyncStatus ?? 00,
      'sEntrySource': dailyExpense.sEntrySource ?? 00,
      'sAction': dailyExpense.sAction ?? '00',
      'dtCreatedDate': dailyExpense.dtCreatedDate ?? '00',
      'iAddedBy': dailyExpense.iAddedBy ?? 00,
      'dtUpdatedDate': dailyExpense.dtUpdatedDate ?? '00',
      'iUpdatedBy': dailyExpense.iUpdatedBy ?? '00',
      'dtDeletedDate': dailyExpense.dtDeletedDate ?? '00',
      'iDeletedBy': dailyExpense.iDeletedBy ?? 00,
      'iStoreID': dailyExpense.iStoreID ?? 00,
      'transaction_id': dailyExpense.transactionId ?? '00',
    };

    // Insert into the 'daily_expense' table
    await db.insert(
      'daily_expense',
      values,
    );

    var result = await db
        .rawQuery('SELECT MAX(iDailyExpenseID) as lastID FROM daily_expense');
    final lastid = result.first['lastID'];

    // API CALL
    final Uri url = Uri.parse(addDailyExpenseUrl);
    final _box = GetStorage();
    // final iFirmID = _box.read('iFirmID');
    // final iSystemUserID = _box.read('iSystemUserID');
    final authorization_token = _box.read('token');
    final body = {
      'authorization_token': authorization_token,
      'iDailyExpenseID': lastid,
      'iExpenseTypeID': dailyExpense.iExpenseTypeID ?? 00,
      'iBankID': dailyExpense.iBankID ?? 00,
      'iTableID': dailyExpense.iTableID ?? 00,
      'sTableName': dailyExpense.sTableName ?? 00,
      'sExpenseFor': dailyExpense.sExpenseFor ?? '00',
      'sVocherNo': dailyExpense.sVocherNo ?? '00',
      'sVocherScanImagePath': dailyExpense.sVocherScanImagePath ?? '00',
      'dcAmount': dailyExpense.dcAmount ?? 00,
      'sDescription': dailyExpense.sDescription ?? '00',
      'iFirmID': dailyExpense.iFirmID ?? 00,
      'iSystemUserID': dailyExpense.iSystemUserID ?? 00,
      'dDate': dailyExpense.dDate ?? '00',
      'sEtc': dailyExpense.sEtc ?? '00',
      'bStatus': dailyExpense.bStatus ?? '00',
      'sSyncStatus': dailyExpense.sSyncStatus ?? 00,
      'sEntrySource': dailyExpense.sEntrySource ?? 00,
      'sAction': dailyExpense.sAction ?? '00',
      'dtCreatedDate': dailyExpense.dtCreatedDate ?? '00',
      'iAddedBy': dailyExpense.iAddedBy ?? 00,
      'dtUpdatedDate': dailyExpense.dtUpdatedDate ?? '00',
      'iUpdatedBy': dailyExpense.iUpdatedBy ?? '00',
      'dtDeletedDate': dailyExpense.dtDeletedDate ?? '00',
      'iDeletedBy': dailyExpense.iDeletedBy ?? 00,
      'iStoreID': dailyExpense.iStoreID ?? 00,
      'transaction_id': dailyExpense.transactionId ?? '00',
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.statusCode);
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('error')) {
        print(jsonResponse['faced error']);

        // emit(InitialAuthState());
      } else if (jsonResponse.containsKey('success')) {
        final transaction_id = await jsonResponse['transaction_id'];

        await db.update(
          'daily_expense',
          {
            'sSyncStatus': 1,
            'transaction_id': transaction_id.toString(),
          },
          where: 'iDailyExpenseID = ?',
          whereArgs: [lastid],
        );
      }
    } else {
      print("Erorr: ${response.statusCode}");
      print("Error body: ${response.body}");
    }

    emit(DailyExpenseAddedState());
  }
}
