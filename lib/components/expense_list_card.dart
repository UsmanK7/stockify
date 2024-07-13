import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';

class ExpenseListCard extends StatelessWidget {
  final ExpenseType;
  final date;
  final transaction_id;
  final description;
  final amount;
  final VoidCallback? onSync;
  final syncStatus;
  const ExpenseListCard(
      {super.key,
      this.ExpenseType,
      this.date,
      this.transaction_id,
      this.description,
      this.onSync,
      this.amount,
      this.syncStatus});

  @override
  Widget build(BuildContext context) {
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
                    title: "Expense Type:",
                    color: appsubtitletextColor,
                    font_size: 9,
                    fontWeight: FontWeight.w600),
                AppText(
                    title: ExpenseType.toString(),
                    color: Colors.black,
                    font_size: 12,
                    fontWeight: FontWeight.w600),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                      title: date.toString(),
                      color: appsubtitletextColor,
                      font_size: 12,
                      fontWeight: FontWeight.w500),
                  AppText(
                      title: "transaction id: ${transaction_id.toString()}",
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
                  title: truncateAfterChars(description.toString(), 40),
                  color: appsubtitletextColor,
                  font_size: 12,
                  fontWeight: FontWeight.w500),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                  title: amount.toString(),
                  color: Colors.black,
                  font_size: 15,
                  fontWeight: FontWeight.bold),
              Row(
                children: [
                  Icon(
                    Icons.print,
                    color: appBlue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.share,
                    color: appBlue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.menu,
                    color: appBlue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  syncStatus == "0"
                      ? GestureDetector(
                          onTap: () {
                            onSync!();
                          },
                          child: Container(
                              height: 35,
                              width: 35,
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              // decoration: BoxDecoration(
                              //     color: Colors.blue,
                              //     borderRadius: BorderRadius.circular(20)),
                              child: Image(
                                image: AssetImage(
                                    "assets/images/sync-button-card.png"),
                              )),
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
