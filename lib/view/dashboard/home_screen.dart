import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:okra_distributer/components/sale_card.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/views/CustomerReciptList.dart';
import 'package:okra_distributer/payment/views/Payment_recovery.dart';
import 'package:okra_distributer/payment/views/apicheckingScreen.dart';
import 'package:okra_distributer/payment/views/customer.dart';
import 'package:okra_distributer/payment/views/loginScreen.dart';
import 'package:okra_distributer/view/auth/login_screen.dart';
import 'package:okra_distributer/view/dashboard/bar_chart.dart';
import 'package:okra_distributer/view/dashboard/bloc/dash/dash_bloc.dart';
import 'package:okra_distributer/view/dashboard/bloc/dash/dash_event.dart';
import 'package:okra_distributer/view/dashboard/bloc/dash/dash_state.dart';

import 'package:okra_distributer/view/sale/sale%20form/sales_form.dart';
import 'package:okra_distributer/view/sale/sale_list/UI/sale_list.dart';
import 'package:okra_distributer/view/sale_order/sale_order_form/sales_order_form.dart';
import 'package:okra_distributer/view/sale_order/sale_order_list/UI/sale_order_list.dart';
import 'package:okra_distributer/view/sale_return/sale_return_form/sales_return_form.dart';

import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  final Database database;
  const HomeScreen({super.key, required this.database});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const AppText(
            title: "Dashboard",
            color: Colors.white,
            font_size: 22,
            fontWeight: FontWeight.w500),
        centerTitle: true,
        backgroundColor: appBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              // color: Colors.blue,
              height: 160,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 140,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SaleDashboardCard(
                                    total_discount: state.totalDiscount,
                                    total_order: state.totalOrder,
                                    paid_amount: state.paidBillAmount,
                                    sale_amount: state.totalSaleAmount,
                                  ),
                                ],
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 4 * 100.0,
                      height: 250,
                      child: const CustomBarchart(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
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
                collapsedTitleBackgroundColor: Colors.white,
                title: 'Sale',
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
                                builder: (context) => const SaleList()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              title: "Sale List",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
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
                                builder: (context) => SalesForm(
                                      database: widget.database,
                                    )));
                      },

                      //---------------------Muhammad Routes-----------------------//

                      //--------------------Muhammad Merger End Here --------------------////////

                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              title: "Sale Form ",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
                        ],
                      ),
                    ),
                  ],
                )),
            GFAccordion(
                titleBorderRadius: BorderRadius.circular(10),
                collapsedTitleBackgroundColor: Colors.white,
                title: 'Sale Order',
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
                                builder: (context) => const SaleOrderList()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              title: "Sale order List",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
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
                                builder: (context) => SalesOrderForm(
                                      database: widget.database,
                                    )));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              title: "Sale order Form ",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
                        ],
                      ),
                    ),

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
                          AppText(
                              title: "Payment Screen",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
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
                          AppText(
                              title: "Custmer Screen",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
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
                          AppText(
                              title: "login Screen",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
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
                          AppText(
                              title: "CompletionScreen",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
                        ],
                      ),
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    //-----------------------

                    ///////////// Muhammad  Code  End Here-------------------////////////
                  ],
                )),
            GFAccordion(
                titleBorderRadius: BorderRadius.circular(10),
                collapsedTitleBackgroundColor: Colors.white,
                title: 'Sale Return',
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
                                builder: (context) => const SaleOrderList()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              title: "Sale return List",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
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
                                builder: (context) => SaleReturnForm(
                                      database: widget.database,
                                    )));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              title: "Sale return Form ",
                              color: Color(0xffA0A0A0),
                              font_size: 13,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_right)
                        ],
                      ),
                    ),
                  ],
                )),
            GFAccordion(
                titleBorderRadius: BorderRadius.circular(10),
                collapsedTitleBackgroundColor: Colors.white,
                title: 'Payment List',
                contentChild: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            title: "Dummy",
                            color: Color(0xffA0A0A0),
                            font_size: 13,
                            fontWeight: FontWeight.w600),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.1,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            title: "Dummy",
                            color: Color(0xffA0A0A0),
                            font_size: 13,
                            fontWeight: FontWeight.w600),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                    Divider(
                      color: appsubtitletextColor,
                      thickness: 0.2,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            title: "Dummy",
                            color: Color(0xffA0A0A0),
                            font_size: 13,
                            fontWeight: FontWeight.w600),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
