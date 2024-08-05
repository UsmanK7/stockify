import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/bloc/popUpbloc/popBloc.dart';
import 'package:okra_distributer/bloc/popUpbloc/popEvent.dart';
import 'package:okra_distributer/bloc/popUpbloc/popState.dart';
import 'package:okra_distributer/payment/views/CustomWidgets/infoCont.dart';

class Customerreciptlist extends StatefulWidget {
  const Customerreciptlist({Key? key}) : super(key: key);

  @override
  _CustomerreciptlistState createState() => _CustomerreciptlistState();
}

class _CustomerreciptlistState extends State<Customerreciptlist> {
  final dateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    DateTime startDate = DateTime.now().subtract(Duration(days: 1));
    DateTime endDate = DateTime.now();
    context
        .read<Popbloc>()
        .add(FilterPaymentsByDate(startDate: startDate, endDate: endDate));
    // context.read<Popbloc>().add(LoadAllPayments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Customer Receipt List',
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              _pickDateRange(context);
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 240, 240, 243),
      body: BlocBuilder<Popbloc, Popstate>(
        builder: (context, state) {
          DateTime startDate =
              state.startDate ?? DateTime.now().subtract(Duration(days: 30));
          DateTime endDate = state.endDate ?? DateTime.now();
          List<PermanentCustomerPayment> paymentsToShow =
              state.filteredPayments ?? [];

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.date_range),
                    TextButton(
                      onPressed: () {
                        _pickStartDate(context, startDate, endDate);
                      },
                      child: Text('${_formattedDate(startDate)}'),
                    ),
                    Icon(Icons.date_range),
                    TextButton(
                      onPressed: () {
                        _pickEndDate(context, startDate, endDate);
                      },
                      child: Text('${_formattedDate(endDate)}'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: paymentsToShow.length,
                    separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * .003),
                    itemBuilder: (context, index) {
                      PermanentCustomerPayment payment = paymentsToShow[index];
                      return infoCont(
                        name: payment.customerName ?? 'No table name',
                        price: payment.dcPaidAmount != null
                            ? payment.dcPaidAmount!.toInt()
                            : 0,
                        refNo: payment.sInvoiceNo ?? '',
                        date: payment.dDate,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _pickStartDate(
      BuildContext context, DateTime startDate, DateTime endDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != startDate) {
      context
          .read<Popbloc>()
          .add(FilterPaymentsByDate(startDate: picked, endDate: endDate));
    }
  }

  void _pickEndDate(
      BuildContext context, DateTime startDate, DateTime endDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != endDate) {
      context
          .read<Popbloc>()
          .add(FilterPaymentsByDate(startDate: startDate, endDate: picked));
    }
  }

  String _formattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 30)),
      end: DateTime.now(),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: initialDateRange.start,
        end: initialDateRange.end,
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDateRange != null) {
      context.read<Popbloc>().add(FilterPaymentsByDate(
          startDate: newDateRange.start, endDate: newDateRange.end));
    }
  }
}
