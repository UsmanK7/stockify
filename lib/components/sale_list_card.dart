import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';

class SaleListCard extends StatelessWidget {
  String name;
  int index;
  double paidBillAmount;
  double invoice_price;
  String sale_date;
  double discount;

  SaleListCard(
      {super.key,
      required this.name,
      required this.index,
      required this.discount,
      required this.paidBillAmount,
      required this.invoice_price,
      required this.sale_date});

  @override
  Widget build(BuildContext context) {
    String status = "";
    if (paidBillAmount == 0) {
      status = "unpaid";
    } else if (paidBillAmount < invoice_price) {
      status = "partial";
    } else if (paidBillAmount == invoice_price) {
      status = "paid";
    }
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  color: status == "paid"
                      ? Colors.green
                      : status == "unpaid"
                          ? Colors.orange
                          : Colors.blueAccent,
                  child: AppText(
                      title: status == "paid"
                          ? "Paid"
                          : status == "unpaid"
                              ? "Unpaid"
                              : "Partial",
                      color: Colors.white,
                      font_size: 12,
                      fontWeight: FontWeight.w600),
                ),
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
                    width: 20,
                  ),
                  Icon(
                    Icons.share,
                    color: appsearchBoxColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.menu,
                    color: appsearchBoxColor,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
