import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_bloc.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_event.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_state.dart';

class DailyExpenseListDetails extends StatefulWidget {
  final iDailyExpenseID;
  final syncStatus;
  const DailyExpenseListDetails(
      {super.key, required this.iDailyExpenseID, required this.syncStatus});

  @override
  State<DailyExpenseListDetails> createState() =>
      _DailyExpenseListDetailsState();
}

class _DailyExpenseListDetailsState extends State<DailyExpenseListDetails> {
  SaleOrderListBloc saleOrderListBloc = SaleOrderListBloc();
  @override
  void initState() {
    super.initState();
    saleOrderListBloc
        .add(SaleOrderListDetailsEvent(SaleId: widget.iDailyExpenseID));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.iDailyExpenseID);
    print(widget.syncStatus);
    print(widget.syncStatus.runtimeType);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appBlue,
        title: AppText(
          color: Colors.white,
          title: "Daily Expense Detail",
          font_size: widget.syncStatus == "0" ?  14.0 : 22,
          fontWeight: FontWeight.w300,
        ),
        actions: [
          widget.syncStatus == "0"
              ? GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Syncing all")),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical:
                            5), // Add padding for some space around the content
                    child: Row(
                      children: [
                        AppText(
                            title: "Sync",
                            color: appBlue,
                            font_size: 15,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                            width:
                                10), // Add some space between the text and the image
                        Container(
                          width: 24, // Set the width of the container
                          height: 24, // Set the height of the container
                          child: Image.asset(
                            "assets/images/sync-button-card.png",
                            fit: BoxFit
                                .contain, // Use BoxFit.contain to fit the image within the container
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox()
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<SaleOrderListBloc, SaleOrderListState>(
        bloc: saleOrderListBloc,
        builder: (context, state) {
          if (state is SaleListDetailsState) {
            print(state.daily_expense_list[0]['sTypeName']);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                width: AppTotalScreenWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                  title: "Expense Type:",
                                  color: appsubtitletextColor,
                                  font_size: 12,
                                  fontWeight: FontWeight.w600),
                              AppText(
                                  title: state.daily_expense_list[0]
                                      ['sTypeName'],
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.w600),
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AppText(
                                title: state.daily_expense_list[0]['dDate']
                                    .toString(),
                                color: appsubtitletextColor,
                                font_size: 15,
                                fontWeight: FontWeight.w500),
                            AppText(
                                title:
                                    "transaction id: ${state.daily_expense_list[0]['transaction_id'].toString()}",
                                color: appsubtitletextColor,
                                font_size: 15,
                                fontWeight: FontWeight.w500),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            title: "Amount",
                            color: Colors.black,
                            font_size: 15,
                            fontWeight: FontWeight.bold),
                        AppText(
                            title: state.daily_expense_list[0]['dcAmount']
                                .toString(),
                            color: Colors.black,
                            font_size: 15,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            title: "From Bank",
                            color: Colors.black,
                            font_size: 15,
                            fontWeight: FontWeight.bold),
                        AppText(
                            title:
                                state.daily_expense_list[0]['sName'].toString(),
                            color: Colors.black,
                            font_size: 15,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        AppText(
                            title: "Description",
                            color: Colors.black,
                            font_size: 12,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                              title:
                                  "Description ${state.daily_expense_list[0]['sDescription'].toString()}",
                              color: appsubtitletextColor,
                              font_size: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
