import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/daily_expense/UI/daily_expense.dart';
import 'package:okra_distributer/view/first_homescreen/first_home_screen.dart';

import 'package:sqflite/sqflite.dart';

class DailyExpenseAddedScreen extends StatefulWidget {
  final Database? database;
  const DailyExpenseAddedScreen({super.key, this.database});

  @override
  State<DailyExpenseAddedScreen> createState() =>
      _DailyExpenseAddedScreenState();
}

class _DailyExpenseAddedScreenState extends State<DailyExpenseAddedScreen> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                      title: "Daily Expense \n Added",
                      color: Colors.black,
                      font_size: 40,
                      fontWeight: FontWeight.w600),
                ],
              )
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
                              builder: (context) => DailyExpenseScreen()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
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
                        borderRadius: BorderRadius.circular(4),
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
