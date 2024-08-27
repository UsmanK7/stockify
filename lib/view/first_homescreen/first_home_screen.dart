import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:okra_distributer/components/quick_link_card.dart';
import 'package:okra_distributer/components/sale_card.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/views/Payment_recovery.dart';
import 'package:okra_distributer/payment/views/apicheckingScreen.dart';
import 'package:okra_distributer/payment/views/customer.dart';
import 'package:okra_distributer/payment/views/loginScreen.dart';
import 'package:okra_distributer/view/auth/login_screen.dart';
import 'package:okra_distributer/view/daily_expense/UI/daily_expense.dart';
import 'package:okra_distributer/view/daily_expense/daily_expense_list/UI/daily_expense_list.dart';
import 'package:okra_distributer/view/dashboard/dashboard_screen.dart';
import 'package:okra_distributer/view/first_homescreen/bloc/dash/dash_bloc.dart';
import 'package:okra_distributer/view/first_homescreen/bloc/dash/dash_event.dart';
import 'package:okra_distributer/view/first_homescreen/bloc/dash/dash_state.dart';
import 'package:okra_distributer/view/sale/sale%20form/sales_form.dart';
import 'package:okra_distributer/view/sale/sale_list/UI/sale_list.dart';
import 'package:okra_distributer/view/sale_list/UI/sale_list_table.dart';
import 'package:okra_distributer/view/sale_order/sale_order_form/sales_order_form.dart';
import 'package:okra_distributer/view/sale_order/sale_order_list/UI/sale_order_list.dart';
import 'package:okra_distributer/view/sale_return/sale_return_form/sales_return_form.dart';
import 'package:okra_distributer/view/unknown/unknown.dart';

import 'package:sqflite/sqflite.dart';

class FirstHomeScreen extends StatefulWidget {
  final Database? database;
  const FirstHomeScreen({super.key, this.database});
  @override
  State<FirstHomeScreen> createState() => _FirstHomeScreenState();
}

class _FirstHomeScreenState extends State<FirstHomeScreen> {
  DashBloc dashBloc = DashBloc();

  @override
  void initState() {
    super.initState();
    dashBloc.add(InitialDashEvent());
  }

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

  String datetap = "false";

