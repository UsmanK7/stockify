import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/bloc/popUpbloc/popBloc.dart';
import 'package:okra_distributer/bloc/popUpbloc/popEvent.dart';
import 'package:okra_distributer/bloc/popUpbloc/popState.dart';

class Customerdetailpage extends StatefulWidget {
  final Customer customer;

  const Customerdetailpage({super.key, required this.customer});

  @override
  State<Customerdetailpage> createState() => _CustomerdetailpageState();
}

class _CustomerdetailpageState extends State<Customerdetailpage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  List<String> monthNames = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'Sept',
    'October',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
    context.read<Popbloc>().add(FetchCustomerExpenses(widget.customer.id!));
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Customer Detail',
          style: TextStyle(
              fontFamily: 'Roboto', color: Colors.white, fontSize: 21.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<Popbloc, Popstate>(
        builder: (context, state) {
          return Center(
            child: state.isLoading
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.030),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Image(
                            image: AssetImage('assets/images/userP.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.010),
                        Text(
                          widget.customer.name ?? 'Unknown',
                          style:
                              TextStyle(fontFamily: 'Roboto', fontSize: 21.sp),
                        ),
                        Text(
                          widget.customer.email ?? 'No email provided',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14.sp,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.customer.mobile ?? 'No mobile provided',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14.sp,
                              color: Colors.grey),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.030),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Current Balance',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              Text(
                                widget.customer.totalRemainingAmount
                                        ?.toString() ??
                                    '0.0',
                                style: TextStyle(fontSize: 18.sp),
                              )
                            ],
                          ),
                        ),
                        TabBar(
                          controller: tabController,
                          labelColor: Colors.blue,
                          onTap: (index) {
                            // Ensure that the state is updated only if it is not null
                            if (state != null) {
                              state.currentIndex = index;
                            }
                          },
                          tabs: [
                            Tab(text: 'List'),
                            Tab(text: 'Charts'),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: DataTable(
                                  columnSpacing: 11,
                                  dataRowHeight: 20,
                                  headingRowHeight: 20,
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.grey[300]),
                                  columns: [
                                    DataColumn(label: Text('Month')),
                                    DataColumn(label: Text('Paid Amount')),
                                    DataColumn(label: Text('Sale Amount')),
                                  ],
                                  rows: List.generate(12, (index) {
                                    return DataRow(
                                      color: MaterialStateProperty.resolveWith<
                                          Color>((states) {
                                        return index % 2 == 0
                                            ? Colors.white
                                            : Colors.grey[200]!;
                                      }),
                                      cells: [
                                        DataCell(Text(monthNames[index])),
                                        DataCell(Text(state.paidAmount?[index]
                                                ?.toString() ??
                                            '0.0')),
                                        DataCell(Text(state.saleAmount?[index]
                                                ?.toString() ??
                                            '0.0')),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: BarChart(
                                  BarChartData(
                                    maxY: state.maxValue ?? 0.0,
                                    alignment: BarChartAlignment.start,
                                    barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
                                          if (rod.toY > 0) {
                                            return BarTooltipItem(
                                              rodIndex == 0
                                                  ? 'Paid: ${rod.toY}'
                                                  : 'Sale: ${rod.toY}',
                                              TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            );
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            switch (value.toInt()) {
                                              case 0:
                                                return Text('Jan',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 1:
                                                return Text('Feb',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 2:
                                                return Text('Mar',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 3:
                                                return Text('Apr',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 4:
                                                return Text('May',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 5:
                                                return Text('Jun',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 6:
                                                return Text('Jul',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 7:
                                                return Text('Aug',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 8:
                                                return Text('Sep',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 9:
                                                return Text('Oct',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 10:
                                                return Text('Nov',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              case 11:
                                                return Text('Dec',
                                                    style: TextStyle(
                                                        fontSize: 9.sp));
                                              default:
                                                return Text('');
                                            }
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      leftTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    barGroups: List.generate(12, (index) {
                                      return BarChartGroupData(
                                        x: index,
                                        barRods: [
                                          BarChartRodData(
                                            width: 20,
                                            toY:
                                                state.paidAmount?[index] ?? 0.0,
                                            color: Colors.green,
                                          ),
                                          BarChartRodData(
                                            toY:
                                                state.saleAmount?[index] ?? 0.0,
                                            width: 20,
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
