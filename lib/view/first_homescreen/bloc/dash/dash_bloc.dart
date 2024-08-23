import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/view/first_homescreen/bloc/dash/dash_event.dart';
import 'package:okra_distributer/view/first_homescreen/bloc/dash/dash_state.dart';
import 'package:okra_distributer/view/first_homescreen/models/sale_table_model.dart';

class DashBloc extends Bloc<DashEvent, DashState> {
  DashBloc() : super(InitialState()) {
    on<InitialDashEvent>(initialDashEvent);
    on<DashThisWeekEvent>(dashThisWeekEvent);
    on<DashThisMonthEvent>(dashThisMonthEvent);
    on<DashLastMonthEvent>(dashLastMonthEvent);
    on<DashThisQuarterEvent>(dashThisQuarterEvent);
    on<DashThisYearEvent>(dashThisYearEvent);
    on<DashCustomDate>(dashCustomDate);
  }

  FutureOr<void> initialDashEvent(
      InitialDashEvent event, Emitter<DashState> emit) async {
    // Calculate first and last dates of the last month
    DateTime firstDateOfLastMonth = getFirstDateOfThisMonth();
    DateTime lastDateOfLastMonth = getLastDateOfThisMonth();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*
      FROM sale s
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);
    List<SaleTableModel> sales =
        saleRows.map((saleRow) => SaleTableModel.fromMap(saleRow)).toList();
    final netAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcTotalBill ?? 0.0));
    final dcPaidBillAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcPaidBillAmount ?? 0.0));

    emit(DashSuccessState(
      totalDiscount: 200,
      totalOrder: sales.length,
      totalSaleAmount: netAmount,
      paidBillAmount: dcPaidBillAmount,
      firstDate: firstDateStr,
      lastDate: lastDateStr,
    ));
    // emit(DashSuccessState(
    //     totalDiscount: 200, totalOrder: 100, totalSaleAmount: 200));
  }

  FutureOr<void> dashThisWeekEvent(
      DashThisWeekEvent event, Emitter<DashState> emit) async {
    DateTime firstDateOfLastMonth = getFirstDateOfThisWeek();
    DateTime lastDateOfLastMonth = getLastDateOfThisWeek();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*
      FROM sale s
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);
    List<SaleTableModel> sales =
        saleRows.map((saleRow) => SaleTableModel.fromMap(saleRow)).toList();
    final netAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcTotalBill ?? 0.0));
    final dcPaidBillAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcPaidBillAmount ?? 0.0));

    emit(DashSuccessState(
      totalDiscount: 200,
      totalOrder: sales.length,
      totalSaleAmount: netAmount,
      paidBillAmount: dcPaidBillAmount,
      firstDate: firstDateStr,
      lastDate: lastDateStr,
    ));
  }

  FutureOr<void> dashThisMonthEvent(
      DashThisMonthEvent event, Emitter<DashState> emit) async {
    // Calculate first and last dates of the last month
    DateTime firstDateOfLastMonth = getFirstDateOfThisMonth();
    DateTime lastDateOfLastMonth = getLastDateOfThisMonth();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*
      FROM sale s
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);
    List<SaleTableModel> sales =
        saleRows.map((saleRow) => SaleTableModel.fromMap(saleRow)).toList();
    final netAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcTotalBill ?? 0.0));
    final dcPaidBillAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcPaidBillAmount ?? 0.0));

    emit(DashSuccessState(
      totalDiscount: 200,
      totalOrder: sales.length,
      totalSaleAmount: netAmount,
      paidBillAmount: dcPaidBillAmount,
      firstDate: firstDateStr,
      lastDate: lastDateStr,
    ));
  }

  FutureOr<void> dashLastMonthEvent(
      DashLastMonthEvent event, Emitter<DashState> emit) async {
    // Calculate first and last dates of the last month
    DateTime firstDateOfLastMonth = getFirstDateOfLastMonth();
    DateTime lastDateOfLastMonth = getLastDateOfLastMonth();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*
      FROM sale s
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);
    List<SaleTableModel> sales =
        saleRows.map((saleRow) => SaleTableModel.fromMap(saleRow)).toList();
    final netAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcTotalBill ?? 0.0));
    final dcPaidBillAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcPaidBillAmount ?? 0.0));

    emit(DashSuccessState(
      totalDiscount: 200,
      totalOrder: sales.length,
      totalSaleAmount: netAmount,
      paidBillAmount: dcPaidBillAmount,
      firstDate: firstDateStr,
      lastDate: lastDateStr,
    ));
  }

  FutureOr<void> dashThisQuarterEvent(
      DashThisQuarterEvent event, Emitter<DashState> emit) async {
    DateTime firstDateOfLastMonth =
        getFirstDateOfLastSixMonthsIncludingCurrent();
    DateTime lastDateOfLastMonth = getLastDateOfLastSixMonthsIncludingCurrent();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*
      FROM sale s
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);
    List<SaleTableModel> sales =
        saleRows.map((saleRow) => SaleTableModel.fromMap(saleRow)).toList();
    final netAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcTotalBill ?? 0.0));
    final dcPaidBillAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcPaidBillAmount ?? 0.0));

    emit(DashSuccessState(
      totalDiscount: 200,
      totalOrder: sales.length,
      totalSaleAmount: netAmount,
      paidBillAmount: dcPaidBillAmount,
      firstDate: firstDateStr,
      lastDate: lastDateStr,
    ));
  }

  FutureOr<void> dashThisYearEvent(
      DashThisYearEvent event, Emitter<DashState> emit) async {
    DateTime firstDateOfLastMonth = getFirstDateOfThisYear();
    DateTime lastDateOfLastMonth = getLastDateOfThisYear();

    // Format dates to strings using the provided formatDate function
    String firstDateStr = formatDate(firstDateOfLastMonth);
    String lastDateStr = formatDate(lastDateOfLastMonth);

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*
      FROM sale s
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [firstDateStr, lastDateStr]);
    List<SaleTableModel> sales =
        saleRows.map((saleRow) => SaleTableModel.fromMap(saleRow)).toList();
    final netAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcTotalBill ?? 0.0));
    final dcPaidBillAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcPaidBillAmount ?? 0.0));

    emit(DashSuccessState(
      totalDiscount: 200,
      totalOrder: sales.length,
      totalSaleAmount: netAmount,
      paidBillAmount: dcPaidBillAmount,
      firstDate: firstDateStr,
      lastDate: lastDateStr,
    ));
  }

  FutureOr<void> dashCustomDate(
      DashCustomDate event, Emitter<DashState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> saleRows = await db.rawQuery('''
      SELECT s.*
      FROM sale s
      WHERE s.dSaleDate BETWEEN ? AND ?
    ''', [event.fastDay, event.lastDay]);
    List<SaleTableModel> sales =
        saleRows.map((saleRow) => SaleTableModel.fromMap(saleRow)).toList();
    final netAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcTotalBill ?? 0.0));
    final dcPaidBillAmount =
        sales.fold(0.0, (sum, sale) => sum + (sale.dcPaidBillAmount ?? 0.0));

    emit(DashSuccessState(
      totalDiscount: 200,
      totalOrder: sales.length,
      totalSaleAmount: netAmount,
      paidBillAmount: dcPaidBillAmount,
      firstDate: event.fastDay,
      lastDate: event.lastDay,
    ));
  }
}
