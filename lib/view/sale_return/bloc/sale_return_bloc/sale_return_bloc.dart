import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/view/sale_return/bloc/sale_return_bloc/sale_return_event.dart';
import 'package:okra_distributer/view/sale_return/bloc/sale_return_bloc/sale_return_state.dart';
import 'package:okra_distributer/view/sale_return/data/sale_return_billed_items.dart';

class SaleReturnBloc extends Bloc<SaleReturnEvent, SaleReturnState> {
  SaleReturnBloc() : super(SaleInitialState()) {
    on<SaleInitalEvent>(saleInitalEvent);
    on<SaleDropdownSelectEvent>(saleDropdownSelectEvent);
    on<SaleUnitSelectedEvent>(saleUnitSelectedEvent);

    on<BonusQuantityChangeEvent>(bonusQuantityChangeEvent);
    on<RefreshEvent>(refreshEvent);
    on<AddSaleInvoice>(addSaleInvoice);
    on<SaleAdddingLoadingEvent>(saleAdddingLoadingEvent);
    on<FormErrorEvent>(formErrorEvent);
  }

  FutureOr<void> saleInitalEvent(
      SaleInitalEvent event, Emitter<SaleReturnState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> products = await db.query("product");
    emit(SaleLoadingState());
    List<String> items =
        products.map((e) => e['sProductName'] as String).toSet().toList();
    emit(SaleLoadedState());
    emit(SaleSuccessState(items: items, selectedItem: null));
  }

  FutureOr<void> saleDropdownSelectEvent(
      SaleDropdownSelectEvent event, Emitter<SaleReturnState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> products = await db.query("product");
    List<Map<String, dynamic>> units_table = await db.query("product_unit");

    int ProductIndex = products
        .indexWhere((product) => product['sProductName'] == event.selectedItem);

    int iBaseUnit = products[ProductIndex]['iBaseUnit'];
    int iSecondaryUnit = products[ProductIndex]['iSecondaryUnit'];
    print(iBaseUnit);
    print(iSecondaryUnit);
    bool boolBase = false;
    bool boolSec = false;
    List<int> units_number = [];
    List<String> units = [];
    if (iBaseUnit != 0) {
      units_number.add(iBaseUnit);
      boolBase = true;
      iBaseUnit--;
      units.add(units_table[iBaseUnit]["sUnitName"]);
    }
    if (iSecondaryUnit != 0) {
      boolSec = true;
      iSecondaryUnit--;
      units_number.add(iSecondaryUnit);
      units.add(units_table[iSecondaryUnit]["sUnitName"]);
    }

    emit(SaleSuccessState(
        items: event.products, selectedItem: event.selectedItem));
    emit(ProductSelectedState(
        selectedUnit: null,
        product_index: ProductIndex,
        unitBool: [boolBase, boolSec],
        units: units,
        units_number: units_number));
  }

  FutureOr<void> saleUnitSelectedEvent(
      SaleUnitSelectedEvent event, Emitter<SaleReturnState> emit) async {
    emit(ProductSelectedState(
        unitBool: event.unitBool,
        units: event.units,
        product_index: event.product_index,
        units_number: event.units_number,
        selectedUnit: event.selectedUnit));

    int baseUnit = 0;
    int secUnit = 0;
    String sSaleType = '';
    String sSaleStatus = '';
    if (event.unitBool[0] == true && event.unitBool[1] == true) {
      if (event.units[0] == event.selectedUnit) {
        baseUnit = 1;
        sSaleStatus = event.units_number[0].toString();
        sSaleType = 'baseunit';
      }
      if (event.units[1] == event.selectedUnit) {
        secUnit = 1;
        sSaleStatus = event.units_number[1].toString();
        sSaleType = 'secunit';
      }
    } else if (event.unitBool[0]) {
      sSaleType = 'baseunit';
      sSaleStatus = event.units_number[0].toString();
      baseUnit = 1;
    } else if (event.unitBool[1]) {
      sSaleType = 'secunit';
      sSaleStatus = event.units_number[1].toString();
      secUnit = 1;
    }

    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> products = await db.query("product");
    double price = 0.0;
    String StockQTY = "";
    if (baseUnit == 1) {
      StockQTY =
          products[event.product_index]['sTotalBaseUnitStockQty'].toString();
      price = double.parse(products[event.product_index]
              ['dcPurcasePerBaseUnitPrice']
          .toString());
    }
    if (secUnit == 1) {
      StockQTY = products[event.product_index]['sTotalSecondaryUnitStockQty']
          .toString();
      price = double.parse(products[event.product_index]
              ['dcPurchasePerSecondaryUnitPrice']
          .toString());
    }
    double total_price = price * double.parse(StockQTY);
    int unit_type = 0;
    if (baseUnit == 1) {
      unit_type = 0;
    } else if (secUnit == 1) {
      unit_type = 1;
    }
    emit(SaleUnitSelectedState(
      StockQTY: StockQTY,
      sSaleType: sSaleType,
      sSaleStatus: sSaleStatus,
      total_price: total_price,
      price: price,
      unit_type: unit_type,
    ));
  }

