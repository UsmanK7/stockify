import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class infoCont extends StatefulWidget {
  final String? name;
  final DateTime? date;
  final int? price;
  final String? refNo;
  const infoCont({super.key, this.name, this.price, this.refNo, this.date});

  @override
  State<infoCont> createState() => _infoContState();
}

class _infoContState extends State<infoCont> {
  @override
  Widget build(BuildContext context) {
    String displayName = widget.name ?? 'No name';
    String displayDate = widget.date != null
        ? DateFormat('yyyy-MM-dd').format(widget.date!)
        : 'No date';
    String displayRefNo =
        widget.refNo != null ? widget.refNo.toString() : 'No ref';
    String displayPrice = widget.price?.toString() ?? '0';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .25,
                  ),
                  Text(
                    displayDate,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .010,
              ),
              Row(children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .060,
                ),
                Text(
                  displayPrice,
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'Roboto',
                    fontSize: 12.sp,
                  ),
                ),
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height * .005,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.refNo != null ? widget.refNo.toString() : 'No ref',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    width: widget.refNo != null
                        ? MediaQuery.of(context).size.width * .030
                        : 0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .40,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.print,
                            color: Colors.grey,
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .010,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share,
                            color: Colors.grey,
                          ))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
