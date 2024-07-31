// import 'package:flutter/material.dart';
// import 'package:payment_mod/payment/views/CustomerReciptList.dart';
// import 'package:payment_mod/payment/views/Payment_recovery.dart';
// import 'package:payment_mod/payment/views/apicheckingScreen.dart';
// import 'package:payment_mod/payment/views/banksList.dart';
// import 'package:payment_mod/payment/views/customer.dart';
// import 'package:payment_mod/payment/views/loginScreen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({
//     super.key,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => PaymentRecovery()));
//               },
//               child: Text('Payment Screen')),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => Customerreciptlist()));
//               },
//               child: Text('Recipt Scfreen')),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => CustomerScreen()));
//               },
//               child: Text('Customer Screen')),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => CompletionScreen()));
//               },
//               child: Text('sync')),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Loginscreen()));
//               },
//               child: Text('LoginScreen')),
//           ElevatedButton(onPressed: () {}, child: Text('Firm getting')),
//         ],
//       ),
//     );
//   }
// }
