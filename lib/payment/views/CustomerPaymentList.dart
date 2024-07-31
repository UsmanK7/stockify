import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:okra_distributer/payment/views/CustomerReciptList.dart';

class Payment_list extends StatefulWidget {
  const Payment_list({super.key});

  @override
  State<Payment_list> createState() => _Payment_listState();
}

class _Payment_listState extends State<Payment_list> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Customer Payment List ',
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Color(0xFF7F3DFF),
        body: Stack(
          children: [
            Positioned(
                top: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(60)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .030,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Customerreciptlist()));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Color(0xFF7F3DFF),
                                  ),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                                child: Text(
                                  'Filter',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontFamily: 'Roboto'),
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Color(0xFF7F3DFF),
                                  ),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                                child: Text(
                                  'Export',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontFamily: 'Roboto'),
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Color(0xFF7F3DFF),
                                  ),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                                child: Text(
                                  'Print',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontFamily: 'Roboto'),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .030,
                      ),
                      //0xFFECEDFF
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(columns: [
                          DataColumn(label: Text('Sr No')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Amount')),
                        ], rows: [
                          DataRow(
                            cells: [
                              DataCell(Text('#1')),
                              DataCell(Text('11-4-2024')),
                              DataCell(Text('Malik')),
                              DataCell(Text('Rs 1500'))
                            ],
                          ),
                          DataRow(
                            color: WidgetStateProperty.all(
                                Color.fromARGB(255, 207, 209, 238)),
                            cells: [
                              DataCell(Text('#2')),
                              DataCell(Text('11-4-2024')),
                              DataCell(Text('Malik')),
                              DataCell(Text('Rs 1500'))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('#3')),
                              DataCell(Text('11-4-2024')),
                              DataCell(Text('Malik')),
                              DataCell(Text('Rs 1500'))
                            ],
                          ),
                          DataRow(
                            color: WidgetStateProperty.all(
                                Color.fromARGB(255, 207, 209, 238)),
                            cells: [
                              DataCell(Text('#4')),
                              DataCell(Text('11-4-2024')),
                              DataCell(Text('Malik')),
                              DataCell(Text('Rs 1500'))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('#5')),
                              DataCell(Text('11-4-2024')),
                              DataCell(Text('Malik')),
                              DataCell(Text('Rs 1500'))
                            ],
                          ),
                          DataRow(
                            color: WidgetStateProperty.all(
                                Color.fromARGB(255, 207, 209, 238)),
                            cells: [
                              DataCell(Text('#6')),
                              DataCell(Text('11-4-2024')),
                              DataCell(Text('Malik')),
                              DataCell(Text('Rs 1500'))
                            ],
                          ),
                        ]),
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}
