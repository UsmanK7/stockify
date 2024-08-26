import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_event.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_state.dart';
import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';
import 'package:http/http.dart' as http;

import 'package:okra_distributer/view/sale_order/sale_order_list/model/sale_order_list_model.dart';

class SaleOrderListBloc extends Bloc<SaleOrderListEvent, SaleOrderListState> {
  SaleOrderListBloc() : super(SaleInitialState()) {
    on<SaleOrderListInitialEvent>(saleListInitialEvent);
    on<DailyExpenseTypeActionEvent>(dailyExpenseTypeActionEvent);
    on<SaleOrderListLastMonthEvent>(saleListLastMonthEvent);
    on<SaleOrderListThisMonthEvent>(saleListThisMonthEvent);
    on<DailyExpenseTypeDropdownChangeEvent>(
        dailyExpenseTypeDropdownChangeEvent);
    on<SaleOrderListThisWeekEvent>(saleListThisWeekEvent);
    on<SaleOrderListThisYearEvent>(saleListThisYearEvent);
    on<SaleOrderListThisQuarterEvent>(saleListThisQuarterEvent);
    on<SaleOrderListCustomDate>(saleListCustomDate);
    // on<SaleOrderListDismissEvent>(saleListDismissEvent);
    on<SaleOrderListDetailsEvent>(saleListDetailsEvent);
    on<DailyExpenseListSyncEvent>(dailyExpenseListSyncEvent);
  }
  FutureOr<void> dailyExpenseTypeDropdownChangeEvent(
      DailyExpenseTypeDropdownChangeEvent event,
      Emitter<SaleOrderListState> emit) async {
    if (event.FilterState.isEmpty) {
      DateTime current = DateTime.now();
      String currentDate = formatDate(current);
      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;

      List<Map<String, dynamic>> saleRows = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.iExpenseTypeID = ? AND de.dDate = ?
''', [event.iExpenseTypeID, currentDate]);

      emit(SuccessState(
          saleList: saleRows,
          firstDate: currentDate,
          lastDate: currentDate,
          expenseTypes: event.expenseTypes,
          selectedItem: event.selectedItem));
    } else if (event.FilterState == "This month") {
      DateTime firstDateOfLastMonth = getFirstDateOfThisMonth();
      DateTime lastDateOfLastMonth = getLastDateOfThisMonth();

      // Format dates to strings using the provided formatDate function
      String firstDateStr = formatDate(firstDateOfLastMonth);
      String lastDateStr = formatDate(lastDateOfLastMonth);

      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;

      // Query to fetch sales between the first and last dates of this month
      // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      //   SELECT s.*, pc.sName as customerName
      //   FROM sale_order s
      //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
      // ''', [firstDateStr, lastDateStr]);
      List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
    WHERE de.iExpenseTypeID = ? AND  de.dDate BETWEEN ? AND ?
''', [event.iExpenseTypeID, firstDateStr, lastDateStr]);

      // List to hold SaleListModel instances
      // List<SaleOrderListModel> salesList = [];
      // // Iterate over fetched rows and populate SaleListModel instances
      // saleRows.forEach((row) {
      //   salesList.add(SaleOrderListModel(
      //     saleId: row['iSaleOrderID'],
      //     sSyncStatus: row['sSyncStatus'],
      //     invoice_price: row['dcTotalBill'],

      //     customer_Name: row['customerName'],
      //     total_discount: row['dcTotalDiscount'],
      //     sale_date: row['dSaleOrderDate'], // Add the sale date
      //   ));
      // });
      // for (int i = 0; i < salesList.length; i++) {
      //   print(salesList[i].sale_date);
      // }

      emit(SuccessState(
          saleList: salesList,
          firstDate: firstDateStr,
          lastDate: lastDateStr,
          expenseTypes: event.expenseTypes,
          selectedItem: event.selectedItem));
    } else if (event.FilterState == "Last month") {
      DateTime firstDateOfLastMonth = getFirstDateOfLastMonth();
      DateTime lastDateOfLastMonth = getLastDateOfLastMonth();

      // Format dates to strings using the provided formatDate function
      String firstDateStr = formatDate(firstDateOfLastMonth);
      String lastDateStr = formatDate(lastDateOfLastMonth);

      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;

      // Query to fetch sales between the first and last dates of last month
      // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      //   SELECT s.*, pc.sName as customerName
      //   FROM sale_order s
      //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
      // ''', [firstDateStr, lastDateStr]);

