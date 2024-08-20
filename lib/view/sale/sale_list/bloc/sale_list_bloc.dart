import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';

import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_event.dart';
import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_state.dart';
import 'package:okra_distributer/view/sale/sale_list/model/sale_list_details_model.dart';
import 'package:okra_distributer/view/sale/sale_list/model/sale_list_model.dart';

class SaleListBloc extends Bloc<SaleListEvent, SaleListState> {
  SaleListBloc() : super(SaleInitialState()) {
    on<SaleListInitialEvent>(saleListInitialEvent);
    on<SaleListLastMonthEvent>(saleListLastMonthEvent);
    on<SaleListThisMonthEvent>(saleListThisMonthEvent);
    on<SaleListThisWeekEvent>(saleListThisWeekEvent);
    on<SaleListThisYearEvent>(saleListThisYearEvent);
    on<SaleListThisQuarterEvent>(saleListThisQuarterEvent);
    on<SaleListCustomDate>(saleListCustomDate);
    on<SaleListDismissEvent>(saleListDismissEvent);
    on<SaleListDetailsEvent>(saleListDetailsEvent);
  }

  FutureOr<void> saleListInitialEvent(
      SaleListInitialEvent event, Emitter<SaleListState> emit) async {
    DateTime current = DateTime.now();
    String currentDate = formatDate(current);
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
    SELECT s.*, pc.sName as customerName
    FROM sale s
    LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
    WHERE s.dSaleDate = ?
  ''', [currentDate]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        saleId: row['iSaleID'],
        sSyncStatus: row['sSyncStatus'],
        invoice_price: row['dcTotalBill'],
        paid_bill_amount: row['dcPaidBillAmount'],
        customer_Name: row['customerName'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });

    emit(SuccessState(
        saleList: salesList, firstDate: currentDate, lastDate: currentDate));
  }

  FutureOr<void> saleListLastMonthEvent(
      SaleListLastMonthEvent event, Emitter<SaleListState> emit) async {
    // Calculate first and last dates of the last month
    DateTime firstDateOfLastMonth = getFirstDateOfLastMonth();
    DateTime lastDateOfLastMonth = getLastDateOfLastMonth();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of last month
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*, pc.sName as customerName
      FROM sale s
      LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        saleId: row['iSaleID'],
        sSyncStatus: row['sSyncStatus'],
        invoice_price: row['dcTotalBill'],
        paid_bill_amount: row['dcPaidBillAmount'],
        customer_Name: row['customerName'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });

    emit(SuccessState(
        saleList: salesList, firstDate: firstDateStr, lastDate: lastDateStr));
  }

  FutureOr<void> saleListThisMonthEvent(
      SaleListThisMonthEvent event, Emitter<SaleListState> emit) async {
    // Calculate first and last dates of the last month
    DateTime firstDateOfLastMonth = getFirstDateOfThisMonth();
    DateTime lastDateOfLastMonth = getLastDateOfThisMonth();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this month
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*, pc.sName as customerName
      FROM sale s
      LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        saleId: row['iSaleID'],
        sSyncStatus: row['sSyncStatus'],
        invoice_price: row['dcTotalBill'],
        paid_bill_amount: row['dcPaidBillAmount'],
        customer_Name: row['customerName'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });

    emit(SuccessState(
        saleList: salesList, firstDate: firstDateStr, lastDate: lastDateStr));
  }

  FutureOr<void> saleListThisWeekEvent(
      SaleListThisWeekEvent event, Emitter<SaleListState> emit) async {
    DateTime firstDateOfLastMonth = getFirstDateOfThisWeek();
    DateTime lastDateOfLastMonth = getLastDateOfThisWeek();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*, pc.sName as customerName
      FROM sale s
      LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        saleId: row['iSaleID'],
        sSyncStatus: row['sSyncStatus'],
        invoice_price: row['dcTotalBill'],
        paid_bill_amount: row['dcPaidBillAmount'],
        customer_Name: row['customerName'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });

    emit(SuccessState(
        saleList: salesList, firstDate: firstDateStr, lastDate: lastDateStr));
  }

  FutureOr<void> saleListThisYearEvent(
      SaleListThisYearEvent event, Emitter<SaleListState> emit) async {
    DateTime firstDateOfLastMonth = getFirstDateOfThisYear();
    DateTime lastDateOfLastMonth = getLastDateOfThisYear();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*, pc.sName as customerName
      FROM sale s
      LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        saleId: row['iSaleID'],
        sSyncStatus: row['sSyncStatus'],
        invoice_price: row['dcTotalBill'],
        paid_bill_amount: row['dcPaidBillAmount'],
        customer_Name: row['customerName'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });

    emit(SuccessState(
        saleList: salesList, firstDate: firstDateStr, lastDate: lastDateStr));
  }

  FutureOr<void> saleListThisQuarterEvent(
      SaleListThisQuarterEvent event, Emitter<SaleListState> emit) async {
    DateTime firstDateOfLastMonth =
        getFirstDateOfLastSixMonthsIncludingCurrent();
    DateTime lastDateOfLastMonth = getLastDateOfLastSixMonthsIncludingCurrent();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*, pc.sName as customerName
      FROM sale s
      LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        saleId: row['iSaleID'],
        sSyncStatus: row['sSyncStatus'],
        invoice_price: row['dcTotalBill'],
        customer_Name: row['customerName'],
        paid_bill_amount: row['dcPaidBillAmount'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });

    emit(SuccessState(
        saleList: salesList, firstDate: firstDateStr, lastDate: lastDateStr));
  }

  FutureOr<void> saleListCustomDate(
      SaleListCustomDate event, Emitter<SaleListState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Query to fetch sales between the first and last dates of this week
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*, pc.sName as customerName
      FROM sale s
      LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [event.fastDay, event.lastDay]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        saleId: row['iSaleID'],
        sSyncStatus: row['sSyncStatus'],
        invoice_price: row['dcTotalBill'],
        paid_bill_amount: row['dcPaidBillAmount'],
        customer_Name: row['customerName'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });
    emit(SuccessState(
        saleList: salesList,
        firstDate: event.fastDay,
        lastDate: event.lastDay));
  }

  FutureOr<void> saleListDismissEvent(
      SaleListDismissEvent event, Emitter<SaleListState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    await db.delete(
      'sale',
      where: 'iSaleID = ?',
      whereArgs: [event.SaleId],
    );

    // Query to fetch sales between the first and last dates of this week
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*, pc.sName as customerName
      FROM sale s
      LEFT JOIN permanent_customer pc ON s.iPermanentCustomerID = pc.iPermanentCustomerID
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [event.firstDate, event.lastDate]);

    // List to hold SaleListModel instances
    List<SaleListModel> salesList = [];
    // Iterate over fetched rows and populate SaleListModel instances
    saleRows.forEach((row) {
      salesList.add(SaleListModel(
        sSyncStatus: row['sSyncStatus'],
        saleId: row['iSaleID'],
        invoice_price: row['dcTotalBill'],
        paid_bill_amount: row['dcPaidBillAmount'],
        customer_Name: row['customerName'],
        total_discount: row['dcTotalDiscount'],
        sale_date: row['dSaleDate'], // Add the sale date
      ));
    });
    emit(SuccessState(
        saleList: salesList,
        firstDate: event.firstDate,
        lastDate: event.lastDate));
  }

  FutureOr<void> saleListDetailsEvent(
      SaleListDetailsEvent event, Emitter<SaleListState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
          sale.*,
          permanent_customer.*
      FROM 
          sale
      LEFT JOIN 
          permanent_customer ON sale.iPermanentCustomerID = permanent_customer.iPermanentCustomerID
      WHERE 
          sale.iSaleID = ?
      ''', [event.SaleId]);

