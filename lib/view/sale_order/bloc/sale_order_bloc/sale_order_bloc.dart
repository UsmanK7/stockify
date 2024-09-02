import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_event.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_state.dart';
import 'package:okra_distributer/view/sale_order/data/sale_order_billed_items.dart';

class SaleOrderBloc extends Bloc<SaleOrderEvent, SaleOrderState> {
  SaleOrderBloc() : super(SaleInitialState()) {
    on<SaleInitalEvent>(saleInitalEvent);
    on<SaleDropdownSelectEvent>(saleDropdownSelectEvent);
    on<SaleUnitSelectedEvent>(saleUnitSelectedEvent);

    on<BonusQuantityChangeEvent>(bonusQuantityChangeEvent);
    on<RefreshEvent>(refreshEvent);
    on<AddSaleInvoice>(addSaleInvoice);
    on<AddSalePrintInvoice>(addSalePrintInvoice);
    on<SaleAdddingLoadingEvent>(saleAdddingLoadingEvent);
    on<SaleAdddingLoadingPrintEvent>(saleAdddingLoadingPrintEvent);
    on<FormErrorEvent>(formErrorEvent);
  }

  FutureOr<void> saleInitalEvent(
      SaleInitalEvent event, Emitter<SaleOrderState> emit) async {
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
      SaleDropdownSelectEvent event, Emitter<SaleOrderState> emit) async {
    DBHelper dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> products = await db.query("product");
    List<Map<String, dynamic>> units_table = await db.query("product_unit");

    int ProductIndex = products
        .indexWhere((product) => product['sProductName'] == event.selectedItem);

    int iBaseUnit = products[ProductIndex]['iBaseUnit'];
    int iSecondaryUnit = products[ProductIndex]['iSecondaryUnit'];

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
      SaleUnitSelectedEvent event, Emitter<SaleOrderState> emit) async {
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
      BonusQuantityChangeEvent event, Emitter<SaleOrderState> emit) {
    emit(BonusQuantityChangeState(newValue: event.newValue));
  }

  FutureOr<void> refreshEvent(
      RefreshEvent event, Emitter<SaleOrderState> emit) {
    emit(RefreshState());
  }