      List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
 WHERE de.iExpenseTypeID = ? AND  de.dDate BETWEEN ? AND ?
''', [event.iExpenseTypeID, firstDateStr, lastDateStr]);

      // // List to hold SaleListModel instances
      // List<SaleOrderListModel> salesList = [];
      // // Iterate over fetched rows and populate SaleListModel instances
      // saleRows.forEach((row) {
      //   salesList.add(SaleOrderListModel(
      //     saleId: row['iSaleOrderID'],
      //     sSyncStatus: row['sSyncStatus'],
      //     invoice_price: row['dcTotalBill'],

      //     customer_Name: row['customerName'],
      //     total_discount: row['dcTotalDiscount'],
      //     sale_date: row['dSaleOrderDate'], // Add the sale date
      //   ));
      // });
      // for (int i = 0; i < salesList.length; i++) {
      //   print(salesList[i].sale_date);
      // }

      emit(SuccessState(
          saleList: salesList,
          firstDate: firstDateStr,
          lastDate: lastDateStr,
          expenseTypes: event.expenseTypes,
          selectedItem: event.selectedItem));
    } else if (event.FilterState == "This week") {
      DateTime firstDateOfLastMonth = getFirstDateOfThisWeek();
      DateTime lastDateOfLastMonth = getLastDateOfThisWeek();

      // Format dates to strings using the provided formatDate function
      String firstDateStr = formatDate(firstDateOfLastMonth);
      String lastDateStr = formatDate(lastDateOfLastMonth);

      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;

      // Query to fetch sales between the first and last dates of this week
      // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      //   SELECT s.*, pc.sName as customerName
      //   FROM sale_order s
      //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
      // ''', [firstDateStr, lastDateStr]);
      List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.iExpenseTypeID = ? AND  de.dDate BETWEEN ? AND ?
''', [event.iExpenseTypeID, firstDateStr, lastDateStr]);

      // List to hold SaleListModel instances
      // List<SaleOrderListModel> salesList = [];
      // // Iterate over fetched rows and populate SaleListModel instances
      // saleRows.forEach((row) {
      //   salesList.add(SaleOrderListModel(
      //     saleId: row['iSaleOrderID'],
      //     sSyncStatus: row['sSyncStatus'],
      //     invoice_price: row['dcTotalBill'],

      //     customer_Name: row['customerName'],
      //     total_discount: row['dcTotalDiscount'],
      //     sale_date: row['dSaleOrderDate'], // Add the sale date
      //   ));
      // });
      // for (int i = 0; i < salesList.length; i++) {
      //   print(salesList[i].sale_date);
      // }

      emit(SuccessState(
          saleList: salesList,
          firstDate: firstDateStr,
          lastDate: lastDateStr,
          expenseTypes: event.expenseTypes,
          selectedItem: event.selectedItem));
    } else if (event.FilterState == "This year") {
      DateTime firstDateOfLastMonth = getFirstDateOfThisYear();
      DateTime lastDateOfLastMonth = getLastDateOfThisYear();

      // Format dates to strings using the provided formatDate function
      String firstDateStr = formatDate(firstDateOfLastMonth);
      String lastDateStr = formatDate(lastDateOfLastMonth);

      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;

      // Query to fetch sales between the first and last dates of this week
      // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      //   SELECT s.*, pc.sName as customerName
      //   FROM sale_order s
      //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
      // ''', [firstDateStr, lastDateStr]);

      List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
   WHERE de.iExpenseTypeID = ? AND  de.dDate BETWEEN ? AND ?
