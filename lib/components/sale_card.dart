import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/sale/sale_list/UI/sale_list.dart';

class SaleDashboardCard extends StatelessWidget {
  final total_order;
  final sale_amount;
  final paid_amount;
  final total_discount;
  const SaleDashboardCard(
      {super.key,
      required this.paid_amount,
      required this.sale_amount,
      required this.total_discount,
      required this.total_order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 105,
        decoration: BoxDecoration(
            color: appBlue, borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                    title: "Sales ",
                    color: Colors.white,
                    font_size: 14,
                    fontWeight: FontWeight.bold),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SaleList()));
                  },
                  child: AppText(
                      title: "See all ",
                      color: Colors.white,
                      font_size: 14,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                    title: "Total sales",
                    color: Colors.white,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
                AppText(
                    title: total_order.toString(),
                    color: Colors.white,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                    title: "Sale amount",
                    color: Colors.white,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
                AppText(
                    title: sale_amount.toString(),
                    color: Colors.white,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                    title: "Paid amount",
                    color: Colors.white,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
                AppText(
                    title: paid_amount.toString(),
                    color: Colors.white,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     AppText(
            //         title: "Total discount",
            //         color: Colors.white,
            //         font_size: 12,
            //         fontWeight: FontWeight.w600),
            //     AppText(
            //         title: total_discount.toString(),
            //         color: Colors.white,
            //         font_size: 12,
            //         fontWeight: FontWeight.w600),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
