import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerWidget extends StatefulWidget {
  final String? name;
  final String? email;
  final String? contactNumber;
  final double? balance;
  const CustomerWidget(
      {super.key,
      required this.balance,
      required this.contactNumber,
      required this.email,
      required this.name});

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Stack(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: AssetImage('assets/images/userP.png')),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.090,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name!,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0080,
                    ),
                    Text(
                      widget.email!,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0040,
                    ),
                    Text(
                      widget.contactNumber!,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.80,
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