''', [event.iExpenseTypeID, firstDateStr, lastDateStr]);

      // List to hold SaleListModel instances
      // List<SaleOrderListModel> salesList = [];
      // // Iterate over fetched rows and populate SaleListModel instances
      // saleRows.forEach((row) {
      //   salesList.add(SaleOrderListModel(
      //     saleId: row['iSaleOrderID'],
      //     sSyncStatus: row['sSyncStatus'],
      //     invoice_price: row['dcTotalBill'],

      //     customer_Name: row['customerName'],
      //     total_discount: row['dcTotalDiscount'],
      //     sale_date: row['dSaleOrderDate'], // Add the sale date
      //   ));
      // });
      // for (int i = 0; i < salesList.length; i++) {
      //   print(salesList[i].sale_date);
      // }

      emit(SuccessState(
          saleList: salesList,
          firstDate: firstDateStr,
          lastDate: lastDateStr,
          expenseTypes: event.expenseTypes,
          selectedItem: event.selectedItem));
    } else if (event.FilterState == "This quarter") {
      DateTime firstDateOfLastMonth =
          getFirstDateOfLastSixMonthsIncludingCurrent();
      DateTime lastDateOfLastMonth =
          getLastDateOfLastSixMonthsIncludingCurrent();

      // Format dates to strings using the provided formatDate function
      String firstDateStr = formatDate(firstDateOfLastMonth);
      String lastDateStr = formatDate(lastDateOfLastMonth);

      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;

      // Query to fetch sales between the first and last dates of this week
      // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      //   SELECT s.*, pc.sName as customerName
      //   FROM sale_order s
      //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
      // ''', [firstDateStr, lastDateStr]);

      List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.iExpenseTypeID = ? AND  de.dDate BETWEEN ? AND ?
''', [event.iExpenseTypeID, firstDateStr, lastDateStr]);
      // List to hold SaleListModel instances
      // List<SaleOrderListModel> salesList = [];
      // // Iterate over fetched rows and populate SaleListModel instances
      // saleRows.forEach((row) {
      //   salesList.add(SaleOrderListModel(
      //     saleId: row['iSaleOrderID'],
      //     sSyncStatus: row['sSyncStatus'],
      //     invoice_price: row['dcTotalBill'],
      //     customer_Name: row['customerName'],

      //     total_discount: row['dcTotalDiscount'],
      //     sale_date: row['dSaleOrderDate'], // Add the sale date
      //   ));
      // });
      // for (int i = 0; i < salesList.length; i++) {
      //   print(salesList[i].sale_date);
      // }

      emit(SuccessState(
          saleList: salesList,
          firstDate: firstDateStr,
          lastDate: lastDateStr,
          expenseTypes: event.expenseTypes,
          selectedItem: event.selectedItem));
    } else if (event.FilterState == "Custom") {
      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;

      // Query to fetch sales between the first and last dates of this week
      // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      //   SELECT s.*, pc.sName as customerName
      //   FROM sale_order s
      //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
      // ''', [event.fastDay, event.lastDay]);

      List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
   WHERE de.iExpenseTypeID = ? AND  de.dDate BETWEEN ? AND ?