  @override
  Widget build(BuildContext context) {
    final _box = GetStorage();
    if (_box.read('token') != null) {
      print(_box.read('token'));
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const AppText(
            title: "Home Screen",
            color: Colors.white,
            font_size: 22,
            fontWeight: FontWeight.w500),
        centerTitle: true,
        backgroundColor: appBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                // color: Colors.blue,
                height: 180,
                child: BlocBuilder<DashBloc, DashState>(
                  bloc: dashBloc,
                  builder: (context, state) {
                    if (state is DashSuccessState) {
                      // double totalPaidBillAmount = state.saleList.length == 0
                      //     ? 0
                      //     : state.saleList
                      //         .map((sale) => sale.paid_bill_amount)
                      //         .reduce((value, element) => value + element);

                      // double totalInvoicePrice = state.saleList.length == 0
                      //     ? 0
                      //     : state.saleList
                      //         .map((sale) => sale.invoice_price)
                      //         .reduce((value, element) => value + element);
                      // double totalDiscount = state.saleList.length == 0
                      //     ? 0
                      //     : state.saleList
                      //         .map((sale) => sale.total_discount)
                      //         .reduce((value, element) => value + element);
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
                                          .map((String item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: datetap == "false"
                                          ? "This month"
                                          : datetap == "custom"
                                              ? "Custom"
                                              : selectedValue,
                                      onChanged: (String? value) {
                                        selectedValue = value;

                                        if (value == "This month") {
                                          datetap = "false";
                                          dashBloc.add(DashThisMonthEvent());
                                        } else if (value == 'Last month') {
                                          datetap = "false";
                                          dashBloc.add(DashLastMonthEvent());
                                        } else if (value == 'This week') {
                                          datetap = "false";
                                          dashBloc.add(DashThisWeekEvent());
                                        } else if (value == 'This year') {
                                          datetap = "false";
                                          dashBloc.add(DashThisYearEvent());
                                        } else if (value == 'This quarter') {
                                          datetap = "false";
                                          dashBloc.add(DashThisQuarterEvent());
                                        } else if (value == 'Custom') {
                                          datetap = "custom";
                                          dashBloc.add(DashCustomDate(
                                              fastDay: state.firstDate,
                                              lastDay: state.lastDate));
                                        }
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        height: 40,
                                        width: 140,
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.calendar_month),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      datetap = "custom";
                                      DateTime now =
                                          await _firstselectDate(context);
                                      firstDay = formatDate(now);
                                      dashBloc.add(DashCustomDate(
                                          fastDay: firstDay, lastDay: lastDay));
                                    },
                                    child: Text(
                                      // state.firstDate,
                                      state.firstDate,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  const Text(
                                    "to",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      datetap = "custom";
                                      DateTime now =
                                          await _lastselectDate(context);
                                      lastDay = formatDate(now);
                                      dashBloc.add(DashCustomDate(
                                          fastDay: firstDay, lastDay: lastDay));
                                    },
                                    child: Text(
                                      // state.lastDate,
                                      state.lastDate,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Color(0xff91919F),
                              ),
                              Expanded(
                                child: SaleDashboardCard(
                                  total_discount: state.totalDiscount,
                                  total_order: state.totalOrder,
                                  paid_amount: state.paidBillAmount,
                                  sale_amount: state.totalSaleAmount,
                                ),
                              ),
                              // Expanded(
                              //   child: ListView.builder(
                              //       itemCount: 3,
                              //       scrollDirection: Axis.horizontal,
                              //       itemBuilder: (context, index) {
                              //         return SaleDashboardCard(
                              //           total_discount: state.totalDiscount,
                              //           total_order: state.totalOrder,
                              //           paid_amount: state.paidBillAmount,
                              //           sale_amount: state.totalSaleAmount,
                              //         );
                              //       }),
                              // ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  AppText(
                      title: "Quick Links",
                      color: Colors.black,
                      font_size: 19,
                      fontWeight: FontWeight.w600)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  QuickLinkCard(
                      imgpath: "assets/images/sale.png",
                      text: "Add Sale",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SalesForm(database: widget.database!)));
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  QuickLinkCard(
                      imgpath: "assets/images/sale.png",
                      text: "Sales list",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaleList()));
                      }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  QuickLinkCard(
                      imgpath: "assets/images/payment.png",
                      text: "Payment Screen",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentRecovery()));
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  QuickLinkCard(
                      imgpath: "assets/images/payment.png",
                      text: "Customer Screen",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerScreen()));
                      }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  QuickLinkCard(
                      imgpath: "assets/images/sale-order.png",
                      text: "Add Sale order",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SalesForm(database: widget.database!)));
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  QuickLinkCard(
                      imgpath: "assets/images/sale.png",
                      text: "Sale order list",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaleList()));
                      }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  QuickLinkCard(
                      imgpath: "assets/images/sale-return.png",
                      text: "Add Sale return",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SalesForm(database: widget.database!)));
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  QuickLinkCard(
                      imgpath: "assets/images/sale-return.png",
                      text: "Sale return list",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaleList()));
                      }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  QuickLinkCard(
                      imgpath: "assets/images/payment.png",
                      text: "Add Daily Expense",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DailyExpenseScreen()));
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  QuickLinkCard(
                      imgpath: "assets/images/daily-expense.png",
                      text: "Daily Expense list",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DailyExpenseList()));
                      }),
                ],
              ),

              Row(
                children: [
                  AppText(
                      title: "Sale Information",
                      color: Colors.black,
                      font_size: 19,
                      fontWeight: FontWeight.w600)
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Login")),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UnknownScreen()));
                  },
                  child: const Text("purchases")),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaleListTable()));
                  },
                  child: const Text("Table")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashboardScreen()));
                  },
                  child: const Text("Dashbaord")),
              // Expanded(
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 4 * 100.0,
              //           height: 250,
              //           child: const CustomBarchart(),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: appBlue,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(
                            title: "Jhon wick",
                            color: Colors.white,
                            font_size: 17,
                            fontWeight: FontWeight.w600),
                        AppText(
                            title: "jhonwick@gmail.com",
                            color: appsearchBoxColor,
                            font_size: 10,
                            fontWeight: FontWeight.w600),
                      ],
                    )
                  ],
                )),
            GFAccordion(
              titleBorderRadius: BorderRadius.circular(10),
              expandedTitleBackgroundColor: Colors.transparent,
              collapsedTitleBackgroundColor: Colors.transparent,
              titleChild: Row(
                children: [
                  Image(width: 25, image: AssetImage("assets/images/sale.png")),
                  SizedBox(
                      width:
                          15), // Add some spacing between the icon and the text
                  AppText(
                    title: 'Sale',
                    color:
                        Colors.black87, // Change the color to match your theme
                    font_size: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              contentChild: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesForm(
                                    database: widget.database!,
                                  )));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: AppText(
                            title: "Sale Form",
                            color: Colors
                                .black87, // Change the color to match your theme
                            font_size: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.black45,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: appsubtitletextColor,
                    thickness: 0.2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SaleList()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: AppText(
                            title: "Sale List",
                            color: Colors
                                .black87, // Change the color to match your theme
                            font_size: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.black45,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GFAccordion(
                titleBorderRadius: BorderRadius.circular(10),
                expandedTitleBackgroundColor: Colors.transparent,
                collapsedTitleBackgroundColor: Colors.transparent,
                titleChild: Row(
                  children: [
                    Image(
                        width: 20,
                        image: AssetImage("assets/images/daily-expense.png")),
                    SizedBox(
                        width:
                            15), // Add some spacing between the icon and the text
                    AppText(
                      title: 'Daily expense',
                      color: Colors
                          .black87, // Change the color to match your theme
                      font_size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                contentChild: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     AppText(
                    //         title: "Sale Recovery",
                    //         color: Color(0xffA0A0A0),
                    //         font_size: 13,
                    //         fontWeight: FontWeight.w600),
                    //     Icon(Icons.arrow_right)
                    //   ],
                    // ),
                    // Divider(
                    //   color: appsubtitletextColor,
                    //   thickness: 0.1,
                    // ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DailyExpenseScreen()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Daily Expense Form",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DailyExpenseList()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Daily Expense List",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            GFAccordion(
                titleBorderRadius: BorderRadius.circular(10),
                expandedTitleBackgroundColor: Colors.transparent,
                collapsedTitleBackgroundColor: Colors.transparent,
                titleChild: Row(
                  children: [
                    Image(
                        width: 20,
                        image: AssetImage("assets/images/sale-order.png")),
                    SizedBox(
                        width:
                            15), // Add some spacing between the icon and the text
                    AppText(
                      title: 'Sale order',
                      color: Colors
                          .black87, // Change the color to match your theme
                      font_size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                contentChild: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SalesOrderForm(
                                      database: widget.database!,
                                    )));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Sale order form",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SaleOrderList()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Sale order list",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),

                    ///////////// Muhammad  Code  End Here-------------------////////////
                  ],
                )),
            GFAccordion(
                titleBorderRadius: BorderRadius.circular(10),
                expandedTitleBackgroundColor: Colors.transparent,
                collapsedTitleBackgroundColor: Colors.transparent,
                titleChild: Row(
                  children: [
                    Image(
                        width: 20,
                        image: AssetImage("assets/images/payment.png")),
                    SizedBox(
                        width:
                            15), // Add some spacing between the icon and the text
                    AppText(
                      title: 'Payment',
                      color: Colors
                          .black87, // Change the color to match your theme
                      font_size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                contentChild: Column(
                  children: [
                    //////////////This is Muhammad Code -------------------////////////

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentRecovery()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Payment Screen",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),

                    //-------------------
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerScreen()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Customer screen",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    //-----------------------
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginscreen()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "login screen",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    //-----------------------
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompletionScreen()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "completion screen",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    //-----------------------
                  ],
                )),
            GFAccordion(
                titleBorderRadius: BorderRadius.circular(10),
                expandedTitleBackgroundColor: Colors.transparent,
                collapsedTitleBackgroundColor: Colors.transparent,
                titleChild: Row(
                  children: [
                    Image(
                        width: 20,
                        image: AssetImage("assets/images/sale-return.png")),
                    SizedBox(
                        width:
                            15), // Add some spacing between the icon and the text
                    AppText(
                      title: 'Sale return',
                      color: Colors
                          .black87, // Change the color to match your theme
                      font_size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                contentChild: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     AppText(
                    //         title: "Sale Recovery",
                    //         color: Color(0xffA0A0A0),
                    //         font_size: 13,
                    //         fontWeight: FontWeight.w600),
                    //     Icon(Icons.arrow_right)
                    //   ],
                    // ),
                    // Divider(
                    //   color: appsubtitletextColor,
                    //   thickness: 0.1,
                    // ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaleReturnForm(
                                      database: widget.database!,
                                    )));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Sale return form",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SaleOrderList()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: AppText(
                                title: "Sale return list",
                                color: Colors
                                    .black87, // Change the color to match your theme
                                font_size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