    if (result.isNotEmpty) {
      final row = result.first;

      final Sale sale = Sale(
        iSaleID: row['iSaleID'],
        iSystemUserID: row['iSystemUserID'],
        iFirmID: row['iFirmID'],
        iPermanentCustomerID: row['iPermanentCustomerID'],
        iEmployeeID: row['iEmployeeID'],
        sCustomerName: row['sCustomerName'],
        sCustomerFatherName: row['sCustomerFatherName'],
        sCustomerInvoiceNo: row['sCustomerInvoiceNo'],
        sMobileNo: row['sMobileNo'],
        sCustomerCNIC: row['sCustomerCNIC'],
        sAddress: row['sAddress'],
        dcTotalBill: row['dcTotalBill'],
        dcGrandTotal: row['dcGrandTotal'],
        dcPaidBillAmount: row['dcPaidBillAmount'],
        iBankIDPaidAmount: row['iBankIDPaidAmount'],
        dcOnProductDiscount: row['dcOnProuctDiscount'],
        dcExtraDiscount: row['dcExtraDiscount'],
        dcTotalDiscount: row['dcTotalDiscount'],
        dcSaleExpense: row['dcSaleExpense'],
        iBankIDExpensAmount: row['iBankIDExpensAmount'],
        sTotalBonus: row['sTotalBonus'],
        sTotalItem: row['sTotal_Item'],
        sPaymentStatus: row['sPaymentStatus'],
        dcSaleProfit: row['dcSaleProfit'],
        dcExtraProfit: row['dcExtra_profit'],
        sSaleType: row['sSaleType'],
        sSaleDescription: row['sSaleDescription'],
        bStatus: row['bStatus'],
        sSyncStatus: row['sSyncStatus'],
        sEntrySource: row['sEntrySource'],
        sAction: row['sAction'],
        dSaleDate: row['dSaleDate'],
        dtDueDate: row['dtDueDate'],
        dtCreatedDate: row['dtCreatedDate'],
        iAddedBy: row['iAddedBy'],
        dtUpdatedDate: row['dtUpdatedDate'],
        iUpdatedBy: row['iUpdatedBy'],
        dtDeletedDate: row['dtDeletedDate'],
        iDeletedBy: row['iDeletedBy'],
      );

      PermanentCustomer? customer;
      if (row['iPermanentCustomerID'] != null) {
        customer = PermanentCustomer(
          iPermanentCustomerID: row['iPermanentCustomerID'],
          iSystemUserID: row['iSystemUserID'],
          iAreaID: row['iAreaID'],
          iFirmID: row['iFirmID'],
          sName: row['sName'],
          sShopName: row['sShopName'],
          sEmail: row['sEmail'],
          sCode: row['sCode'],
          sAddress: row['permanent_customer.sAddress'],
          sPhone: row['sPhone'],
          sMobile: row['sMobile'],
          sDescription: row['sDescription'],
          dcDefaultAmount: row['dcDefaultAmount'],
          dcPreviousAmount: row['dcPreviousAmount'],
          dcTotalRemainingAmount: row['dcTotalRemainingAmount'],
          bStatus: row['permanent_customer.bStatus'],
          sSyncStatus: row['permanent_customer.sSyncStatus'],
          sEntrySource: row['permanent_customer.sEntrySource'],
          sAction: row['permanent_customer.sAction'],
          sType: row['sType'],
          dtCreatedDate: row['permanent_customer.dtCreatedDate'],
          iAddedBy: row['permanent_customer.iAddedBy'],
          dtUpdatedDate: row['permanent_customer.dtUpdatedDate'],
          iUpdatedBy: row['permanent_customer.iUpdatedBy'],
          dtDeletedDate: row['permanent_customer.dtDeletedDate'],
          iDeletedBy: row['permanent_customer.iDeletedBy'],
        );
      }

      final List<Map<String, dynamic>> sale_products = await db.query(
        'sale_products_list',
        where: 'iSaleID = ?',
        whereArgs: [event.SaleId],
      );
      print(sale_products.length);

      Future<List<Map<String, dynamic>>> fetchAndProcessData(int saleID) async {
        // Execute the query
        final result = await db.rawQuery('''
    SELECT sp.*, p.*, pu.*
    FROM sale_products_list sp
    JOIN product p ON sp.iProductID = p.iProductID
    JOIN product_unit pu ON (sp.sSaleStatus = pu.iItemUnitID)
    WHERE sp.iSaleID = ?
  ''', [saleID]);
        return result;
      }

      print(result.length);
      List<Map<String, dynamic>> products =
          await fetchAndProcessData(event.SaleId);

      // ======================== Remove Duplicate List ========================   //
      // Use a Map to filter out duplicates based on `iSaleID`
      Map<int, Map<String, dynamic>> uniqueProductsMap = {};

      for (var product in products) {
        uniqueProductsMap[product['iSaleID']] = product;
      }

      // Convert back to List
      List<Map<String, dynamic>> uniqueProducts =
          uniqueProductsMap.values.toList();

      emit(SaleListDetailsState(
          saleWithCustomer: SaleWithCustomer(sale: sale, customer: customer),
          products: uniqueProducts));
    }
  }
}