''', [event.iExpenseTypeID, event.fastDay, event.lastDay]);

      // List to hold SaleListModel instances
      // List<SaleOrderListModel> salesList = [];
      // // Iterate over fetched rows and populate SaleListModel instances
      // saleRows.forEach((row) {
      //   salesList.add(SaleOrderListModel(
      //     saleId: row['iSaleID'],
      //     sSyncStatus: row['sSyncStatus'],
      //     invoice_price: row['dcTotalBill'],

      //     customer_Name: row['customerName'],
      //     total_discount: row['dcTotalDiscount'],
      //     sale_date: row['dSaleOrderDate'], // Add the sale date
      //   ));
      // });
      emit(SuccessState(
          saleList: salesList,
          firstDate: event.fastDay!,
          lastDate: event.lastDay!,
          expenseTypes: event.expenseTypes,
          selectedItem: event.selectedItem));
    }
  }

  FutureOr<void> saleListInitialEvent(
      SaleOrderListInitialEvent event, Emitter<SaleOrderListState> emit) async {
    // DateTime current = DateTime.now();
    // String currentDate = formatDate(current);
    // DBHelper dbHelper = DBHelper();
    // final db = await dbHelper.database;
    //   List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT s.*, pc.sName as customerName
    //   FROM sale_order s
    //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    //   WHERE s.dSaleOrderDate = ?
    // ''', [currentDate]);

    DateTime current = DateTime.now();
    String currentDate = formatDate(current);
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.dDate = ?
''', [currentDate]);

    //   List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT de.*
    //   FROM daily_expense de
    //   INNER JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
    //   WHERE s. = ?
    // ''', [currentDate]);
    // Fetch rows from the database
    List<Map<String, dynamic>> rows = await db.rawQuery('''
    SELECT *
    FROM expense_type
  ''');

    // Convert rows to a list of ExpenseType objects
    List<ExpenseTypeModel> expenseTypes =
        rows.map((row) => ExpenseTypeModel.fromMap(row)).toList();

    emit(SuccessState(
        saleList: saleRows,
        firstDate: currentDate,
        lastDate: currentDate,
        expenseTypes: expenseTypes,
        selectedItem: null));
  }

  FutureOr<void> dailyExpenseTypeActionEvent(DailyExpenseTypeActionEvent event,
      Emitter<SaleOrderListState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Fetch rows from the database
    List<Map<String, dynamic>> rows = await db.rawQuery('''
    SELECT *
    FROM expense_type
  ''');

    // Convert rows to a list of ExpenseType objects
    List<ExpenseTypeModel> expenseTypes =
        rows.map((row) => ExpenseTypeModel.fromMap(row)).toList();
    emit(DailyExpenseTypeActionState(expenseTypes: expenseTypes));
    // Use the list of ExpenseType objects as needed
  }

  FutureOr<void> saleListLastMonthEvent(SaleOrderListLastMonthEvent event,
      Emitter<SaleOrderListState> emit) async {
    // Calculate first and last dates of the last month
    DateTime firstDateOfLastMonth = getFirstDateOfLastMonth();
    DateTime lastDateOfLastMonth = getLastDateOfLastMonth();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of last month
    // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT s.*, pc.sName as customerName
    //   FROM sale_order s
    //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
    // ''', [firstDateStr, lastDateStr]);

    List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.dDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // // List to hold SaleListModel instances
    // List<SaleOrderListModel> salesList = [];
    // // Iterate over fetched rows and populate SaleListModel instances
    // saleRows.forEach((row) {
    //   salesList.add(SaleOrderListModel(
    //     saleId: row['iSaleOrderID'],
    //     sSyncStatus: row['sSyncStatus'],
    //     invoice_price: row['dcTotalBill'],

    //     customer_Name: row['customerName'],
    //     total_discount: row['dcTotalDiscount'],
    //     sale_date: row['dSaleOrderDate'], // Add the sale date
    //   ));
    // });
    // for (int i = 0; i < salesList.length; i++) {
    //   print(salesList[i].sale_date);
    // }

    emit(SuccessState(
        saleList: salesList,
        firstDate: firstDateStr,
        lastDate: lastDateStr,
        expenseTypes: event.expenseTypes,
        selectedItem: event.selectedItem));
  }

  FutureOr<void> saleListThisMonthEvent(SaleOrderListThisMonthEvent event,
      Emitter<SaleOrderListState> emit) async {
    // Calculate first and last dates of the last month
    DateTime firstDateOfLastMonth = getFirstDateOfThisMonth();
    DateTime lastDateOfLastMonth = getLastDateOfThisMonth();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this month
    // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT s.*, pc.sName as customerName
    //   FROM sale_order s
    //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
    // ''', [firstDateStr, lastDateStr]);
    List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.dDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    // List<SaleOrderListModel> salesList = [];
    // // Iterate over fetched rows and populate SaleListModel instances
    // saleRows.forEach((row) {
    //   salesList.add(SaleOrderListModel(
    //     saleId: row['iSaleOrderID'],
    //     sSyncStatus: row['sSyncStatus'],
    //     invoice_price: row['dcTotalBill'],

    //     customer_Name: row['customerName'],
    //     total_discount: row['dcTotalDiscount'],
    //     sale_date: row['dSaleOrderDate'], // Add the sale date
    //   ));
    // });
    // for (int i = 0; i < salesList.length; i++) {
    //   print(salesList[i].sale_date);
    // }

    emit(SuccessState(
        saleList: salesList,
        firstDate: firstDateStr,
        lastDate: lastDateStr,
        expenseTypes: event.expenseTypes,
        selectedItem: event.selectedItem));
  }

  FutureOr<void> saleListThisWeekEvent(SaleOrderListThisWeekEvent event,
      Emitter<SaleOrderListState> emit) async {
    DateTime firstDateOfLastMonth = getFirstDateOfThisWeek();
    DateTime lastDateOfLastMonth = getLastDateOfThisWeek();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT s.*, pc.sName as customerName
    //   FROM sale_order s
    //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
    // ''', [firstDateStr, lastDateStr]);
    List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.dDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    // List<SaleOrderListModel> salesList = [];
    // // Iterate over fetched rows and populate SaleListModel instances
    // saleRows.forEach((row) {
    //   salesList.add(SaleOrderListModel(
    //     saleId: row['iSaleOrderID'],
    //     sSyncStatus: row['sSyncStatus'],
    //     invoice_price: row['dcTotalBill'],

    //     customer_Name: row['customerName'],
    //     total_discount: row['dcTotalDiscount'],
    //     sale_date: row['dSaleOrderDate'], // Add the sale date
    //   ));
    // });
    // for (int i = 0; i < salesList.length; i++) {
    //   print(salesList[i].sale_date);
    // }

    emit(SuccessState(
        saleList: salesList,
        firstDate: firstDateStr,
        lastDate: lastDateStr,
        expenseTypes: event.expenseTypes,
        selectedItem: event.selectedItem));
  }

  FutureOr<void> saleListThisYearEvent(SaleOrderListThisYearEvent event,
      Emitter<SaleOrderListState> emit) async {
    DateTime firstDateOfLastMonth = getFirstDateOfThisYear();
    DateTime lastDateOfLastMonth = getLastDateOfThisYear();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT s.*, pc.sName as customerName
    //   FROM sale_order s
    //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
    // ''', [firstDateStr, lastDateStr]);

    List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.dDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    // List<SaleOrderListModel> salesList = [];
    // // Iterate over fetched rows and populate SaleListModel instances
    // saleRows.forEach((row) {
    //   salesList.add(SaleOrderListModel(
    //     saleId: row['iSaleOrderID'],
    //     sSyncStatus: row['sSyncStatus'],
    //     invoice_price: row['dcTotalBill'],

    //     customer_Name: row['customerName'],
    //     total_discount: row['dcTotalDiscount'],
    //     sale_date: row['dSaleOrderDate'], // Add the sale date
    //   ));
    // });
    // for (int i = 0; i < salesList.length; i++) {
    //   print(salesList[i].sale_date);
    // }

    emit(SuccessState(
        saleList: salesList,
        firstDate: firstDateStr,
        lastDate: lastDateStr,
        expenseTypes: event.expenseTypes,
        selectedItem: event.selectedItem));
  }

  FutureOr<void> saleListThisQuarterEvent(SaleOrderListThisQuarterEvent event,
      Emitter<SaleOrderListState> emit) async {
    DateTime firstDateOfLastMonth =
        getFirstDateOfLastSixMonthsIncludingCurrent();
    DateTime lastDateOfLastMonth = getLastDateOfLastSixMonthsIncludingCurrent();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT s.*, pc.sName as customerName
    //   FROM sale_order s
    //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
    // ''', [firstDateStr, lastDateStr]);

    List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.dDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);
    // List to hold SaleListModel instances
    // List<SaleOrderListModel> salesList = [];
    // // Iterate over fetched rows and populate SaleListModel instances
    // saleRows.forEach((row) {
    //   salesList.add(SaleOrderListModel(
    //     saleId: row['iSaleOrderID'],
    //     sSyncStatus: row['sSyncStatus'],
    //     invoice_price: row['dcTotalBill'],
    //     customer_Name: row['customerName'],

    //     total_discount: row['dcTotalDiscount'],
    //     sale_date: row['dSaleOrderDate'], // Add the sale date
    //   ));
    // });
    // for (int i = 0; i < salesList.length; i++) {
    //   print(salesList[i].sale_date);
    // }

    emit(SuccessState(
        saleList: salesList,
        firstDate: firstDateStr,
        lastDate: lastDateStr,
        expenseTypes: event.expenseTypes,
        selectedItem: event.selectedItem));
  }

  FutureOr<void> saleListCustomDate(
      SaleOrderListCustomDate event, Emitter<SaleOrderListState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    // List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    //   SELECT s.*, pc.sName as customerName
    //   FROM sale_order s
    //   LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    //   WHERE s.dSaleOrderDate BETWEEN ? AND ?
    // ''', [event.fastDay, event.lastDay]);

    List<Map<String, dynamic>> salesList = await db.rawQuery('''
  SELECT de.*, et.sTypeName as expenseTypeName
  FROM daily_expense de
  LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
  WHERE de.dDate BETWEEN ? AND ?
    ''', [event.fastDay, event.lastDay]);

    // List to hold SaleListModel instances
    // List<SaleOrderListModel> salesList = [];
    // // Iterate over fetched rows and populate SaleListModel instances
    // saleRows.forEach((row) {
    //   salesList.add(SaleOrderListModel(
    //     saleId: row['iSaleID'],
    //     sSyncStatus: row['sSyncStatus'],
    //     invoice_price: row['dcTotalBill'],

    //     customer_Name: row['customerName'],
    //     total_discount: row['dcTotalDiscount'],
    //     sale_date: row['dSaleOrderDate'], // Add the sale date
    //   ));
    // });
    emit(SuccessState(
        saleList: salesList,
        firstDate: event.fastDay,
        lastDate: event.lastDay,
        expenseTypes: event.expenseTypes,
        selectedItem: event.selectedItem));
  }

  // FutureOr<void> saleListDismissEvent(
  //     SaleOrderListDismissEvent event, Emitter<SaleOrderListState> emit) async {
  //   DBHelper dbHelper = DBHelper();
  //   final db = await dbHelper.database;
  //   await db.delete(
  //     'daily_expense',
  //     where: 'iDailyExpenseID = ?',
  //     whereArgs: [event.SaleId],
  //   );

  //   // Query to fetch sales between the first and last dates of this week
  //   List<Map<String, dynamic>> saleRows = await db.rawQuery('''
  //     SELECT s.*, pc.sName as customerName
  //     FROM sale_order s
  //     LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
  //     WHERE de.dDate BETWEEN ? AND ?
  //   ''', [event.firstDate, event.lastDate]);

  //   // List to hold SaleListModel instances
  //   List<SaleOrderListModel> salesList = [];
  //   // Iterate over fetched rows and populate SaleListModel instances
  //   saleRows.forEach((row) {
  //     salesList.add(SaleOrderListModel(
  //       sSyncStatus: row['sSyncStatus'],
  //       saleId: row['iSaleOrderID'],
  //       invoice_price: row['dcTotalBill'],

  //       customer_Name: row['customerName'],
  //       total_discount: row['dcTotalDiscount'],
  //       sale_date: row['dSaleOrderDate'], // Add the sale date
  //     ));
  //   });
  //   emit(SuccessState(
  //       saleList: salesList,
  //       firstDate: event.firstDate,
  //       lastDate: event.lastDate,
  //       expenseTypes: event.e,
  //       selectedItem: event.selectedItem));
  // }

  FutureOr<void> saleListDetailsEvent(
      SaleOrderListDetailsEvent event, Emitter<SaleOrderListState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> daily_expense_list = await db.rawQuery('''
    SELECT 
         daily_expense.iDailyExpenseID,
        daily_expense.transaction_id,
        daily_expense.sDescription,
        daily_expense.dcAmount,
        daily_expense.dDate,
        expense_type.sTypeName,
        bank.sName
    FROM 
        daily_expense
    LEFT JOIN 
        expense_type ON daily_expense.iExpenseTypeID = expense_type.iExpenseTypeID
    LEFT JOIN 
        bank ON daily_expense.iBankID = bank.iBankID
    WHERE 
        daily_expense.iDailyExpenseID = ?
    ''', [event.SaleId]);

    //   if (result.isNotEmpty) {
    //     final row = result.first;

    //     final SaleOrder sale = SaleOrder(
    //       iSaleOrderID: row['iSaleID'],
    //       iSystemUserID: row['iSystemUserID'],
    //       iFirmID: row['iFirmID'],
    //       dcOnProuctDiscount: row['dcOnProuctDiscount'],
    //       sTotal_Item: row['sTotal_Item'],
    //       sNoficationStatus: row['sNoficationStatus'],
    //       sReadStatus: row['sReadStatus'],
    //       dSaleOrderDate: row['dSaleOrderDate'],
    //       iStoreID: row['iStoreID'],
    //       iPermanentCustomerID: row['iPermanentCustomerID'],
    //       sAddress: row['sAddress'],
    //       dcTotalBill: row['dcTotalBill'],
    //       dcGrandTotal: row['dcGrandTotal'],
    //       dcExtraDiscount: row['dcExtraDiscount'],
    //       dcTotalDiscount: row['dcTotalDiscount'],
    //       sTotalBonus: row['sTotalBonus'],
    //       sSaleType: row['sSaleType'],
    //       sSaleDescription: row['sSaleDescription'],
    //       bStatus: row['bStatus'],
    //       sSyncStatus: row['sSyncStatus'],
    //       sEntrySource: row['sEntrySource'],
    //       sAction: row['sAction'],
    //       dtDueDate: row['dtDueDate'],
    //       dtCreatedDate: row['dtCreatedDate'],
    //       iAddedBy: row['iAddedBy'],
    //       dtUpdatedDate: row['dtUpdatedDate'],
    //       iUpdatedBy: row['iUpdatedBy'],
    //       dtDeletedDate: row['dtDeletedDate'],
    //       iDeletedBy: row['iDeletedBy'],
    //     );

    //     PermanentCustomer? customer;
    //     if (row['iPermanentCustomerID'] != null) {
    //       customer = PermanentCustomer(
    //         iPermanentCustomerID: row['iPermanentCustomerID'],
    //         iSystemUserID: row['iSystemUserID'],
    //         iAreaID: row['iAreaID'],
    //         iFirmID: row['iFirmID'],
    //         sName: row['sName'],
    //         sShopName: row['sShopName'],
    //         sEmail: row['sEmail'],
    //         sCode: row['sCode'],
    //         sAddress: row['permanent_customer.sAddress'],
    //         sPhone: row['sPhone'],
    //         sMobile: row['sMobile'],
    //         sDescription: row['sDescription'],
    //         dcDefaultAmount: row['dcDefaultAmount'],
    //         dcPreviousAmount: row['dcPreviousAmount'],
    //         dcTotalRemainingAmount: row['dcTotalRemainingAmount'],
    //         bStatus: row['permanent_customer.bStatus'],
    //         sSyncStatus: row['permanent_customer.sSyncStatus'],
    //         sEntrySource: row['permanent_customer.sEntrySource'],
    //         sAction: row['permanent_customer.sAction'],
    //         sType: row['sType'],
    //         dtCreatedDate: row['permanent_customer.dtCreatedDate'],
    //         iAddedBy: row['permanent_customer.iAddedBy'],
    //         dtUpdatedDate: row['permanent_customer.dtUpdatedDate'],
    //         iUpdatedBy: row['permanent_customer.iUpdatedBy'],
    //         dtDeletedDate: row['permanent_customer.dtDeletedDate'],
    //         iDeletedBy: row['permanent_customer.iDeletedBy'],
    //       );
    //     }
    //     final List<Map<String, dynamic>> sale_products = await db.query(
    //       'sale_order_products_list',
    //       where: 'iSaleOrderID = ?',
    //       whereArgs: [event.SaleId],
    //     );
    //     // for (var product in sale_products) {
    //     //   print(product);
    //     // }

    //     Future<List<Map<String, dynamic>>> fetchAndProcessData(int saleID) async {
    //       // Execute the query
    //       final result = await db.rawQuery('''
    //   SELECT sp.*, p.*, pu.*
    //   FROM sale_order_products_list sp
    //   JOIN product p ON sp.iProductID = p.iProductID
    //   JOIN product_unit pu ON (sp.sSaleStatus = pu.iItemUnitID)
    //   WHERE sp.iSaleOrderID = ?
    // ''', [saleID]);
    //       return result;
    //       // // Process the result
    //       // List<Map<String, dynamic>> rows = result.map((row) => row).toList();
    //       // return rows;
    //     }

    //     List<Map<String, dynamic>> products =
    //         await fetchAndProcessData(event.SaleId);

    //     emit(SaleListDetailsState(
    //         saleWithCustomer: SaleWithCustomer(sale: sale, customer: customer),
    //         products: products));
    //   }

    emit(SaleListDetailsState(
      daily_expense_list: daily_expense_list,
    ));
  }

  FutureOr<void> dailyExpenseListSyncEvent(
      DailyExpenseListSyncEvent event, Emitter<SaleOrderListState> emit) async {
    emit(LoadingState());

    Future<Map<String, dynamic>?> getDailyExpenseById(int id) async {
      DBHelper dbHelper = DBHelper();
      final db = await dbHelper.database;
      List<Map<String, dynamic>> result = await db.query(
        'daily_expense',
        where: 'iDailyExpenseID = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    }

    final Uri url = Uri.parse(SyncDataUrl);
    final _box = GetStorage();
    final authorization_token = _box.read('token');

    DBHelper dbHelper = DBHelper();
    // final db = dbHelper.database;
    int? appId = await dbHelper.getAppId();

    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> dailyExpenseData = {};

    for (int id in event.iDailyExpenseID) {
      final expense = await getDailyExpenseById(id);
      if (expense != null) {
        Map<String, dynamic> mutableExpense =
            Map<String, dynamic>.from(expense);
        mutableExpense.remove('iDailyExpenseID');

        // Format the date fields if necessary
        if (mutableExpense['dDate'] != null) {
          mutableExpense['dDate'] = mutableExpense['dDate'].toString();
        }

        dailyExpenseData['iDailyExpenseID__$id'] = mutableExpense;
      } else {
        print('No expense found for ID: $id');
      }
    }

    final body = {
      "authorization_token": authorization_token,
      "app_id": "${appId}",
      "data": {
        "daily_expense": dailyExpenseData,
      },
    };
    print(body);

    // final body = {
    //   "authorization_token": authorization_token,
    //   "app_id": appId.toString(),
    //   "data": {
    //     "permanent_customer_payments": data,
    //   },
    // };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('error')) {
          print('Faced error: ${jsonResponse['error']}');
          // emit(InitialAuthState());
        } else if (jsonResponse.containsKey('success')) {
          print(jsonResponse);

          DBHelper dbHelper = DBHelper();
          final db = await dbHelper.database;
          final dailyExpenseData = jsonResponse['0']['data']['daily_expense'];
          int i = -1;
          dailyExpenseData.forEach((key, value) async {
            i = i + 1;
            // Extract the transaction_id for each entry
            String transactionId = value['transaction_id'];
            print('Transaction ID: $transactionId');

            // Here, you can store the transaction_id in a variable or a list
            // For example, store in a list:
            List<String> transactionIds = [];
            transactionIds.add(transactionId);
            await db.update(
              'daily_expense',
              {
                'transaction_id': transactionId,
                'sSyncStatus': 1,
              },
              where: 'iDailyExpenseID = ?',
              whereArgs: [event.iDailyExpenseID[i]],
            );
          });

          // for (int i = 0; i < event.iDailyExpenseID.length; i++) {
          //   // Extract the first transaction_id
          //   String firstTransactionId = "";
          //   Map<String, dynamic> dailyExpenseData =
          //       jsonResponse['$i']['data']['daily_expense'];

          //   // Get the first key (iDailyExpenseID__1051) dynamically
          //   if (dailyExpenseData.isNotEmpty) {
          //     String firstKey = dailyExpenseData.keys.first;
          //     if (dailyExpenseData[firstKey] != null) {
          //       firstTransactionId =
          //           dailyExpenseData[firstKey]['transaction_id'];
          //     }
          //   }

          // Print the extracted transaction_id
          // print('First transaction_id: $firstTransactionId');

          List<Map<String, dynamic>> salesList = await db.rawQuery('''
          SELECT de.*, et.sTypeName as expenseTypeName
          FROM daily_expense de
          LEFT JOIN expense_type et ON de.iExpenseTypeID = et.iExpenseTypeID
          WHERE de.dDate BETWEEN ? AND ?
            ''', [event.firstDate, event.lastDate]);

          // List to hold SaleListModel instances
          // List<SaleOrderListModel> salesList = [];
          // // Iterate over  fetched rows and populate SaleListModel instances
          // saleRows.forEach((row) {
          //   salesList.add(SaleOrderListModel(
          //     saleId: row['iSaleID'],
          //     sSyncStatus: row['sSyncStatus'],
          //     invoice_price: row['dcTotalBill'],

          //     customer_Name: row['customerName'],
          //     total_discount: row['dcTotalDiscount'],
          //     sale_date: row['dSaleOrderDate'], // Add the sale date
          //   ));
          // });
          emit(SuccessState(
              saleList: salesList,
              firstDate: event.firstDate,
              lastDate: event.lastDate,
              expenseTypes: event.expenseTypes,
              selectedItem: event.selectedItem));

          // emit(SuccessState(
          //     expenseTypes: event.expenseTypes,
          //     saleList: salesList,
          //     firstDate: event.firstDate,
          //     lastDate: event.lastDate));
        }
      } else {
        print("Error: ${response.statusCode}");
        print("Error body: ${response.body}");
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }
}
