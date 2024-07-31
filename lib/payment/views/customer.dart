import 'package:flutter/material.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/payment/views/CustomWidgets/customerWid.dart';
import 'package:okra_distributer/payment/views/customerDetailPage.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final String name = 'malik';
  final String contactNumber = '03097221848';
  final String email = 'malikmuhammad103@gmail.com';
  final int balannce = 99;
  Future<List<Customer>>? _customerListFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customerListFuture = DBHelper().getallCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Customer',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.060,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: SearchBar(
                        controller: _searchController,
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        hintText: 'Search',
                        trailing: [Icon(Icons.search)],
                      )),
                  // IconButton(
                  //     onPressed: () {}, icon: Icon(Icons.filter_alt_sharp))
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            FutureBuilder<List<Customer>>(
              future: _customerListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No customers found'));
                } else {
                  final customers = snapshot.data!;
                  final filteredCustomers = customers.where((customer) {
                    final searchText = _searchController.text.toLowerCase();
                    return customer.name!.toLowerCase().contains(searchText) ||
                        (customer.email?.toLowerCase().contains(searchText) ??
                            false) ||
                        (customer.mobile?.toLowerCase().contains(searchText) ??
                            false);
                  }).toList();
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Customerdetailpage(
                                  customer: customer,
                                ),
                              ),
                            );
                          },
                          child: CustomerWidget(
                            balance:
                                customer.totalRemainingAmount?.toDouble() ??
                                    0.0,
                            name: customer.name,
                            email: customer.email ?? 'N/A',
                            contactNumber: customer.mobile ?? 'N/A',
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.70,
          left: MediaQuery.of(context).size.width * 0.13,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Row(
                children: [
                  FutureBuilder(
                    future: _customerListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Removed Center widget
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Removed Center widget
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text(
                            'No customers found'); // Removed Center widget
                      } else {
                        final customers = snapshot.data!;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Total Customer'),
                            Text('${customers.length}'),
                          ],
                        );
                      }
                    },
                  ),
                  VerticalDivider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  FutureBuilder(
                    future: _customerListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No customers found');
                      } else {
                        final customers = snapshot.data!;

                        final totalAmount = customers.fold<double>(
                          0.0,
                          (sum, customer) =>
                              sum + (customer.totalRemainingAmount ?? 0.0),
                        );

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Total Amount'),
                            Text('${totalAmount.toStringAsFixed(2)}'),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
