import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bankwidgets extends StatefulWidget {
  final String name;
  final String accountNumber;
  final double balance;

  const Bankwidgets(
      {super.key,
      required this.accountNumber,
      required this.balance,
      required this.name});

  @override
  State<Bankwidgets> createState() => _BankwidgetsState();
}

class _BankwidgetsState extends State<Bankwidgets> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Stack(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: AssetImage('assets/images/bank.png')),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.040,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.010,
                    ),
                    Text(
                      '${widget.name}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0080,
                    ),
                    Text(
                      '${widget.accountNumber}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.76,
              child: Text(
                "${widget.balance.toString()}Rs",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Roboto', fontSize: 16.sp),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
