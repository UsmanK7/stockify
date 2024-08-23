import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_bloc.dart';
import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_event.dart';
import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_state.dart';

class SaleListDetails extends StatefulWidget {
  final SaleId;
  const SaleListDetails({super.key, required this.SaleId});

  @override
  State<SaleListDetails> createState() => _SaleListDetailsState();
}

class _SaleListDetailsState extends State<SaleListDetails> {
  SaleListBloc saleListBloc = SaleListBloc();
  @override
  void initState() {
    saleListBloc.add(SaleListDetailsEvent(SaleId: widget.SaleId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appBlue,
        title: AppText(
          color: Colors.white,
          title: "Sales Details",
          font_size: 18.0,
          fontWeight: FontWeight.w300,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SaleListBloc, SaleListState>(
          bloc: saleListBloc,
          builder: (context, state) {
            if (state is SaleListDetailsState) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      width: AppTotalScreenWidth(context),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Image(
                                        image: AssetImage(
                                            "assets/images/user.png")),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                          title: state
                                              .saleWithCustomer.customer!.sName,
                                          color: Colors.black,
                                          font_size: 12,
                                          fontWeight: FontWeight.bold),
                                      AppText(
                                          title: state.saleWithCustomer
                                              .customer!.dcTotalRemainingAmount
                                              .toString(),
                                          color: appsubtitletextColor,
                                          font_size: 12,
                                          fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                ],
                              ),
                              AppText(
                                  title: "Sale #${widget.SaleId}",
                                  color: Colors.black,
                                  font_size: 12,
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                  title: "Billed Amount",
                                  color: appsubtitletextColor,
                                  font_size: 14,
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  title:
                                      "${state.saleWithCustomer.sale.dcPaidBillAmount.toString()} Rs",
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                  title: "Phone Number",
                                  color: appsubtitletextColor,
                                  font_size: 14,
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  title:
                                      state.saleWithCustomer.customer!.sPhone,
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                  title: "Shop Name",
                                  color: appsubtitletextColor,
                                  font_size: 14,
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  title: state
                                      .saleWithCustomer.customer!.sShopName,
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: AppTotalScreenWidth(context),
                      height: 31,
                      color: appBlue,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Image(
                                image:
                                    AssetImage("assets/images/dropdown.png")),
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
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        child: ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final item = state.products[index];

                            int itemId = index + 1;
                            final sSaleQty;
                            if (item['sSaleQtyInBaseUnit'] != null) {
                              sSaleQty = item['sSaleQtyInBaseUnit'];
                            } else {
                              sSaleQty = item['sSaleQtyInSecUnit'];
                            }
                            final sSaleBonusQty;
                            if (item['sSaleBonusInBaseUnit'] != null) {
                              sSaleBonusQty = item['sSaleBonusInBaseUnit'];
                            } else {
                              sSaleBonusQty = item['sSaleBonusInSecUnit'];
                            }
                            final sSaleTotalQty;
                            if (item['sSaleTotalInBaseUnitQty'] != null) {
                              sSaleTotalQty = item['sSaleTotalInBaseUnitQty'];
                            } else {
                              sSaleTotalQty = item['sSaleTotalInSecUnitQty'];
                            }
                            final sSalePrice;
                            if (item['dcSalePricePerBaseUnit'] != null) {
                              sSalePrice = item['dcSalePricePerBaseUnit'];
                            } else {
                              sSalePrice = item['dcSalePriceSecUnit'];
                            }
                            final totalSalePrice;
                            if (item['dcToalSalePriceInBaseUnit'] != null) {
                              totalSalePrice =
                                  item['dcToalSalePriceInBaseUnit'];
                            } else {
                              totalSalePrice = item['dcToalSalePriceInSecUnit'];
                            }

                            final discountPercentage =
                                item['sDiscountInPercentage'];
                            final discountAmount = item['dcDiscountInAmount'];

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: EdgeInsets.only(top: 3),
                                width: AppTotalScreenWidth(context),
                                height: 106,
                                color: appsearchBoxColor,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                              title: "#${itemId.toString()}",
                                              color: Colors.black,
                                              font_size: 16.0,
                                              fontWeight: FontWeight.bold),
                                          // Container(
                                          //   width: 55,
                                          //   height: 20,
                                          //   decoration: BoxDecoration(
                                          //     color: Colors.red,
                                          //     borderRadius:
                                          //         BorderRadius.circular(15),
                                          //   ),
                                          //   child: Center(
                                          //     child: Row(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment.center,
                                          //       children: [
                                          //         AppText(
                                          //             title: "Delete",
                                          //             color: Colors.white,
                                          //             font_size: 10,
                                          //             fontWeight:
                                          //                 FontWeight.bold),
                                          //         SizedBox(
                                          //           width: 5,
                                          //         ),
                                          //         Icon(size: 10, Icons.close),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // )
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
                                              item['sProductName'],
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
                                                "${sSaleQty} ${item['sUnitName']} + ${sSaleBonusQty} (Bonus) = ${sSaleTotalQty}",
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
                                                      color: Color(0xff50E91A),
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
                                                        "${sSaleQty} QTY x ${sSalePrice} Rs = ${totalSalePrice} Rs",
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
                                                      color: Color(0xff7F3DFF),
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
                                                        "${sSaleBonusQty} Bonus x 0 = 0 Rs",
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
                                                      color: Color(0xffE11B1B),
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
                                                        "${discountPercentage} % | ${discountAmount} Rs = ${discountAmount}",
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
                                                      title:
                                                          sSalePrice.toString(),
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
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
