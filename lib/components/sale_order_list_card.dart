import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/sale_order/sale_order_list/bloc/sale_order_list_bloc.dart';

class SaleOrderListCard extends StatelessWidget {
  String name;
  int index;
  String syncstatus;
  double invoice_price;
  String sale_date;
  double discount;
  final VoidCallback? onSync;

  SaleOrderListCard(
      {super.key,
      required this.name,
      required this.index,
      required this.discount,
      required this.syncstatus,
      this.onSync,
      required this.invoice_price,
      required this.sale_date});

  @override
  Widget build(BuildContext context) {
    String status = "";
    SaleOrderListBloc saleOrderListBloc = SaleOrderListBloc();
    return Container(
      width: AppTotalScreenWidth(context),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                AppText(
                    title: name,
                    color: Colors.black,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                      title: "Sale #${index}",
                      color: appsubtitletextColor,
                      font_size: 12,
                      fontWeight: FontWeight.w500),
                  AppText(
                      title: sale_date,
                      color: appsubtitletextColor,
                      font_size: 12,
                      fontWeight: FontWeight.w500),
                ],
              )
            ],
          ),
          Row(
            children: [
              AppText(
                  title: "Total discount : Rs ${discount}",
                  color: appsubtitletextColor,
                  font_size: 12,
                  fontWeight: FontWeight.w500),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                  title: "Invoice price : Rs ${invoice_price}",
                  color: Colors.black,
                  font_size: 12,
                  fontWeight: FontWeight.w400),
              Row(
                children: [
                  Icon(
                    Icons.print,
                    color: appsearchBoxColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.share,
                    color: appsearchBoxColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.menu,
                    color: appsearchBoxColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  int.parse(syncstatus) == 0
                      ? GestureDetector(
                          onTap: () {
                            onSync!();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                AppText(
                                    title: "Sync",
                                    color: Colors.white,
                                    font_size: 14,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