  FutureOr<void> bonusQuantityChangeEvent(
      BonusQuantityChangeEvent event, Emitter<SaleReturnState> emit) {
    emit(BonusQuantityChangeState(newValue: event.newValue));
  }

  FutureOr<void> refreshEvent(
      RefreshEvent event, Emitter<SaleReturnState> emit) {
    emit(RefreshState());
  }

  FutureOr<void> addSaleInvoice(
      AddSaleInvoice event, Emitter<SaleReturnState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;

    int lastid = await db.insert(
      'sale_order',
      {
        'iPermanentCustomerID': event.selectedCustomerId,
        'dcTotalBill': event.dcTotalBill,
        'dcGrandTotal': event.dcGrandTotal,
        // 'sSaleStatus':
        //     dcTotalBill == dcPaidBillAmount ? "netsale" : "creditsale",
        // 'dcPaidBillAmount': event.dcPaidBillAmount,
        // 'iBankIDPaidAmount': event.iBankIDPAIDAmount,
        'dcTotalDiscount': event.dctotaldiscount,
        'sSyncStatus': event.sSyncStatus,
        'dSaleOrderDate': event.dSaleDate,
        'dtCreatedDate': event.dtCreatedDate,
      },
    );

    final Uri url = Uri.parse(
        'https://02bb-39-44-67-217.ngrok-free.app/stockfiy/api/realdata/storesaleorder');
    final _box = GetStorage();
    final authorization_token = _box.read('token');
    final iFirmID = _box.read('iFirmID');
    final iSystemUserID = _box.read('iSystemUserID');

    final headers = {'Content-Type': 'application/json'};
    print("authorization token: ${authorization_token}");
    final body = {
      "authorization_token": authorization_token,
      "iSystemUserID": iSystemUserID,
      "iFirmID": iFirmID ?? 0,
      "iPermanentCustomerID": event.selectedCustomerId,
      "dcTotalBill": event.dcTotalBill,
      "dcGrandTotal": event.dcGrandTotal,
      "dcOnProuctDiscount": 00,
      "dcExtraDiscount": 00,
      "dcTotalDiscount": event.dctotaldiscount,
      // "sSyncStatus": 0,
      "dSaleOrderDate": event.dSaleDate,
      "dtDueDate": "0000-00-00",
      "dtCreatedDate": "0000-00-00",
      "iAddedBy": 00,
      "dtUpdatedDate": "0000-00-00",
      "iUpdatedBy": 00,
      "dtDeletedDate": "0000-00-00",
      "iDeletedBy": 0,
      "iStoreID": 00,
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('error')) {
        print(jsonResponse['faced error']);
        // emit(InitialAuthState());
      } else if (jsonResponse.containsKey('success')) {
        print(jsonResponse['success']);
        List<Map<String, dynamic>> beforeUpdate = await db.query(
          'sale_order',
          where: 'iSaleOrderID = ?',
          whereArgs: [lastid],
        );
        print('Before update: $beforeUpdate');
        await db.update(
          'sale_order',
          {
            'sSyncStatus': 1,
          },
          where: 'iSaleOrderID = ?',
          whereArgs: [lastid],
        );
        List<Map<String, dynamic>> afterUpdate = await db.query(
          'sale_order',
          where: 'iSaleOrderID = ?',
          whereArgs: [lastid],
        );
        print('Before update: $afterUpdate');
      }
    } else {
      print("Erorr: ${response.statusCode}");
      print("Error body: ${response.body}");
    }

    final List<Map<String, dynamic>> result = await db.query(
      'sale_order',
      columns: ['iSaleOrderID'],
      orderBy: 'iSaleOrderID DESC',
      limit: 1,
    );

    int lastSaleID =
        result.isNotEmpty ? result.first['iSaleOrderID'] as int : 0;

