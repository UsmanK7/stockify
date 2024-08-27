import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';

class SaleListTable extends StatefulWidget {
  const SaleListTable({super.key});

  @override
  _SaleListTableState createState() => _SaleListTableState();
}

class _SaleListTableState extends State<SaleListTable> {
  final List<Map<String, dynamic>> saleData = [
    {
      "Sale ID": 1,
      "Customer Name": "John Doe",
      "Invoice Price": 100.0,
      "Total Discount": 10.0,
      "Sale Date": "2024-08-26",
      "Paid Bill Amount": 90.0,
      "Sync Status": "Synced"
    },
    {
      "Sale ID": 2,
      "Customer Name": "Jane Smith",
      "Invoice Price": 200.0,
      "Total Discount": 20.0,
      "Sale Date": "2024-08-25",
      "Paid Bill Amount": 180.0,
      "Sync Status": "Pending"
    },
    // Add more data here
  ];

  List<Map<String, dynamic>> filteredData = [];
  String searchQuery = "";

  // Controllers for date pickers
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    filteredData = saleData;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredData = saleData
          .where((sale) => sale.values.any((value) =>
              value.toString().toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, DateTime? initialDate) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != initialDate) {
      setState(() {
        controller.text = "${selectedDate.toLocal()}".split(' ')[0];
        if (controller == startDateController) {
          startDate = selectedDate;
        } else if (controller == endDateController) {
          endDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const AppText(
          title: "Sale List",
          color: Colors.white,
          font_size: 22,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        backgroundColor: appBlue,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Opens the end drawer
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: appBlue,
              ),
              child: const Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: startDateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context, startDateController, startDate);
                        },
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context, endDateController, endDate);
                        },
                      ),
                    ),
                    readOnly: true,
                  ),
                  // You can add more filter options here
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Enter search term",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: updateSearchQuery,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                color: appBlue,
                child: DataTable(
                  columnSpacing: 10,
                  columns: saleData.isNotEmpty
                      ? saleData[0].keys.map((key) {
                          return DataColumn(
                            label: Text(
                              key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                  rows: filteredData.map((sale) {
                    return DataRow(
                      cells: sale.values.map((value) {
                        return DataCell(
                          Container(
                            color:
                                Colors.white, // Background color for each cell
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value.toString()),
                          ),
                        );
                      }).toList(),
                      color: MaterialStateProperty.all(
                          Colors.white), // Ensure row background color
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
