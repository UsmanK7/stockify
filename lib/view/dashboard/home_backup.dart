// import 'package:flutter/material.dart';
// import 'package:getwidget/components/accordion/gf_accordion.dart';
// import 'package:okra_distributer/components/sale_card.dart';
// import 'package:okra_distributer/components/text_component.dart';
// import 'package:okra_distributer/consts/const.dart';
// import 'package:okra_distributer/view/dashboard/bar_chart.dart';
// import 'package:okra_distributer/view/dashboard/bloc/dash_bloc.dart';
// import 'package:okra_distributer/view/dashboard/bloc/dash_event.dart';
// import 'package:okra_distributer/view/dashboard/models/chart_data_model.dart';
// import 'package:okra_distributer/view/sale/sale%20form/sales_form.dart';
// import 'package:okra_distributer/view/sale/sale_list/UI/sale_list.dart';

// import 'package:sqflite/sqflite.dart';

// class HomeScreen extends StatefulWidget {
//   final Database database;
//   const HomeScreen({super.key, required this.database});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   DashBloc dashBloc = DashBloc();

//   @override
//   void initState() {
//     super.initState();
//     dashBloc.add(InitialDashEvent());
//   }

//   final List<String> items = [
//     'This week',
//     'This month',
//     'Last month',
//     'This quarter',
//     'This year',
//     'Custom',
//   ];
//   String? selectedValue;
//   DateTime _selectedDate = DateTime.now();
//   TextEditingController _firstdateController = TextEditingController();
//   TextEditingController _lastdateController = TextEditingController();

//   Future<DateTime> _firstselectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2070),
//     );
//     if (picked != null && picked != _selectedDate) {
//       _selectedDate = picked;
//       _firstdateController.text = formatDate(_selectedDate);
//     }
//     return picked!;
//   }

//   Future<DateTime> _lastselectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2070),
//     );
//     if (picked != null && picked != _selectedDate) {
//       _selectedDate = picked;
//       _lastdateController.text = formatDate(_selectedDate);
//     }
//     return picked!;
//   }

//   bool datetap = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const AppText(
//             title: "Dashboard",
//             color: Colors.white,
//             font_size: 22,
//             fontWeight: FontWeight.w500),
//         centerTitle: true,
//         backgroundColor: appBlue,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 105,
//               child: ListView.builder(
//                   itemCount: 3,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return SaleDashboardCard();
//                   }),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 AppText(
//                     title: "Sale Information",
//                     color: Colors.black,
//                     font_size: 19,
//                     fontWeight: FontWeight.w600)
//               ],
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 4 * 100.0,
//                       height: 250,
//                       child: BarChartSample7(
//                         chartData: [
//                           ChartDataModel(chart1: 300, chart2: 200),
//                           ChartDataModel(chart1: 400, chart2: 500),
//                           ChartDataModel(chart1: 900, chart2: 800),
//                           ChartDataModel(chart1: 900, chart2: 800),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: appBlue,
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: AssetImage("assets/images/user.png"),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AppText(
//                             title: "Jhon wick",
//                             color: Colors.white,
//                             font_size: 17,
//                             fontWeight: FontWeight.w600),
//                         AppText(
//                             title: "jhonwick@gmail.com",
//                             color: appsearchBoxColor,
//                             font_size: 10,
//                             fontWeight: FontWeight.w600),
//                       ],
//                     )
//                   ],
//                 )),
//             GFAccordion(
//                 titleBorderRadius: BorderRadius.circular(10),
//                 collapsedTitleBackgroundColor: Colors.white,
//                 title: 'Sale',
//                 contentChild: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppText(
//                             title: "Sale Recovery",
//                             color: Color(0xffA0A0A0),
//                             font_size: 13,
//                             fontWeight: FontWeight.w600),
//                         Icon(Icons.arrow_right)
//                       ],
//                     ),
//                     Divider(
//                       color: appsubtitletextColor,
//                       thickness: 0.1,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SaleList()));
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(
//                               title: "Sale List",
//                               color: Color(0xffA0A0A0),
//                               font_size: 13,
//                               fontWeight: FontWeight.w600),
//                           Icon(Icons.arrow_right)
//                         ],
//                       ),
//                     ),
//                     Divider(
//                       color: appsubtitletextColor,
//                       thickness: 0.2,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SalesForm(
//                                       database: widget.database,
//                                     )));
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(
//                               title: "Sale Form ",
//                               color: Color(0xffA0A0A0),
//                               font_size: 13,
//                               fontWeight: FontWeight.w600),
//                           Icon(Icons.arrow_right)
//                         ],
//                       ),
//                     ),
//                   ],
//                 )),
//             GFAccordion(
//                 titleBorderRadius: BorderRadius.circular(10),
//                 collapsedTitleBackgroundColor: Colors.white,
//                 title: 'Payment List',
//                 contentChild: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppText(
//                             title: "Sale Recovery",
//                             color: Color(0xffA0A0A0),
//                             font_size: 13,
//                             fontWeight: FontWeight.w600),
//                         Icon(Icons.arrow_right)
//                       ],
//                     ),
//                     Divider(
//                       color: appsubtitletextColor,
//                       thickness: 0.1,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppText(
//                             title: "Sale List ",
//                             color: Color(0xffA0A0A0),
//                             font_size: 13,
//                             fontWeight: FontWeight.w600),
//                         Icon(Icons.arrow_right)
//                       ],
//                     ),
//                     Divider(
//                       color: appsubtitletextColor,
//                       thickness: 0.2,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppText(
//                             title: "Sale List ",
//                             color: Color(0xffA0A0A0),
//                             font_size: 13,
//                             fontWeight: FontWeight.w600),
//                         Icon(Icons.arrow_right)
//                       ],
//                     ),
//                   ],
//                 )),
//             GFAccordion(
//                 titleBorderRadius: BorderRadius.circular(10),
//                 collapsedTitleBackgroundColor: Colors.white,
//                 title: 'Products',
//                 contentChild: Column(
//                   children: [
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppText(
//                             title: "Sale Recovery",
//                             color: Color(0xffA0A0A0),
//                             font_size: 13,
//                             fontWeight: FontWeight.w600),
//                         Icon(Icons.arrow_right)
//                       ],
//                     ),
//                     Divider(
//                       color: appsubtitletextColor,
//                       thickness: 0.1,
//                     ),
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppText(
//                             title: "Sale List ",
//                             color: Color(0xffA0A0A0),
//                             font_size: 13,
//                             fontWeight: FontWeight.w600),
//                         Icon(Icons.arrow_right)
//                       ],
//                     ),
//                     Divider(
//                       color: appsubtitletextColor,
//                       thickness: 0.2,
//                     ),
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppText(
//                             title: "Sale List ",
//                             color: Color(0xffA0A0A0),
//                             font_size: 13,
//                             fontWeight: FontWeight.w600),
//                         Icon(Icons.arrow_right)
//                       ],
//                     ),
//                   ],
//                 )),
//             // ListTile(
//             //   leading: const Icon(Icons.message),
//             //   title: const Text('Messages'),
//             // ),
//             // ListTile(
//             //   leading: const Icon(Icons.account_circle),
//             //   title: const Text('Profile'),
//             // ),
//             // ListTile(
//             //   leading: const Icon(Icons.settings),
//             //   title: const Text('Settings'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