  FutureOr<void> addSaleInvoice(
      AddSaleInvoice event, Emitter<SaleOrderState> emit) async {
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
        'transaction_id': "",
      },
    );

    final List<Map<String, dynamic>> result = await db.query(
      'sale_order',
      columns: ['iSaleOrderID'],
      orderBy: 'iSaleOrderID DESC',
      limit: 1,
    );

    int lastSaleID =
        result.isNotEmpty ? result.first['iSaleOrderID'] as int : 0;

    final List<Map<String, dynamic>> result2 = await db.query(
      'sale_order_products_list',
      columns: ['iSaleOrderProductID'],
      orderBy: 'iSaleOrderProductID DESC',
      limit: 1,
    );

    int lastISaleOrderProductId =
        result2.isNotEmpty ? result2.first['iSaleOrderProductID'] as int : 0;

    final allIsaleProductIds = [];

    for (int i = 0; i < SaleOrderbilledItems.length; i++) {
      int temp = i + 1;
      allIsaleProductIds.add(lastISaleOrderProductId + temp);

      List<Map<String, dynamic>> product = await db.query('product');
      int iProductID =
          product[SaleOrderbilledItems[i].productIndex]['iProductID'];
      if (SaleOrderbilledItems[i].unitType == 0) {
        await db.insert(
          'sale_order_products_list',
          {
            'iProductID': iProductID,
            'iSaleOrderID': lastSaleID,
            'sSaleQtyInBaseUnit': SaleOrderbilledItems[i].Qty,
            'sSaleQtyInSecUnit': null,
            'sSaleBonusInBaseUnit': SaleOrderbilledItems[i].bonusQty.toString(),
            'sSaleBonusInSecUnit': null,
            'sSaleTotalInBaseUnitQty':
                (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                    .toString(),
            'sSaleTotalInSecUnitQty': null,
            'dcSalePricePerBaseUnit': SaleOrderbilledItems[i].price,
            'dcSalePriceSecUnit': null,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit':
                SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
            'dcToalSalePriceInSecUnit': null,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            'sSaleType': SaleOrderbilledItems[i].sSaleType,
            'sSaleStatus': SaleOrderbilledItems[i].sSaleStatus,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                SaleOrderbilledItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': SaleOrderbilledItems[i].disountNumber,
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
            'transaction_id': "",
          },
        );
      } else if (SaleOrderbilledItems[i].unitType == 1) {
        await db.insert(
          'sale_order_products_list',
          {
            'iProductID': iProductID,
            'iSaleOrderID': lastSaleID,
            'sSaleQtyInBaseUnit': null,
            'sSaleType': SaleOrderbilledItems[i].sSaleType,
            'sSaleStatus': SaleOrderbilledItems[i].sSaleStatus,
            'sSaleQtyInSecUnit': SaleOrderbilledItems[i].Qty,
            'sSaleBonusInBaseUnit': null,
            'sSaleBonusInSecUnit': SaleOrderbilledItems[i].bonusQty.toString(),
            'sSaleTotalInBaseUnitQty': null,
            'sSaleTotalInSecUnitQty':
                (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                    .toString(),
            'dcSalePricePerBaseUnit': null,
            'dcSalePriceSecUnit': SaleOrderbilledItems[i].price,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit': null,
            'dcToalSalePriceInSecUnit':
                SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                SaleOrderbilledItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': SaleOrderbilledItems[i].disountNumber,
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
            'transaction_id': "",
          },
        );
      }
    }

    // API CALL
    final Uri url = Uri.parse(addSaleOrderUrl);
    final _box = GetStorage();
    final authorization_token = _box.read('token');
    final iFirmID = _box.read('iFirmID');
    final iSystemUserID = _box.read('iSystemUserID');

    final headers = {'Content-Type': 'application/json'};

    // final body = {
    //   "authorization_token": authorization_token,
    //   "sale_order": {
    //     "iSystemUserID": iSystemUserID,
    //     "iFirmID": iFirmID ?? 0,
    //     "iPermanentCustomerID": event.selectedCustomerId,
    //     "dcTotalBill": event.dcTotalBill,
    //     "dcGrandTotal": event.dcGrandTotal,
    //     "dcOnProuctDiscount": 00,
    //     "dcExtraDiscount": 00,
    //     "dcTotalDiscount": event.dctotaldiscount,
    //     // "sSyncStatus": 0,
    //     "dSaleOrderDate": event.dSaleDate,
    //     "dtDueDate": "0000-00-00",
    //     "dtCreatedDate": "0000-00-00",
    //     "iAddedBy": 00,
    //     "dtUpdatedDate": "0000-00-00",
    //     "iUpdatedBy": 00,
    //     "dtDeletedDate": "0000-00-00",
    //     "iDeletedBy": 00,
    //     "iStoreID": 00,
    //   },
    //   "sale_order_product_list": {
    //     "product_1": {
    //       "iSaleOrderProductID": 2,
    //       "iSaleOrderID": 1,
    //       "iProductID": 1,
    //       "iSystemUserID": 1,
    //       "iFirmID": 1,
    //       "sSaleQtyInBaseUnit": "10",
    //       "sSaleQtyInSecUnit": "5",
    //       "sSaleBonusInBaseUnit": "2",
    //       "sSaleBonusInSecUnit": "1",
    //       "sSaleTotalInBaseUnitQty": "12",
    //       "sSaleTotalInSecUnitQty": "6",
    //       "dcSalePricePerBaseUnit": 100.00,
    //       "dcSalePriceSecUnit": 50.00,
    //       "iPermanentCustomerID": 1,
    //       "dcToalSalePriceInBaseUnit": 1200.00,
    //       "dcToalSalePriceInSecUnit": 600.00,
    //       "dcPurchaseValuePricePerBaseUnit": 90.00,
    //       "dcPurchaseValuePerSecUnit": 45.00,
    //       "dcProfitValuePricePerBaeUnit": 10.00,
    //       "dcProfitValuePerSecUnit": 5.00,
    //       "dcTotalProductSaleProfit": 150.00,
    //       "iTaxCodeID": 1,
    //       "dcSaleTax": 10.00,
    //       "sDiscountInPercentage": "5%",
    //       "dcDiscountInAmount": 50.00,
    //       "dcExtraDiscount": 10.00,
    //       "dcTotalDiscountInVal": 60.00,
    //       "iExtra_Charges_ID": 1,
    //       "sExtraChargesAmount": "20",
    //       "dSaleDate": "2024-07-26",
    //       "sCustomerInvoiceNo": "INV12345",
    //       "sSaleStatus": "Completed",
    //       "sSaleType": "Retail",
    //       "sClaim": "None",
    //       "sSyncStatus": "0",
    //       "sEntrySource": "Manual",
    //       "bStatus": "Active",
    //       "sAction": "Insert",
    //       "dtCreatedDate": "2024-07-26T00:00:00",
    //       "iAddedBy": 1,
    //       "dtUpdatedDate": "2024-07-26T00:00:00",
    //       "iUpdatedBy": 1,
    //       "dtDeletedDate": "0000-00-00T00:00:00",
    //       "iDeletedBy": 0,
    //       "sCartonQty": "1",
    //       "sPacking": "Box"
    //     },
    //   }
    // };

    final saleOrderProductList = {};

    for (int i = 0; i < SaleOrderbilledItems.length; i++) {
      List<Map<String, dynamic>> product = await db.query('product');
      int iProductID =
          product[SaleOrderbilledItems[i].productIndex]['iProductID'];

      if (SaleOrderbilledItems[i].unitType == 0) {
        saleOrderProductList['product_${i + 1}'] = {
          "iSaleOrderProductID": allIsaleProductIds[i],
          "iSaleOrderID": lastSaleID,
          "iProductID": iProductID,
          "iSystemUserID": _box.read('iSystemUserID'),
          "iFirmID": _box.read('iFirmID'),
          "sSaleQtyInBaseUnit": SaleOrderbilledItems[i].Qty,
          "sSaleQtyInSecUnit": "",
          "sSaleBonusInBaseUnit": SaleOrderbilledItems[i].bonusQty.toString(),
          "sSaleBonusInSecUnit": "null",
          "sSaleTotalInBaseUnitQty":
              (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                  .toString(),
          "sSaleTotalInSecUnitQty": "null",
          "dcSalePricePerBaseUnit": SaleOrderbilledItems[i].price,
          "dcSalePriceSecUnit": 00,
          "iPermanentCustomerID": event.selectedCustomerId,
          "dcToalSalePriceInBaseUnit":
              SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
          "dcToalSalePriceInSecUnit": "null",
          "dcPurchaseValuePricePerBaseUnit": 00,
          "dcPurchaseValuePerSecUnit": 00,
          "dcProfitValuePricePerBaeUnit": 00,
          "dcProfitValuePerSecUnit": 00,
          "dcTotalProductSaleProfit": 00,
          "iTaxCodeID": 00,
          "dcSaleTax": 00,
          "sDiscountInPercentage":
              SaleOrderbilledItems[i].discountPercentage.toString(),
          "dcDiscountInAmount": SaleOrderbilledItems[i].disountNumber,
          "dcExtraDiscount": 00,
          "dcTotalDiscountInVal": 00,
          "iExtra_Charges_ID": 00,
          "sExtraChargesAmount": "",
          "dSaleDate": dSaleDate,
          "sCustomerInvoiceNo": "",
          "sSaleStatus": "",
          "sSaleType": "",
          "sClaim": "",
          "sSyncStatus": "",
          "sEntrySource": "mobile",
          "bStatus": "",
          "sAction": "add",
          "dtCreatedDate": dtCreatedDate,
          "iAddedBy": 00,
          "dtUpdatedDate": "",
          "iUpdatedBy": 00,
          "dtDeletedDate": "",
          "iDeletedBy": 0,
          "sCartonQty": "",
          "sPacking": ""
        };
      } else if (SaleOrderbilledItems[i].unitType == 1) {
        saleOrderProductList['product_${i + 1}'] = {
          "iSaleOrderProductID": allIsaleProductIds[i],
          "iSaleOrderID": lastSaleID,
          "iProductID": iProductID,
          "iSystemUserID": _box.read('iSystemUserID'),
          "iFirmID": _box.read('iFirmID'),
          "sSaleQtyInBaseUnit": "",
          "sSaleQtyInSecUnit": SaleOrderbilledItems[i].Qty,
          "sSaleBonusInBaseUnit": "",
          "sSaleBonusInSecUnit": SaleOrderbilledItems[i].bonusQty.toString(),
          "sSaleTotalInBaseUnitQty": "",
          "sSaleTotalInSecUnitQty":
              (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                  .toString(),
          "dcSalePricePerBaseUnit": 00,
          "dcSalePriceSecUnit": SaleOrderbilledItems[i].price,
          "iPermanentCustomerID": event.selectedCustomerId,
          "dcToalSalePriceInBaseUnit": 00,
          "dcToalSalePriceInSecUnit":
              SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
          "dcPurchaseValuePricePerBaseUnit": 00,
          "dcPurchaseValuePerSecUnit": 00,
          "dcProfitValuePricePerBaeUnit": 00,
          "dcProfitValuePerSecUnit": 00,
          "dcTotalProductSaleProfit": 00,
          "iTaxCodeID": 00,
          "dcSaleTax": 00,
          "sDiscountInPercentage":
              SaleOrderbilledItems[i].discountPercentage.toString(),
          "dcDiscountInAmount": SaleOrderbilledItems[i].disountNumber,
          "dcExtraDiscount": 00,
          "dcTotalDiscountInVal": 00,
          "iExtra_Charges_ID": 00,
          "sExtraChargesAmount": "",
          "dSaleDate": dSaleDate,
          "sCustomerInvoiceNo": "",
          "sSaleStatus": "",
          "sSaleType": "",
          "sClaim": "",
          "sSyncStatus": "",
          "sEntrySource": "mobile",
          "bStatus": "1",
          "sAction": "add",
          "dtCreatedDate": dtCreatedDate,
          "iAddedBy": 00,
          "dtUpdatedDate": "",
          "iUpdatedBy": 00,
          "dtDeletedDate": "",
          "iDeletedBy": 0,
          "sCartonQty": "",
          "sPacking": ""
        };
      }
    }

    int? appId = await dbHelper.getAppId();

    final body = {
      "authorization_token": authorization_token,
      "app_id": "${appId}",
      "data": {
        "sale_order__1": {
          "sale_order": {
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
            "iDeletedBy": 00,
            "iStoreID": 00,
          },
          "sale_order_product_list": saleOrderProductList
        },
        "sale_order__2": {
          "sale_order": {
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
            "iDeletedBy": 00,
            "iStoreID": 00,
          },
          "sale_order_product_list": saleOrderProductList
        },
      }
    };

    print(body);

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
          // String transaction_id = jsonResponse['transaction_id'];
          // print(transaction_id);
          print(jsonResponse);
          // Access the transactionIDs map
          Map<String, dynamic> transactionIDs = jsonResponse['transactionIDs'];

          // Create a list to store the transaction IDs
          List<String> transactionIDList = [];

          // Iterate over the map and add the values to the list
          transactionIDs.forEach((key, value) {
            transactionIDList.add(value);
          });

          // Print the list of transaction IDs
          print('Transaction IDs: $transactionIDList');

          try {
            await db.update(
              'sale_order',
              {
                'sSyncStatus': 1,
                'transaction_id': transactionIDList[0],
              },
              where: 'iSaleOrderID = ?',
              whereArgs: [lastid],
            );

            // Update sale_order_products_list with transaction_id
            for (int i = 0; i < allIsaleProductIds.length; i++) {
              try {
                await db.update(
                  'sale_order_products_list',
                  {
                    'transaction_id': transactionIDList[0],
                  },
                  where: 'iSaleOrderID = ?',
                  whereArgs: [allIsaleProductIds[i]],
                );
              } catch (e) {
                print(
                    'Error updating sale_order_products_list for product ID ${allIsaleProductIds[i]}: $e');
              }
            }
          } catch (e) {
            print('Error updating sale_order: $e');
          }
        }
      } else {
        print("Error: ${response.statusCode}");
        print("Error body: ${response.body}");
      }
    } catch (e) {
      print('Request failed: $e');
    }

    SaleOrderbilledItems = [];
    emit(FormAddedState());
  }

  FutureOr<void> saleAdddingLoadingEvent(
      SaleAdddingLoadingEvent event, Emitter<SaleOrderState> emit) {
    emit(FormAddingLoadingState());
  }

  FutureOr<void> formErrorEvent(
      FormErrorEvent event, Emitter<SaleOrderState> emit) {
    emit(FormErrorState());
  }

  FutureOr<void> saleAdddingLoadingPrintEvent(
      SaleAdddingLoadingPrintEvent event, Emitter<SaleOrderState> emit) {
    emit(FormAddingLoadingPrintState());
  }

  FutureOr<void> addSalePrintInvoice(
      AddSalePrintInvoice event, Emitter<SaleOrderState> emit) async {
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
        'transaction_id': "",
      },
    );

    final List<Map<String, dynamic>> result = await db.query(
      'sale_order',
      columns: ['iSaleOrderID'],
      orderBy: 'iSaleOrderID DESC',
      limit: 1,
    );

    int lastSaleID =
        result.isNotEmpty ? result.first['iSaleOrderID'] as int : 0;

    final List<Map<String, dynamic>> result2 = await db.query(
      'sale_order_products_list',
      columns: ['iSaleOrderProductID'],
      orderBy: 'iSaleOrderProductID DESC',
      limit: 1,
    );

    int lastISaleOrderProductId =
        result2.isNotEmpty ? result2.first['iSaleOrderProductID'] as int : 0;

    final allIsaleProductIds = [];

    for (int i = 0; i < SaleOrderbilledItems.length; i++) {
      int temp = i + 1;
      allIsaleProductIds.add(lastISaleOrderProductId + temp);

      List<Map<String, dynamic>> product = await db.query('product');
      int iProductID =
          product[SaleOrderbilledItems[i].productIndex]['iProductID'];
      if (SaleOrderbilledItems[i].unitType == 0) {
        await db.insert(
          'sale_order_products_list',
          {
            'iProductID': iProductID,
            'iSaleOrderID': lastSaleID,
            'sSaleQtyInBaseUnit': SaleOrderbilledItems[i].Qty,
            'sSaleQtyInSecUnit': null,
            'sSaleBonusInBaseUnit': SaleOrderbilledItems[i].bonusQty.toString(),
            'sSaleBonusInSecUnit': null,
            'sSaleTotalInBaseUnitQty':
                (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                    .toString(),
            'sSaleTotalInSecUnitQty': null,
            'dcSalePricePerBaseUnit': SaleOrderbilledItems[i].price,
            'dcSalePriceSecUnit': null,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit':
                SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
            'dcToalSalePriceInSecUnit': null,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            'sSaleType': SaleOrderbilledItems[i].sSaleType,
            'sSaleStatus': SaleOrderbilledItems[i].sSaleStatus,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                SaleOrderbilledItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': SaleOrderbilledItems[i].disountNumber,
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
            'transaction_id': "",
          },
        );
      } else if (SaleOrderbilledItems[i].unitType == 1) {
        await db.insert(
          'sale_order_products_list',
          {
            'iProductID': iProductID,
            'iSaleOrderID': lastSaleID,
            'sSaleQtyInBaseUnit': null,
            'sSaleType': SaleOrderbilledItems[i].sSaleType,
            'sSaleStatus': SaleOrderbilledItems[i].sSaleStatus,
            'sSaleQtyInSecUnit': SaleOrderbilledItems[i].Qty,
            'sSaleBonusInBaseUnit': null,
            'sSaleBonusInSecUnit': SaleOrderbilledItems[i].bonusQty.toString(),
            'sSaleTotalInBaseUnitQty': null,
            'sSaleTotalInSecUnitQty':
                (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                    .toString(),
            'dcSalePricePerBaseUnit': null,
            'dcSalePriceSecUnit': SaleOrderbilledItems[i].price,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit': null,
            'dcToalSalePriceInSecUnit':
                SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                SaleOrderbilledItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': SaleOrderbilledItems[i].disountNumber,
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
            'transaction_id': "",
          },
        );
      }
    }

    // API CALL
    final Uri url = Uri.parse(addSaleOrderUrl);
    final _box = GetStorage();
    final authorization_token = _box.read('token');
    final iFirmID = _box.read('iFirmID');
    final iSystemUserID = _box.read('iSystemUserID');

    final headers = {'Content-Type': 'application/json'};

    // final body = {
    //   "authorization_token": authorization_token,
    //   "sale_order": {
    //     "iSystemUserID": iSystemUserID,
    //     "iFirmID": iFirmID ?? 0,
    //     "iPermanentCustomerID": event.selectedCustomerId,
    //     "dcTotalBill": event.dcTotalBill,
    //     "dcGrandTotal": event.dcGrandTotal,
    //     "dcOnProuctDiscount": 00,
    //     "dcExtraDiscount": 00,
    //     "dcTotalDiscount": event.dctotaldiscount,
    //     // "sSyncStatus": 0,
    //     "dSaleOrderDate": event.dSaleDate,
    //     "dtDueDate": "0000-00-00",
    //     "dtCreatedDate": "0000-00-00",
    //     "iAddedBy": 00,
    //     "dtUpdatedDate": "0000-00-00",
    //     "iUpdatedBy": 00,
    //     "dtDeletedDate": "0000-00-00",
    //     "iDeletedBy": 00,
    //     "iStoreID": 00,
    //   },
    //   "sale_order_product_list": {
    //     "product_1": {
    //       "iSaleOrderProductID": 2,
    //       "iSaleOrderID": 1,
    //       "iProductID": 1,
    //       "iSystemUserID": 1,
    //       "iFirmID": 1,
    //       "sSaleQtyInBaseUnit": "10",
    //       "sSaleQtyInSecUnit": "5",
    //       "sSaleBonusInBaseUnit": "2",
    //       "sSaleBonusInSecUnit": "1",
    //       "sSaleTotalInBaseUnitQty": "12",
    //       "sSaleTotalInSecUnitQty": "6",
    //       "dcSalePricePerBaseUnit": 100.00,
    //       "dcSalePriceSecUnit": 50.00,
    //       "iPermanentCustomerID": 1,
    //       "dcToalSalePriceInBaseUnit": 1200.00,
    //       "dcToalSalePriceInSecUnit": 600.00,
    //       "dcPurchaseValuePricePerBaseUnit": 90.00,
    //       "dcPurchaseValuePerSecUnit": 45.00,
    //       "dcProfitValuePricePerBaeUnit": 10.00,
    //       "dcProfitValuePerSecUnit": 5.00,
    //       "dcTotalProductSaleProfit": 150.00,
    //       "iTaxCodeID": 1,
    //       "dcSaleTax": 10.00,
    //       "sDiscountInPercentage": "5%",
    //       "dcDiscountInAmount": 50.00,
    //       "dcExtraDiscount": 10.00,
    //       "dcTotalDiscountInVal": 60.00,
    //       "iExtra_Charges_ID": 1,
    //       "sExtraChargesAmount": "20",
    //       "dSaleDate": "2024-07-26",
    //       "sCustomerInvoiceNo": "INV12345",
    //       "sSaleStatus": "Completed",
    //       "sSaleType": "Retail",
    //       "sClaim": "None",
    //       "sSyncStatus": "0",
    //       "sEntrySource": "Manual",
    //       "bStatus": "Active",
    //       "sAction": "Insert",
    //       "dtCreatedDate": "2024-07-26T00:00:00",
    //       "iAddedBy": 1,
    //       "dtUpdatedDate": "2024-07-26T00:00:00",
    //       "iUpdatedBy": 1,
    //       "dtDeletedDate": "0000-00-00T00:00:00",
    //       "iDeletedBy": 0,
    //       "sCartonQty": "1",
    //       "sPacking": "Box"
    //     },
    //   }
    // };

    final saleOrderProductList = {};

    for (int i = 0; i < SaleOrderbilledItems.length; i++) {
      List<Map<String, dynamic>> product = await db.query('product');
      int iProductID =
          product[SaleOrderbilledItems[i].productIndex]['iProductID'];

      if (SaleOrderbilledItems[i].unitType == 0) {
        saleOrderProductList['product_${i + 1}'] = {
          "iSaleOrderProductID": allIsaleProductIds[i],
          "iSaleOrderID": lastSaleID,
          "iProductID": iProductID,
          "iSystemUserID": _box.read('iSystemUserID'),
          "iFirmID": _box.read('iFirmID'),
          "sSaleQtyInBaseUnit": SaleOrderbilledItems[i].Qty,
          "sSaleQtyInSecUnit": "",
          "sSaleBonusInBaseUnit": SaleOrderbilledItems[i].bonusQty.toString(),
          "sSaleBonusInSecUnit": "null",
          "sSaleTotalInBaseUnitQty":
              (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                  .toString(),
          "sSaleTotalInSecUnitQty": "null",
          "dcSalePricePerBaseUnit": SaleOrderbilledItems[i].price,
          "dcSalePriceSecUnit": 00,
          "iPermanentCustomerID": event.selectedCustomerId,
          "dcToalSalePriceInBaseUnit":
              SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
          "dcToalSalePriceInSecUnit": "null",
          "dcPurchaseValuePricePerBaseUnit": 00,
          "dcPurchaseValuePerSecUnit": 00,
          "dcProfitValuePricePerBaeUnit": 00,
          "dcProfitValuePerSecUnit": 00,
          "dcTotalProductSaleProfit": 00,
          "iTaxCodeID": 00,
          "dcSaleTax": 00,
          "sDiscountInPercentage":
              SaleOrderbilledItems[i].discountPercentage.toString(),
          "dcDiscountInAmount": SaleOrderbilledItems[i].disountNumber,
          "dcExtraDiscount": 00,
          "dcTotalDiscountInVal": 00,
          "iExtra_Charges_ID": 00,
          "sExtraChargesAmount": "",
          "dSaleDate": dSaleDate,
          "sCustomerInvoiceNo": "",
          "sSaleStatus": "",
          "sSaleType": "",
          "sClaim": "",
          "sSyncStatus": "",
          "sEntrySource": "mobile",
          "bStatus": "",
          "sAction": "add",
          "dtCreatedDate": dtCreatedDate,
          "iAddedBy": 00,
          "dtUpdatedDate": "",
          "iUpdatedBy": 00,
          "dtDeletedDate": "",
          "iDeletedBy": 0,
          "sCartonQty": "",
          "sPacking": ""
        };
      } else if (SaleOrderbilledItems[i].unitType == 1) {
        saleOrderProductList['product_${i + 1}'] = {
          "iSaleOrderProductID": allIsaleProductIds[i],
          "iSaleOrderID": lastSaleID,
          "iProductID": iProductID,
          "iSystemUserID": _box.read('iSystemUserID'),
          "iFirmID": _box.read('iFirmID'),
          "sSaleQtyInBaseUnit": "",
          "sSaleQtyInSecUnit": SaleOrderbilledItems[i].Qty,
          "sSaleBonusInBaseUnit": "",
          "sSaleBonusInSecUnit": SaleOrderbilledItems[i].bonusQty.toString(),
          "sSaleTotalInBaseUnitQty": "",
          "sSaleTotalInSecUnitQty":
              (SaleOrderbilledItems[i].Qty + SaleOrderbilledItems[i].bonusQty)
                  .toString(),
          "dcSalePricePerBaseUnit": 00,
          "dcSalePriceSecUnit": SaleOrderbilledItems[i].price,
          "iPermanentCustomerID": event.selectedCustomerId,
          "dcToalSalePriceInBaseUnit": 00,
          "dcToalSalePriceInSecUnit":
              SaleOrderbilledItems[i].price * SaleOrderbilledItems[i].Qty,
          "dcPurchaseValuePricePerBaseUnit": 00,
          "dcPurchaseValuePerSecUnit": 00,
          "dcProfitValuePricePerBaeUnit": 00,
          "dcProfitValuePerSecUnit": 00,
          "dcTotalProductSaleProfit": 00,
          "iTaxCodeID": 00,
          "dcSaleTax": 00,
          "sDiscountInPercentage":
              SaleOrderbilledItems[i].discountPercentage.toString(),
          "dcDiscountInAmount": SaleOrderbilledItems[i].disountNumber,
          "dcExtraDiscount": 00,
          "dcTotalDiscountInVal": 00,
          "iExtra_Charges_ID": 00,
          "sExtraChargesAmount": "",
          "dSaleDate": dSaleDate,
          "sCustomerInvoiceNo": "",
          "sSaleStatus": "",
          "sSaleType": "",
          "sClaim": "",
          "sSyncStatus": "",
          "sEntrySource": "mobile",
          "bStatus": "1",
          "sAction": "add",
          "dtCreatedDate": dtCreatedDate,
          "iAddedBy": 00,
          "dtUpdatedDate": "",
          "iUpdatedBy": 00,
          "dtDeletedDate": "",
          "iDeletedBy": 0,
          "sCartonQty": "",
          "sPacking": ""
        };
      }
    }

    int? appId = await dbHelper.getAppId();

    final body = {
      "authorization_token": authorization_token,
      "app_id": "${appId}",
      "data": {
        "sale_order__1": {
          "sale_order": {
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
            "iDeletedBy": 00,
            "iStoreID": 00,
          },
          "sale_order_product_list": saleOrderProductList
        },
        "sale_order__2": {
          "sale_order": {
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
            "iDeletedBy": 00,
            "iStoreID": 00,
          },
          "sale_order_product_list": saleOrderProductList
        },
      }
    };

    print(body);

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
          // String transaction_id = jsonResponse['transaction_id'];
          // print(transaction_id);
          print(jsonResponse);
          // Access the transactionIDs map
          Map<String, dynamic> transactionIDs = jsonResponse['transactionIDs'];

          // Create a list to store the transaction IDs
          List<String> transactionIDList = [];

          // Iterate over the map and add the values to the list
          transactionIDs.forEach((key, value) {
            transactionIDList.add(value);
          });

          // Print the list of transaction IDs
          print('Transaction IDs: $transactionIDList');

          try {
            await db.update(
              'sale_order',
              {
                'sSyncStatus': 1,
                'transaction_id': transactionIDList[0],
              },
              where: 'iSaleOrderID = ?',
              whereArgs: [lastid],
            );

            // Update sale_order_products_list with transaction_id
            for (int i = 0; i < allIsaleProductIds.length; i++) {
              try {
                await db.update(
                  'sale_order_products_list',
                  {
                    'transaction_id': transactionIDList[0],
                  },
                  where: 'iSaleOrderID = ?',
                  whereArgs: [allIsaleProductIds[i]],
                );
              } catch (e) {
                print(
                    'Error updating sale_order_products_list for product ID ${allIsaleProductIds[i]}: $e');
              }
            }
          } catch (e) {
            print('Error updating sale_order: $e');
          }
        }
      } else {
        print("Error: ${response.statusCode}");
        print("Error body: ${response.body}");
      }
    } catch (e) {
      print('Request failed: $e');
    }

    SaleOrderbilledItems = [];
    emit(FormAddedPrintState());
  }
}
