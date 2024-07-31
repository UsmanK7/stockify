// import 'package:flutter/material.dart';
// import 'package:okra_distributer/services/dbhelper.dart';
// import 'package:okra_distributer/view/sale/sale%20form/customer_ui/customer_screen.dart';
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
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => SalesForm(
//                           database: widget.database,
//                         )));
//           },
//           child: Text("sales form"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => SaleList()));
//           },
//           child: Text("sales list"),
//         ),
//       ],
//     ));
//   }
// }
