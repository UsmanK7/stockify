import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/components/expense_list_card.dart';
import 'package:http/http.dart' as http;
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/UI/daily_expense_list_details.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_bloc.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_event.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/bloc/daily_expense_list_state.dart';
import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';

class DailyExpenseList extends StatefulWidget {
  const DailyExpenseList({super.key});

  @override
  State<DailyExpenseList> createState() => _DailyExpenseListState();
}

@override
class _DailyExpenseListState extends State<DailyExpenseList> {
  void initState() {
    saleOrderListBloc.add(SaleOrderListInitialEvent());

    super.initState();
  }

  SaleOrderListBloc saleOrderListBloc = SaleOrderListBloc();
  List<int> syncIndex = [];
  String firstDateForAppBar = '';
  String lastDateForAppBar = '';
  String? selectedItem;
  List<ExpenseTypeModel> expenseTypes = [];

  final List<String> items = [
    'This week',
    'This month',
    'Last month',
    'This quarter',
    'This year',
    'Custom',
  ];
  var selectedValue = null;

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
          title: "Daily Expense List",
          font_size: 14.0,
          fontWeight: FontWeight.w300,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              var connectivityResult = await Connectivity().checkConnectivity();
              if (syncIndex.isNotEmpty) {
                if (connectivityResult == ConnectivityResult.none) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No internet connection')),
                  );
                  return;
                } else {
                  // Perform a simple internet connection check
                  try {
                    final result =
                        await http.get(Uri.parse('https://www.google.com'));
                    if (result.statusCode == 200) {
                      print("Internet is available");
                      // Proceed with your event handling here
                      saleOrderListBloc.add(DailyExpenseListSyncEvent(
                        iDailyExpenseID: syncIndex,
                        expenseTypes: expenseTypes,
                        selectedItem: selectedItem,
                        firstDate: firstDateForAppBar,
                        lastDate: lastDateForAppBar,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No internet connection')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No internet connection')),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No items to sink')),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5), // Add padding for some space around the content
              child: Row(
                children: [
                  AppText(
                      title: "Sync all",
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
          ),
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<SaleOrderListBloc, SaleOrderListState>(
        bloc: saleOrderListBloc,
        builder: (context, state) {
          if (state is SuccessState) {
            // Calculate the sum of all `dcAmount` values
            double sumExpenseAmount = state.saleList.fold(0.0, (sum, item) {
              // Safely handle potential null values and convert to double
              final amount = item['dcAmount'] as double? ?? 0.0;
              return sum + amount;
            });
            String firstDay = state.firstDate;
            String lastDay = state.lastDate;
            expenseTypes = state.expenseTypes;
            firstDateForAppBar = firstDay;
            lastDateForAppBar = lastDay;
            selectedItem = state.selectedItem;

            List<String> typeNames = state.expenseTypes!
                .map((expenseType) => expenseType.sTypeName)
                .toList();

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
                                saleOrderListBloc.add(
                                    SaleOrderListThisMonthEvent(
                                        expenseTypes: state.expenseTypes,
                                        selectedItem: null));
                              } else if (value == 'Last month') {
                                datetap = false;
                                saleOrderListBloc.add(
                                    SaleOrderListLastMonthEvent(
                                        expenseTypes: state.expenseTypes,
                                        selectedItem: null));
                              } else if (value == 'This week') {
                                datetap = false;
                                saleOrderListBloc.add(
                                    SaleOrderListThisWeekEvent(
                                        expenseTypes: state.expenseTypes,
                                        selectedItem: null));
                              } else if (value == 'This year') {
                                datetap = false;
                                saleOrderListBloc.add(
                                    SaleOrderListThisYearEvent(
                                        expenseTypes: state.expenseTypes,
                                        selectedItem: null));
                              } else if (value == 'This quarter') {
                                datetap = false;
                                saleOrderListBloc.add(
                                    SaleOrderListThisQuarterEvent(
                                        expenseTypes: state.expenseTypes,
                                        selectedItem: null));
                              } else if (value == 'Custom') {
                                saleOrderListBloc.add(SaleOrderListCustomDate(
                                    expenseTypes: state.expenseTypes,
                                    selectedItem: null,
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
                            saleOrderListBloc.add(SaleOrderListCustomDate(
                                expenseTypes: state.expenseTypes,
                                selectedItem: state.selectedItem,
                                fastDay: firstDay,
                                lastDay: lastDay));
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
                            saleOrderListBloc.add(SaleOrderListCustomDate(
                                selectedItem: state.selectedItem,
                                expenseTypes: state.expenseTypes,
                                fastDay: firstDay,
                                lastDay: lastDay));
                          },
                          child: Text(
                            state.lastDate,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              height: 36,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Color(0xffC6C6DF))),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Filter by Expense Type',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: typeNames
                                          .map((String item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: state.selectedItem ?? null,
                                      onChanged: (value) {
                                        int ExpenseTypeID =
                                            typeNames.indexOf(value!);

                                        ExpenseTypeID = ExpenseTypeID + 1;
                                        saleOrderListBloc.add(
                                            DailyExpenseTypeDropdownChangeEvent(
                                                FilterState:
                                                    selectedValue ?? '',
                                                iExpenseTypeID: ExpenseTypeID,
                                                selectedItem: value,
                                                expenseTypes:
                                                    state.expenseTypes,
                                                fastDay: state.firstDate,
                                                lastDay: state.lastDate));
                                        // saleOrderListBloc.add(
                                        //     DailyExpenseTypeChangedActionEvent(
                                        //         expenseTypes:
                                        //             state.expenseTypes,
                                        //         selectedItem: value!));

                                        // ExpenseTypeID =
                                        //     typeNames.indexOf(value);

                                        // ExpenseTypeID = ExpenseTypeID! + 1;
                                      },
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        width: 150,
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              MaterialStateProperty.all(6),
                                          thumbVisibility:
                                              MaterialStateProperty.all(true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14),
                                      )))),
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
                            if (state.saleList[index]['sSyncStatus'] == "0") {
                              syncIndex.add(
                                  state.saleList[index]['iDailyExpenseID']);
                            }

                            print(state.saleList[index]['dcAmount']);
                            if (state.saleList.isNotEmpty) {
                              if (state.saleList[index]['sSyncStatus'] != "0") {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DailyExpenseListDetails(
                                                  iDailyExpenseID:
                                                      state.saleList[index]
                                                          ['iDailyExpenseID'],
                                                  syncStatus:
                                                      state.saleList[index]
                                                          ['sSyncStatus'],
                                                )));
                                  },
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      child: ExpenseListCard(
                                        // onSync: () async {
                                        //   print("sync");
                                        //   // var connectivityResult =
                                        //   //     await Connectivity()
                                        //   //         .checkConnectivity();
                                        //   // if (connectivityResult ==
                                        //   //     ConnectivityResult.none) {
                                        //   //   ScaffoldMessenger.of(context)
                                        //   //       .showSnackBar(
                                        //   //     SnackBar(
                                        //   //         content: Text(
                                        //   //             'No internet connection')),
                                        //   //   );
                                        //   //   return;
                                        //   // } else {
                                        //   //   try {
                                        //   //     final result = await http.get(
                                        //   //         Uri.parse(
                                        //   //             'https://www.google.com'));
                                        //   //     if (result.statusCode == 200) {
                                        //   //       print("Internet is available");

                                        //   //       saleOrderListBloc.add(
                                        //   //           DailyExpenseListSyncEvent(
                                        //   //         iDailyExpenseID: syncIndex,
                                        //   //         expenseTypes: expenseTypes,
                                        //   //         selectedItem:
                                        //   //             state.selectedItem,
                                        //   //         firstDate: firstDateForAppBar,
                                        //   //         lastDate: lastDateForAppBar,
                                        //   //       ));
                                        //   //     } else {
                                        //   //       ScaffoldMessenger.of(context)
                                        //   //           .showSnackBar(
                                        //   //         SnackBar(
                                        //   //             content: Text(
                                        //   //                 'No internet connection')),
                                        //   //       );
                                        //   //     }
                                        //   //   } catch (e) {
                                        //   //     ScaffoldMessenger.of(context)
                                        //   //         .showSnackBar(
                                        //   //       SnackBar(
                                        //   //           content: Text(
                                        //   //               'No internet connection')),
                                        //   //     );
                                        //   //   }
                                        //   // }
                                        // },
                                        ExpenseType: state.saleList[index]
                                            ['expenseTypeName'],
                                        date: state.saleList[index]['dDate'],
                                        description: state.saleList[index]
                                            ['sDescription'],
                                        amount: state.saleList[index]
                                            ['dcAmount'],
                                        syncStatus: state.saleList[index]
                                            ['sSyncStatus'],
                                        transaction_id: state.saleList[index]
                                            ['transaction_id'],
                                      )),
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
                                    key: Key(state.saleList[index]
                                            ['iDailyExpenseID']
                                        .toString()),
                                    // key: Key(state.saleList[index].saleId
                                    //     .toString()),
                                    // direction: DismissDirection.endToStart,
                                    // onDismissed: (direction) async {
                                    //   saleOrderListBloc
                                    //       .add(SaleOrderListDismissEvent(
                                    //     firstDate: firstDay,
                                    //     lastDate: lastDay,
                                    //     SaleId: state.saleList[index].saleId,
                                    //   ));
                                    // },
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DailyExpenseListDetails(
                                                      iDailyExpenseID: state
                                                              .saleList[index]
                                                          ['iDailyExpenseID'],
                                                      syncStatus:
                                                          state.saleList[index]
                                                              ['sSyncStatus'],
                                                    )));
                                      },
                                      child: Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 2),
                                          child: ExpenseListCard(
                                            onSync: () async {
                                              print("sync");
                                              var connectivityResult =
                                                  await Connectivity()
                                                      .checkConnectivity();
                                              if (connectivityResult ==
                                                  ConnectivityResult.none) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'No internet connection')),
                                                );
                                                return;
                                              } else {
                                                try {
                                                  final result = await http.get(
                                                      Uri.parse(
                                                          'https://www.google.com'));
                                                  if (result.statusCode ==
                                                      200) {
                                                    print(
                                                        "Internet is available");
                                                    List<int> current = [];
                                                    current
                                                        .add(syncIndex[index]);

                                                    saleOrderListBloc.add(
                                                        DailyExpenseListSyncEvent(
                                                      iDailyExpenseID: current,
                                                      expenseTypes:
                                                          expenseTypes,
                                                      selectedItem:
                                                          state.selectedItem,
                                                      firstDate:
                                                          firstDateForAppBar,
                                                      lastDate:
                                                          lastDateForAppBar,
                                                    ));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'No internet connection')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'No internet connection')),
                                                  );
                                                }
                                              }
                                            },
                                            ExpenseType: state.saleList[index]
                                                ['expenseTypeName'],
                                            date: state.saleList[index]
                                                ['dDate'],
                                            description: state.saleList[index]
                                                ['sDescription'],
                                            amount: state.saleList[index]
                                                ['dcAmount'],
                                            syncStatus: state.saleList[index]
                                                ['sSyncStatus'],
                                            transaction_id:
                                                state.saleList[index]
                                                    ['transaction_id'],
                                          )),
                                    ),
                                  ),
                                );
                              }
                            } else if (state is LoadingState) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          AppText(
                                              title: "Syncing",
                                              color: Colors.black,
                                              font_size: 18,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
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
                                // right: BorderSide(
                                //   color:
                                //       appsearchBoxColor, // Set the color of the right border here
                                //   width:
                                //       1, // Set the width of the right border here
                                // ),
                                ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                  title: "Expense Amount",
                                  color: Colors.black,
                                  font_size: 15,
                                  fontWeight: FontWeight.w400),
                              AppText(
                                  title: sumExpenseAmount.toString(),
                                  color: appsubtitletextColor,
                                  font_size: 15,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        // Container(
                        //   padding: EdgeInsets.only(right: 20),
                        //   decoration: BoxDecoration(
                        //     border: Border(
                        //       right: BorderSide(
                        //         color:
                        //             appsearchBoxColor, // Set the color of the right border here
                        //         width:
                        //             1, // Set the width of the right border here
                        //       ),
                        //     ),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       AppText(
                        //           title: "Invoice",
                        //           color: Colors.black,
                        //           font_size: 15,
                        //           fontWeight: FontWeight.w400),
                        //       AppText(
                        //           title: totalInvoicePrice.toString(),
                        //           color: appsubtitletextColor,
                        //           font_size: 15,
                        //           fontWeight: FontWeight.w400),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     AppText(
                        //         title: "Discount",
                        //         color: Colors.black,
                        //         font_size: 15,
                        //         fontWeight: FontWeight.w400),
                        //     AppText(
                        //         title: totalDiscount.toString(),
                        //         color: appsubtitletextColor,
                        //         font_size: 15,
                        //         fontWeight: FontWeight.w400),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is LoadingState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                    title: "Syncing",
                    color: Colors.black,
                    font_size: 14,
                    fontWeight: FontWeight.bold),
                CircularProgressIndicator(),
              ],
            );
          } else {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ));
          }
        },
      ),
    );
  }
}
