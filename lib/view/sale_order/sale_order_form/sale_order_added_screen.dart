import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/first_homescreen/first_home_screen.dart';

import 'package:okra_distributer/view/sale_order/sale_order_form/sales_order_form.dart';
import 'package:sqflite/sqflite.dart';

class SaleOrderAddedScreen extends StatefulWidget {
  final Database database;
  const SaleOrderAddedScreen({super.key, required this.database});

  @override
  State<SaleOrderAddedScreen> createState() => _SaleOrderAddedScreenState();
}

class _SaleOrderAddedScreenState extends State<SaleOrderAddedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Lottie.asset('animations/sale-added.json',
                  height: 300, reverse: true, repeat: false, fit: BoxFit.cover),
              AppText(
                  title: "Sale Order Added",
                  color: Colors.black,
                  font_size: 40,
                  fontWeight: FontWeight.w600),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesOrderForm(
                                    database: widget.database,
                                  )));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: appBlue,
                      ),
                      child: Center(
                        child: AppText(
                          title: "Add more",
                          color: Colors.white,
                          font_size: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FirstHomeScreen(database: widget.database)));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: appBlue,
                      ),
                      child: Center(
                        child: AppText(
                          title: "Go to Dashboard",
                          color: Colors.white,
                          font_size: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