    for (int i = 0; i < SaleReturnbilledItems.length; i++) {
      List<Map<String, dynamic>> product = await db.query('product');
      int iProductID =
          product[SaleReturnbilledItems[i].productIndex]['iProductID'];
      if (SaleReturnbilledItems[i].unitType == 0) {
        await db.insert(
          'sale_order_products_list',
          {
            'iProductID': iProductID,
            'iSaleOrderID': lastSaleID,
            'sSaleQtyInBaseUnit': SaleReturnbilledItems[i].Qty,
            'sSaleQtyInSecUnit': null,
            'sSaleBonusInBaseUnit':
                SaleReturnbilledItems[i].bonusQty.toString(),
            'sSaleBonusInSecUnit': null,
            'sSaleTotalInBaseUnitQty': (SaleReturnbilledItems[i].Qty +
                    SaleReturnbilledItems[i].bonusQty)
                .toString(),
            'sSaleTotalInSecUnitQty': null,
            'dcSalePricePerBaseUnit': SaleReturnbilledItems[i].price,
            'dcSalePriceSecUnit': null,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit':
                SaleReturnbilledItems[i].price * SaleReturnbilledItems[i].Qty,
            'dcToalSalePriceInSecUnit': null,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            'sSaleType': SaleReturnbilledItems[i].sSaleType,
            'sSaleStatus': SaleReturnbilledItems[i].sSaleStatus,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                SaleReturnbilledItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': SaleReturnbilledItems[i].disountNumber,
            // 'dcExtraDiscount': dcExtraDiscount,
            // 'dcTotalDiscountInVal': dcTotalDiscountInVal,
            // 'iExtra_Charges_ID': iExtra_Charges_ID,
            // 'sExtraChargesAmount': sExtraChargesAmount,
            'dSaleDate': dSaleDate,
            // 'sCustomerInvoiceNo': sCustomerInvoiceNo,
            // 'sSaleStatus':
            //     dcTotalBill == dcPaidBillAmount ? "netsale" : "creditsale",
            // 'sSaleType': sSaleType,
            // 'sClaim': sClaim,
            // 'bStatus': bStatus,
            'sSyncStatus': "0",
            'sEntrySource': "mobile",
            'sAction': "add",
            'dtCreatedDate': dtCreatedDate,
            // 'iAddedBy': iAddedBy,
            // 'dtUpdatedDate': dtUpdatedDate,
            // 'iUpdatedBy': iUpdatedBy,
            // 'dtDeletedDate': dtDeletedDate,
            // 'iDeletedBy': iDeletedBy,
          },
        );
      } else if (SaleReturnbilledItems[i].unitType == 1) {
        await db.insert(
          'sale_order_products_list',
          {
            'iProductID': iProductID,
            'iSaleOrderID': lastSaleID,
            'sSaleQtyInBaseUnit': null,
            'sSaleType': SaleReturnbilledItems[i].sSaleType,
            'sSaleStatus': SaleReturnbilledItems[i].sSaleStatus,
            'sSaleQtyInSecUnit': SaleReturnbilledItems[i].Qty,
            'sSaleBonusInBaseUnit': null,
            'sSaleBonusInSecUnit': SaleReturnbilledItems[i].bonusQty.toString(),
            'sSaleTotalInBaseUnitQty': null,
            'sSaleTotalInSecUnitQty': (SaleReturnbilledItems[i].Qty +
                    SaleReturnbilledItems[i].bonusQty)
                .toString(),
            'dcSalePricePerBaseUnit': null,
            'dcSalePriceSecUnit': SaleReturnbilledItems[i].price,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit': null,
            'dcToalSalePriceInSecUnit':
                SaleReturnbilledItems[i].price * SaleReturnbilledItems[i].Qty,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                SaleReturnbilledItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': SaleReturnbilledItems[i].disountNumber,
            // 'dcExtraDiscount': dcExtraDiscount,
            // 'dcTotalDiscountInVal': dcTotalDiscountInVal,
            // 'iExtra_Charges_ID': iExtra_Charges_ID,
            // 'sExtraChargesAmount': sExtraChargesAmount,
            'dSaleDate': dSaleDate,
            // 'sCustomerInvoiceNo': sCustomerInvoiceNo,

            // 'sSaleType': sSaleType,
            // 'sClaim': sClaim,
            // 'bStatus': bStatus,
            'sSyncStatus': "0",
            'sEntrySource': "mobile",
            'sAction': "add",
            'dtCreatedDate': dtCreatedDate,
            // 'iAddedBy': iAddedBy,
            // 'dtUpdatedDate': dtUpdatedDate,
            // 'iUpdatedBy': iUpdatedBy,
            // 'dtDeletedDate': dtDeletedDate,
            // 'iDeletedBy': iDeletedBy,
          },
        );
      }
    }

    SaleReturnbilledItems = [];
    emit(FormAddedState());
  }

  FutureOr<void> saleAdddingLoadingEvent(
      SaleAdddingLoadingEvent event, Emitter<SaleReturnState> emit) {
    emit(FormAddingLoadingState());
  }

  FutureOr<void> formErrorEvent(
      FormErrorEvent event, Emitter<SaleReturnState> emit) {
    emit(FormErrorState());
  }
}
