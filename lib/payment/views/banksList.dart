import 'package:flutter/material.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/payment/views/BankWidgtes/bankWidgets.dart';

class BankList extends StatefulWidget {
  const BankList({super.key});

  @override
  State<BankList> createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  Future<List<Bank>>? _bankFutureList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bankFutureList = DBHelper().getAllBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bank List',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Column(children: [
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
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    hintText: 'Search',
                    trailing: [Icon(Icons.search)],
                  )),
              // IconButton(
              //     onPressed: () {}, icon: Icon(Icons.filter_alt_sharp))
            ],
          ),
        ),
        FutureBuilder<List<Bank>>(
            future: _bankFutureList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No bank found'));
              } else {
                final bank = snapshot.data!;
                final filteredBanks = bank
                    .where((bank) =>
                        bank.name!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        bank.sAccountNo!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                    .toList();
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredBanks.length,
                    itemBuilder: (context, index) {
                      final bank = filteredBanks[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => Customerdetailpage(
                          //       customer: customer,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Bankwidgets(
                          balance: bank.dcDefaultAmount!.toDouble(),
                          name: bank.name!,
                          accountNumber: bank.sAccountNo!,
                        ),
                      );
                    },
                  ),
                );
              }
            }),
      ]),
    );
  }
}
