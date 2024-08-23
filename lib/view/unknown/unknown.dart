import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/unknown/customer_ui/unknown_customer_ui.dart';

class Transaction {
  final int serialNumber;
  final String date;
  final String particle;
  final double debit;
  final String customerName;
  final double credit;
  final double balance;
  final String description;

  Transaction({
    required this.serialNumber,
    required this.particle,
    required this.date,
    required this.debit,
    required this.credit,
    required this.customerName,
    required this.balance,
    required this.description,
  });
}

class UnknownScreen extends StatefulWidget {
  const UnknownScreen({super.key});

  @override
  State<UnknownScreen> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {
  //Muhammad's code
  //Muhammad's code
  List<bool> _expanded = [];

  List<Transaction> transactions = [
    Transaction(
      serialNumber: 1,
      particle: 'Item 1',
      date: '2024-08-23',
      debit: 100.0,
      customerName: "Jordi Alba",
      credit: 0.0,
      balance: 100.0,
      description: 'Description of Item 1',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),

    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    Transaction(
      serialNumber: 2,
      particle: 'Item 2',
      date: '2024-08-23',
      customerName: "Cristiano ronaldo",
      debit: 0.0,
      credit: 50.0,
      balance: 50.0,
      description: 'Description of Item 2',
    ),
    // Add more transactions as needed
  ];

  @override
  void initState() {
    super.initState();
    _expanded = List.generate(transactions.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const AppText(
            title: "Purchases",
            color: Colors.white,
            font_size: 22,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
          backgroundColor: appBlue,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomerOrderScreen(),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: appBlue,
                        ),
                        height: 40,
                        child: Center(
                          child: AppText(
                            color: Colors.white,
                            title: "Print",
                            font_size: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: appBlue,
                        ),
                        height: 40,
                        child: Center(
                          child: AppText(
                            title: "Pdf",
                            color: Colors.white,
                            font_size: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: appBlue,
                        ),
                        height: 40,
                        child: Center(
                          child: AppText(
                            title: "Excel",
                            color: Colors.white,
                            font_size: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: appBlue,
                        ),
                        height: 40,
                        child: Center(
                          child: AppText(
                            title: "CSV",
                            color: Colors.white,
                            font_size: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                _buildTableHeader(),
                SizedBox(
                  height: AppTotalScreenHeight(context) - 340,
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _buildTableRow(transactions[index], index);
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 5.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color:
                                appsearchBoxColor, // Set the color of the right border here
                            width: 1, // Set the width of the right border here
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              title: "Total",
                              color: Colors.black,
                              font_size: 15,
                              fontWeight: FontWeight.w400),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(right: 20),
                    //   decoration: BoxDecoration(
                    //     border: Border(
                    //       right: BorderSide(
                    //         color:
                    //             appsearchBoxColor, // Set the color of the right border here
                    //         width:
                    //             1, // Set the width of the right border here
                    //       ),
                    //     ),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       AppText(
                    //           title: "Paid bill",
                    //           color: Colors.black,
                    //           font_size: 15,
                    //           fontWeight: FontWeight.w400),
                    //       AppText(
                    //           title: totalPaidBillAmount.toString(),
                    //           color: appsubtitletextColor,
                    //           font_size: 15,
                    //           fontWeight: FontWeight.w400),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color:
                                appsearchBoxColor, // Set the color of the right border here
                            width: 1, // Set the width of the right border here
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              title: "Balance",
                              color: Colors.black,
                              font_size: 15,
                              fontWeight: FontWeight.w400),
                          AppText(
                              title: "35515",
                              color: appsubtitletextColor,
                              font_size: 15,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                    Container(
                      padding: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color:
                                appsearchBoxColor, // Set the color of the right border here
                            width: 1, // Set the width of the right border here
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              title: "Credit",
                              color: Colors.black,
                              font_size: 15,
                              fontWeight: FontWeight.w400),
                          AppText(
                              title: "35515",
                              color: appsubtitletextColor,
                              font_size: 15,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              title: "Debit",
                              color: Colors.black,
                              font_size: 15,
                              fontWeight: FontWeight.w400),
                          AppText(
                              title: "35515",
                              color: appsubtitletextColor,
                              font_size: 15,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildTableHeader() {
    return Container(
      color: appBlue,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          _buildHeaderCell('SR#'),
          _buildHeaderCell('Date'),
          _buildHeaderCell('Particle'),
          _buildHeaderCell('Debit'),
          _buildHeaderCell('Credit'),
          _buildHeaderCell('Balance'),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Expanded(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow(Transaction transaction, int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded[index] = !_expanded[index];
            });
          },
          child: Container(
            // color: _expanded[index] ? Colors.grey[200] : Colors.white,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Row(
              children: [
                _buildCell(transaction.serialNumber.toString()),
                _buildCell(transaction.date),
                _buildCell(transaction.particle),
                _buildCell(transaction.debit.toString()),
                _buildCell(transaction.credit.toString()),
                _buildCell(transaction.balance.toString()),
              ],
            ),
          ),
        ),
        if (_expanded[index])
          Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        title: "Added by :  ",
                        color: Colors.black,
                        font_size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      Text(
                        transaction.customerName,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title: "Description : ",
                        color: Colors.black,
                        font_size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      Text(
                        transaction.description,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )
                ],
              )),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
