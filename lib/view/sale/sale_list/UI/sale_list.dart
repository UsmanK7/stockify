import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/components/sale_list_card.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_bloc.dart';
import 'package:okra_distributer/view/sale/data/billed_items.dart';
import 'package:okra_distributer/view/sale/sale_list/UI/sale_list_details_screen.dart';
import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_bloc.dart';
import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_event.dart';
import 'package:okra_distributer/view/sale/sale_list/bloc/sale_list_state.dart';

class SaleList extends StatefulWidget {
  const SaleList({super.key});

  @override
  State<SaleList> createState() => _SaleListState();
}

@override
class _SaleListState extends State<SaleList> {
  void initState() {
    saleListBloc.add(SaleListInitialEvent());
    super.initState();
  }

  SaleListBloc saleListBloc = SaleListBloc();

  final List<String> items = [
    'This week',
    'This month',
    'Last month',
    'This quarter',
    'This year',
    'Custom',
  ];
  String? selectedValue;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _firstdateController = TextEditingController();
  TextEditingController _lastdateController = TextEditingController();

  Future<DateTime> _firstselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2070),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _firstdateController.text = formatDate(_selectedDate);
    }
    return picked!;
  }

  Future<DateTime> _lastselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2070),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _lastdateController.text = formatDate(_selectedDate);
    }
    return picked!;
  }

  bool datetap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appBlue,
        title: AppText(
          color: Colors.white,
          title: "Sales List",
          font_size: 18.0,
          fontWeight: FontWeight.w300,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SaleListBloc, SaleListState>(
        bloc: saleListBloc,
        builder: (context, state) {
          if (state is SuccessState) {
            double totalPaidBillAmount = state.saleList.length == 0
                ? 0
                : state.saleList
                    .map((sale) => sale.paid_bill_amount)
                    .reduce((value, element) => value + element);

            double totalInvoicePrice = state.saleList.length == 0
                ? 0
                : state.saleList
                    .map((sale) => sale.invoice_price)
                    .reduce((value, element) => value + element);
            double totalDiscount = state.saleList.length == 0
                ? 0
                : state.saleList
                    .map((sale) => sale.total_discount)
                    .reduce((value, element) => value + element);
            String firstDay = state.firstDate;
            String lastDay = state.lastDate;
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Date Filter',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: items
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: datetap == true ? "Custom" : selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                              });
                              if (value == "This month") {
                                datetap = false;
                                saleListBloc.add(SaleListThisMonthEvent());
                              } else if (value == 'Last month') {
                                datetap = false;
                                saleListBloc.add(SaleListLastMonthEvent());
                              } else if (value == 'This week') {
                                datetap = false;
                                saleListBloc.add(SaleListThisWeekEvent());
                              } else if (value == 'This year') {
                                datetap = false;
                                saleListBloc.add(SaleListThisYearEvent());
                              } else if (value == 'This quarter') {
                                datetap = false;
                                saleListBloc.add(SaleListThisQuarterEvent());
                              } else if (value == 'Custom') {
                                saleListBloc.add(SaleListCustomDate(
                                    fastDay: state.firstDate,
                                    lastDay: state.lastDate));
                              }
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 40,
                              width: 140,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                        ),
                        Icon(Icons.calendar_month),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            datetap = true;
                            DateTime now = await _firstselectDate(context);
                            firstDay = formatDate(now);
                            saleListBloc.add(SaleListCustomDate(
                                fastDay: firstDay, lastDay: lastDay));
                          },
                          child: Text(
                            state.firstDate,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "to",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () async {
                            datetap = true;
                            DateTime now = await _lastselectDate(context);
                            lastDay = formatDate(now);
                            saleListBloc.add(SaleListCustomDate(
                                fastDay: firstDay, lastDay: lastDay));
                          },
                          child: Text(
                            state.lastDate,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Color(0xff91919F),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 80),
                        child: ListView.builder(
                          itemCount: state.saleList.length,
                          itemBuilder: (context, index) {
                            int saleid = index + 1;

                            if (state.saleList.isNotEmpty) {
                              if (state.saleList[index].sSyncStatus != "0") {
                                // Render a non-dismissible widget for items with sSyncStatus other than "0"
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SaleListDetails(
                                                    SaleId: state
                                                        .saleList[index]
                                                        .saleId)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: SaleListCard(
                                      name:
                                          state.saleList[index].customer_Name ??
                                              "null",
                                      paidBillAmount: state
                                          .saleList[index].paid_bill_amount,
                                      index: saleid,
                                      discount: state
                                              .saleList[index].total_discount ??
                                          0,
                                      invoice_price:
                                          state.saleList[index].invoice_price ??
                                              0,
                                      sale_date:
                                          state.saleList[index].sale_date,
                                    ),
                                  ),
                                );
                              } else {
                                // Render a Dismissible widget for items with sSyncStatus as "0"
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Dismissible(
                                    background: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    key: Key(state.saleList[index].saleId
                                        .toString()),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) async {
                                      saleListBloc.add(SaleListDismissEvent(
                                        firstDate: firstDay,
                                        lastDate: lastDay,
                                        SaleId: state.saleList[index].saleId,
                                      ));
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SaleListDetails(
                                                        SaleId: state
                                                            .saleList[index]
                                                            .saleId)));
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: SaleListCard(
                                          name: state.saleList[index]
                                                  .customer_Name ??
                                              "null",
                                          paidBillAmount: state
                                              .saleList[index].paid_bill_amount,
                                          index: state.saleList[index].saleId,
                                          discount: state.saleList[index]
                                                  .total_discount ??
                                              0,
                                          invoice_price: state.saleList[index]
                                                  .invoice_price ??
                                              0,
                                          sale_date:
                                              state.saleList[index].sale_date,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              ); // handle the case where the sale list is empty
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 5.0,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color:
                                    appsearchBoxColor, // Set the color of the right border here
                                width:
                                    1, // Set the width of the right border here
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                  title: "Total",
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.w400),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color:
                                    appsearchBoxColor, // Set the color of the right border here
                                width:
                                    1, // Set the width of the right border here
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                  title: "Paid bill",
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.w400),
                              AppText(
                                  title: totalPaidBillAmount.toString(),
                                  color: appsubtitletextColor,
                                  font_size: 15,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color:
                                    appsearchBoxColor, // Set the color of the right border here
                                width:
                                    1, // Set the width of the right border here
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                  title: "Invoice",
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.w400),
                              AppText(
                                  title: totalInvoicePrice.toString(),
                                  color: appsubtitletextColor,
                                  font_size: 15,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                                title: "Discount",
                                color: Colors.black,
                                font_size: 15,
                                fontWeight: FontWeight.w400),
                            AppText(
                                title: totalDiscount.toString(),
                                color: appsubtitletextColor,
                                font_size: 15,
                                fontWeight: FontWeight.w400),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
