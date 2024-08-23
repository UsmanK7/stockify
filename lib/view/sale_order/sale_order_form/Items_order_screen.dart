import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_bloc.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_event.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_state.dart';

import 'package:okra_distributer/view/sale_order/data/sale_order_billed_items.dart';
import 'package:okra_distributer/view/sale_order/sale_order_form/add_item_form.dart';

class ItemOrdersScreen extends StatefulWidget {
  const ItemOrdersScreen({super.key});

  @override
  State<ItemOrdersScreen> createState() => _ItemOrdersScreenState();
}

class _ItemOrdersScreenState extends State<ItemOrdersScreen> {
  @override
  void initState() {
    saleBloc.add(RefreshEvent());

    super.initState();
  }

  double netAmount = 0;
  double totalDiscount = 0;
  double TotalQty = 0;

  SaleBloc saleBloc = SaleBloc();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaleBloc, SaleState>(
        bloc: saleBloc,
        builder: (context, state) {
          double netAmount = SaleOrderbilledItems.fold(
              0, (previousValue, element) => previousValue + element.price);
          double totalDiscount = SaleOrderbilledItems.fold(
              0,
              (previousValue, element) =>
                  previousValue + element.disountNumber);
          double TotalQty = SaleOrderbilledItems.fold(
              0, (previousValue, element) => previousValue + element.Qty);
          if (state is RefreshState) {
            dcTotalBill = netAmount;
            dctotaldiscount = totalDiscount;
            sTotal_Item = TotalQty.toString();

            return Column(
              children: [
                Container(
                  width: AppTotalScreenWidth(context),
                  height: 31,
                  color: appBlue,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image(
                            width: 20,
                            image: AssetImage("assets/images/dropdown.png")),
                        SizedBox(
                          width: 10,
                        ),
                        AppText(
                            title: "Billed Items",
                            color: Colors.white,
                            font_size: 13,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: AppTotalScreenHeight(context) - 390,
                  child: SaleOrderbilledItems.isEmpty
                      ? Center(
                          child: Text("No records found"),
                        )
                      : ListView.builder(
                          itemCount: SaleOrderbilledItems.length,
                          itemBuilder: (context, index) {
                            final item = SaleOrderbilledItems[index];
                            int item_index = item.id + 1;
                            double totalQtyPrice =
                                SaleOrderbilledItems[index].Qty *
                                    SaleOrderbilledItems[index].price;

                            return Dismissible(
                              key: Key(
                                  item.id.toString()), // Provide a unique key
                              direction: DismissDirection.endToStart,
                              background: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              onDismissed: (DismissDirection direction) {
                                // Remove the item from the data source

                                SaleOrderbilledItems.removeAt(item.id);
                                saleBloc.add(RefreshEvent());
                                // Show a snackbar or any other message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Item deleted")),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  padding: EdgeInsets.only(top: 3),
                                  width: AppTotalScreenWidth(context),
                                  height: 106,
                                  color: appsearchBoxColor,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText(
                                                title: "#${item_index}",
                                                color: Colors.black,
                                                font_size: 16.0,
                                                fontWeight: FontWeight.bold),
                                            GestureDetector(
                                              onTap: () {
                                                SaleOrderbilledItems.removeAt(
                                                    item.id);
                                                saleBloc.add(RefreshEvent());
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Item deleted")));
                                              },
                                              child: Container(
                                                width: 55,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      AppText(
                                                          title: "Delete",
                                                          color: Colors.white,
                                                          font_size: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                          size: 10,
                                                          Icons.close),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.product_name,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          AppText(
                                              title:
                                                  "${item.Qty} ${item.unit} + ${item.bonusQty} (Bonus)",
                                              color: Colors.black,
                                              font_size: 12,
                                              fontWeight: FontWeight.bold)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 12,
                                                        width: 6,
                                                        color:
                                                            Color(0xff50E91A),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      AppText(
                                                          title: "Sale Qty",
                                                          color: Colors.black,
                                                          font_size: 10,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  AppText(
                                                      title:
                                                          "${item.Qty} QTY x ${item.price} = + ${totalQtyPrice} Rs",
                                                      color: Colors.black,
                                                      font_size: 10,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 12,
                                                        width: 6,
                                                        color:
                                                            Color(0xff7F3DFF),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      AppText(
                                                          title: "Bonus QTY",
                                                          color: Colors.black,
                                                          font_size: 10,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  AppText(
                                                      title:
                                                          "${item.bonusQty} Bonus x 0 = 0 Rs",
                                                      color: Colors.black,
                                                      font_size: 10,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 12,
                                                        width: 6,
                                                        color:
                                                            Color(0xffE11B1B),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      AppText(
                                                          title: "Discount",
                                                          color: Colors.black,
                                                          font_size: 10,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  AppText(
                                                      title:
                                                          "${SaleOrderbilledItems[index].discountPercentage} % | ${SaleOrderbilledItems[index].price} Rs = - ${SaleOrderbilledItems[index].disountNumber} Rs",
                                                      color: Colors.black,
                                                      font_size: 10,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 48,
                                            width: 75,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 43,
                                                  width: 75,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: Center(
                                                    child: AppText(
                                                        title: item.price
                                                            .toString(),
                                                        color: Colors.black,
                                                        font_size: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 33, left: 12),
                                                  width: 55,
                                                  height: 15,
                                                  color: appsearchBoxColor,
                                                  child: Center(
                                                    child: AppText(
                                                        title: "Subtotal",
                                                        color: appBlue,
                                                        font_size: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // child: Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 10),
                              //   child: SaleItemCard(
                              //     index: item.id,
                              //     unit: item.unit,
                              //     title: item.product_name,
                              //     saleQty: item.Qty,
                              //     bonusQty: item.bonusQty,
                              //     DiscountPercentage: item.discountPercentage,
                              //     DiscountPrice: item.disountNumber,
                              //     QtyPrice: item.price,
                              //   ),
                              // ),
                            );
                          },
                        ),
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                        title: "Total discount: ${totalDiscount}",
                        color: Colors.black,
                        font_size: 16,
                        fontWeight: FontWeight.bold),
                    AppText(
                        title: "Tax Amount: 0.0",
                        color: Colors.black,
                        font_size: 16,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                        title: "Item QTY: ${TotalQty}",
                        color: Colors.black,
                        font_size: 16,
                        fontWeight: FontWeight.bold),
                    AppText(
                        title: "Net Amount: ${netAmount}",
                        color: Colors.black,
                        font_size: 16,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOrderItem()));
                        saleBloc.add(RefreshEvent());
                      },
                      child: Container(
                          width: AppTotalScreenWidth(context) - 190,
                          height: 37,
                          decoration: BoxDecoration(
                              color: appBlue,
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  width: 20,
                                  image: AssetImage(
                                      "assets/images/plus_inside_btn.png")),
                              SizedBox(
                                width: 10,
                              ),
                              AppText(
                                  title: "Sale Item",
                                  color: Colors.white,
                                  font_size: 16,
                                  fontWeight: FontWeight.bold)
                            ],
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 37,
                        decoration: BoxDecoration(
                          color: appsearchBoxColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Image(
                            image: AssetImage("assets/images/scanner.png"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
