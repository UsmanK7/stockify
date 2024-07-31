import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_event.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_state.dart';
import 'package:okra_distributer/view/sale/data/billed_items.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleBloc() : super(SaleInitialState()) {
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
      SaleInitalEvent event, Emitter<SaleState> emit) async {
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
      SaleDropdownSelectEvent event, Emitter<SaleState> emit) async {
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
      SaleUnitSelectedEvent event, Emitter<SaleState> emit) async {
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
      BonusQuantityChangeEvent event, Emitter<SaleState> emit) {
    emit(BonusQuantityChangeState(newValue: event.newValue));
  }

  FutureOr<void> refreshEvent(RefreshEvent event, Emitter<SaleState> emit) {
    emit(RefreshState());
  }

  FutureOr<void> addSaleInvoice(
      AddSaleInvoice event, Emitter<SaleState> emit) async {
    DBHelper dbHelper = DBHelper();

    final db = await dbHelper.database;
    await db.insert(
      'sale',
      {
        'iPermanentCustomerID': event.selectedCustomerId,
        'dcTotalBill': event.dcTotalBill,
        'dcGrandTotal': event.dcGrandTotal,
        // 'sSaleStatus':
        //     dcTotalBill == dcPaidBillAmount ? "netsale" : "creditsale",
        'dcPaidBillAmount': event.dcPaidBillAmount,
        'iBankIDPaidAmount': event.iBankIDPAIDAmount,
        'dcTotalDiscount': event.dctotaldiscount,
        'sSyncStatus': event.sSyncStatus,
        'dSaleDate': event.dSaleDate,
        'dtCreatedDate': event.dtCreatedDate,
      },
    );
    final List<Map<String, dynamic>> result = await db.query(
      'sale',
      columns: ['iSaleID'],
      orderBy: 'iSaleID DESC',
      limit: 1,
    );

    int lastSaleID = result.isNotEmpty ? result.first['iSaleID'] as int : 0;
    print(billedItems);
    for (int i = 0; i < billedItems.length; i++) {
      print("loop run");
      List<Map<String, dynamic>> product = await db.query('product');
      int iProductID = product[billedItems[i].productIndex]['iProductID'];
      if (billedItems[i].unitType == 0) {
        await db.insert(
          'sale_products_list',
          {
            'iProductID': iProductID,
            'iSaleID': lastSaleID,
            'sSaleQtyInBaseUnit': billedItems[i].Qty,
            'sSaleQtyInSecUnit': null,
            'sSaleBonusInBaseUnit': billedItems[i].bonusQty.toString(),
            'sSaleBonusInSecUnit': null,
            'sSaleTotalInBaseUnitQty':
                (billedItems[i].Qty + billedItems[i].bonusQty).toString(),
            'sSaleTotalInSecUnitQty': null,
            'dcSalePricePerBaseUnit': billedItems[i].price,
            'dcSalePriceSecUnit': null,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit':
                billedItems[i].price * billedItems[i].Qty,
            'dcToalSalePriceInSecUnit': null,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            'sSaleType': billedItems[i].sSaleType,
            'sSaleStatus': billedItems[i].sSaleStatus,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                billedItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': billedItems[i].disountNumber,
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
      } else if (billedItems[i].unitType == 1) {
        await db.insert(
          'sale_products_list',
          {
            'iProductID': iProductID,
            'iSaleID': lastSaleID,
            'sSaleQtyInBaseUnit': null,
            'sSaleType': billedItems[i].sSaleType,
            'sSaleStatus': billedItems[i].sSaleStatus,
            'sSaleQtyInSecUnit': billedItems[i].Qty,
            'sSaleBonusInBaseUnit': null,
            'sSaleBonusInSecUnit': billedItems[i].bonusQty.toString(),
            'sSaleTotalInBaseUnitQty': null,
            'sSaleTotalInSecUnitQty':
                (billedItems[i].Qty + billedItems[i].bonusQty).toString(),
            'dcSalePricePerBaseUnit': null,
            'dcSalePriceSecUnit': billedItems[i].price,
            // 'iPermanentCustomerID': iPermanentCustomerID,
            'dcToalSalePriceInBaseUnit': null,
            'dcToalSalePriceInSecUnit':
                billedItems[i].price * billedItems[i].Qty,
            // 'dcPurchaseValuePricePerBaseUnit': dcPurchaseValuePricePerBaseUnit,
            // 'dcPurchaseValuePerSecUnit': dcPurchaseValuePerSecUnit,
            // 'dcProfitValuePricePerBaeUnit': dcProfitValuePricePerBaeUnit,
            // 'dcProfitValuePerSecUnit': dcProfitValuePerSecUnit,
            // 'dcTotalProductSaleProfit': dcTotalProductSaleProfit,
            // 'iTaxCodeID': iTaxCodeID,
            // 'dcSaleTax': dcSaleTax,
            'sDiscountInPercentage':
                billedItems[i].discountPercentage.toString(),
            'dcDiscountInAmount': billedItems[i].disountNumber,
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
    billedItems = [];
    emit(FormAddedState());
  }

  FutureOr<void> saleAdddingLoadingEvent(
      SaleAdddingLoadingEvent event, Emitter<SaleState> emit) {
    emit(FormAddingLoadingState());
  }

  FutureOr<void> formErrorEvent(FormErrorEvent event, Emitter<SaleState> emit) {
    emit(FormErrorState());
  }
}
