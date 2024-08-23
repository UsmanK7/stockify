import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/sale_order/data/sale_order_billed_items.dart';

import 'package:okra_distributer/view/sale/model/product_model.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_bloc.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_state.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_event.dart';

class AddOrderItem extends StatefulWidget {
  const AddOrderItem({super.key});

  @override
  State<AddOrderItem> createState() => _AddOrderItemState();
}

class _AddOrderItemState extends State<AddOrderItem> {
  @override
  void initState() {
    saleOrderBloc.add(SaleInitalEvent());

    super.initState();
  }

  String ProductName = "";
  String selectedUnit = "";

  SaleOrderBloc saleOrderBloc = SaleOrderBloc();
  int unitTpe = 0;
  int? selectedProductIndex;

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController QTYController = TextEditingController();
  final TextEditingController BonusQTYController = TextEditingController();
  final TextEditingController NDiscountController = TextEditingController();
  final TextEditingController PDiscountController = TextEditingController();
  bool qtyPriceChangeEventTriggered = false;
  String sSaleStatus = '';
  String sSaleType = '';

  @override
  void dispose() {
    textEditingController.dispose();
    priceController.dispose();
    QTYController.dispose();
    BonusQTYController.dispose();
    NDiscountController.dispose();
    PDiscountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("widget rebuild");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBlue,
        title: AppText(
          color: Colors.white,
          title: "Add Sale Order Item",
          font_size: 18.0,
          fontWeight: FontWeight.w300,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: AppTotalScreenHeight(context),
          width: AppTotalScreenWidth(context),
          decoration: BoxDecoration(
              color: appBgWhite,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 35),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<SaleOrderBloc, SaleOrderState>(
                      bloc: saleOrderBloc,
                      buildWhen: (previous, current) =>
                          current is SaleSuccessState,
                      builder: (context, state) {
                        if (state is SaleLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SaleSuccessState) {
                          return Container(
                            width: AppTotalScreenWidth(context) / 1.8,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: appborder),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: state.items
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: state.selectedItem,
                                onChanged: (value) {
                                  ProductName = value!;
                                  saleOrderBloc.add(SaleDropdownSelectEvent(
                                      selectedItem: value!,
                                      products: state.items));
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                  width: 200,
                                ),
                                dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 200,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                                dropdownSearchData: DropdownSearchData(
                                  searchController: textEditingController,
                                  searchInnerWidgetHeight: 50,
                                  searchInnerWidget: Container(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 4,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: TextFormField(
                                      expands: true,
                                      maxLines: null,
                                      controller: textEditingController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: 'Search for an item...',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return item.value
                                        .toString()
                                        .contains(searchValue);
                                  },
                                ),
                                //This to clear the search value when you close the menu
                                onMenuStateChange: (isOpen) {
                                  if (!isOpen) {
                                    textEditingController.clear();
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: AppTotalScreenWidth(context) / 1.8,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ); // or some default widget
                        }
                      },
                    ),
                    SizedBox(width: 5),
                    BlocBuilder<SaleOrderBloc, SaleOrderState>(
                        bloc: saleOrderBloc,
                        buildWhen: (previous, current) =>
                            current is ProductSelectedState,
                        builder: (context, state) {
                          if (state is ProductSelectedState) {
                            selectedProductIndex = state.product_index;
                            return Expanded(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: appborder),
                                    borderRadius: BorderRadius.circular(16)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'Unit',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: state.units
                                        .map((item) => DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: state.selectedUnit,
                                    onChanged: (value) {
                                      selectedUnit = value!;
                                      saleOrderBloc.add(SaleUnitSelectedEvent(
                                          selectedUnit: value!,
                                          product_index: state.product_index,
                                          units: state.units,
                                          unitBool: state.unitBool,
                                          units_number: state.units_number));
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 200,
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),

                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        textEditingController.clear();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Container(
                                height: 45,
                                padding: EdgeInsets.only(left: 6, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: appborder),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        title: "Units",
                                        color: apptextColor,
                                        font_size: 16.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      Icon(Icons.arrow_drop_down)
                                    ]),
                              ),
                            );
                          }
                        })
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                BlocConsumer<SaleOrderBloc, SaleOrderState>(
                  bloc: saleOrderBloc,
                  listener: (context, state) {},
                  // buildWhen: (current, previous) =>
                  //     current is SaleUnitSelectedState,
                  builder: (context, state) {
                    if (state is SaleUnitSelectedState) {
                      if (qtyPriceChangeEventTriggered == false) {
                        priceController.text = state.price.toString();
                        // QTYController.text = state.StockQTY.toString();
                      }
                      sSaleStatus = state.sSaleStatus;
                      sSaleType = state.sSaleType;
                      unitTpe = state.unit_type;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: AppTotalScreenWidth(context) / 1.8,
                                  padding: EdgeInsets.only(left: 10),
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: appborder),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: TextField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      // qtyPriceChangeEventTriggered = true;
                                      // if (value.isEmpty) {
                                      //   print("empty");
                                      //   saleBloc.add(QtyPriceChangeEvent(
                                      //       price: 0.0,
                                      //       StockQTY: QTYController.text,
                                      //       total_price: 0.0));
                                      // } else {
                                      //   saleBloc.add(QtyPriceChangeEvent(
                                      //       price: double.parse(value),
                                      //       StockQTY: QTYController.text,
                                      //       total_price: double.parse(
                                      //               priceController.text) *
                                      //           double.parse(
                                      //               QTYController.text)));
                                      // }
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Price",
                                        border: InputBorder.none),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                    height: 45,
                                    padding:
                                        EdgeInsets.only(left: 6, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: appborder),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        // qtyPriceChangeEventTriggered = true;
                                        // if (value.isEmpty) {
                                        //   print("empty");
                                        //   saleBloc.add(QtyPriceChangeEvent(
                                        //       price: double.parse(
                                        //           QTYController.text),
                                        //       StockQTY: QTYController.text,
                                        //       total_price: double.parse(
                                        //           QTYController.text)));
                                        // } else {
                                        //   saleBloc.add(QtyPriceChangeEvent(
                                        //       price: double.parse(value),
                                        //       StockQTY: QTYController.text,
                                        //       total_price: double.parse(
                                        //               priceController.text) *
                                        //           double.parse(
                                        //               QTYController.text)));
                                        // }
                                      },
                                      controller: QTYController,
                                      decoration: InputDecoration(
                                          hintText: "Quantity",
                                          border: InputBorder.none),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Price: ${state.total_price}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Stock QTY: ${state.StockQTY}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: AppTotalScreenWidth(context) / 1.8,
                              padding: EdgeInsets.only(left: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: appborder),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      title: "Price",
                                      color: apptextColor,
                                      font_size: 16.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ])),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(left: 6, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: appborder),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      title: "Quantity",
                                      color: apptextColor,
                                      font_size: 16.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.only(left: 6, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: appborder),
                            borderRadius: BorderRadius.circular(16)),
                        child: TextField(
                          controller: BonusQTYController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Bonus Quantity",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    AppText(
                        title: "Apply Discount",
                        color: Colors.black,
                        font_size: 17,
                        fontWeight: FontWeight.w700),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: appborder),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16))),
                                child: TextField(
                                  controller: NDiscountController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (priceController.text.isNotEmpty &&
                                        NDiscountController.text.isNotEmpty) {
                                      double pdiscount = double.parse(
                                              NDiscountController.text) /
                                          double.parse(priceController.text) *
                                          100;
                                      PDiscountController.text =
                                          pdiscount.toStringAsFixed(2);
                                    }
                                    if (NDiscountController.text.isEmpty) {
                                      PDiscountController.text = "";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: "", border: InputBorder.none),
                                ),
                              ),
                            ),
                            Container(
                              height: 45,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: appsearchBoxColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16))),
                              child: Center(
                                child: AppText(
                                    title: "Rs",
                                    color: Colors.black,
                                    font_size: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: appborder),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16))),
                                child: TextField(
                                  onChanged: (value) {
                                    if (priceController.text.isNotEmpty) {
                                      double originalAmount =
                                          double.parse(priceController.text);
                                      double discountPercentage = double.parse(
                                          PDiscountController.text);
                                      double discountAmount = originalAmount *
                                          discountPercentage /
                                          100;

                                      NDiscountController.text =
                                          discountAmount.toStringAsFixed(2);
                                    }
                                  },
                                  controller: PDiscountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: "", border: InputBorder.none),
                                ),
                              ),
                            ),
                            Container(
                              height: 45,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: appsearchBoxColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16))),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Center(
                                    child: AppText(
                                        title: "%",
                                        color: Colors.black,
                                        font_size: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Validate all fields before adding the product
                          if (priceController.text.isNotEmpty &&
                              QTYController.text.isNotEmpty) {
                            try {
                              double price = double.parse(priceController.text);
                              double qty = double.parse(QTYController.text);
                              int bonusQty;
                              double discountNumber;
                              double discountPercentage;
                              if (BonusQTYController.text.isNotEmpty) {
                                bonusQty = int.parse(BonusQTYController.text);
                              } else {
                                bonusQty = 0;
                              }
                              if (NDiscountController.text.isNotEmpty) {
                                discountNumber =
                                    double.parse(NDiscountController.text);
                              } else {
                                discountNumber = 0;
                              }
                              if (PDiscountController.text.isNotEmpty) {
                                discountPercentage =
                                    double.parse(PDiscountController.text);
                              } else {
                                discountPercentage = 0;
                              }
                              print(sSaleStatus);
                              print(sSaleType);
                              SaleOrderbilledItems.add(ProductModel(
                                id: SaleOrderbilledItems.length,
                                sSaleStatus: sSaleStatus,
                                sSaleType: sSaleType,
                                product_name: ProductName!,
                                productIndex: selectedProductIndex!,
                                unitType: unitTpe,
                                unit: selectedUnit!,
                                price: price,
                                bonusQty: bonusQty,
                                Qty: qty,
                                disountNumber: discountNumber,
                                discountPercentage: discountPercentage,
                              ));

                              Navigator.pop(context);
                            } catch (e) {
                              print("Error: $e");
                              // Show an error message to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Invalid input. Please check your data.')),
                              );
                            }
                          } else {
                            // Show an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Price and Quantity are required.')),
                            );
                          }
                        },
                        child: Container(
                          height: 37,
                          decoration: BoxDecoration(
                              color: appBlue,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: AppText(
                                title: "Save",
                                color: Colors.white,
                                font_size: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        height: 37,
                        decoration: BoxDecoration(
                            color: appBlue,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: AppText(
                              title: "Print",
                              color: Colors.white,
                              font_size: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            textEditingController.clear();
                            priceController.clear();
                            QTYController.clear();
                            BonusQTYController.clear();
                            NDiscountController.clear();
                            PDiscountController.clear();
                            saleOrderBloc.add(SaleInitalEvent());
                            qtyPriceChangeEventTriggered = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: appBlue,
                              borderRadius: BorderRadius.circular(30)),
                          height: 37,
                          child: Center(
                            child: AppText(
                                title: "Reset",
                                color: Colors.white,
                                font_size: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
