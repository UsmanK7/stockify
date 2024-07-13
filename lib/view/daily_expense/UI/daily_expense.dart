import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:okra_distributer/bloc/popUpbloc/popBloc.dart';
import 'package:okra_distributer/bloc/popUpbloc/popEvent.dart';
import 'package:okra_distributer/bloc/popUpbloc/popState.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/view/daily_expense/bloc/daily_expense_bloc.dart';
import 'package:okra_distributer/view/daily_expense/bloc/daily_expense_event.dart';
import 'package:okra_distributer/view/daily_expense/bloc/daily_expense_state.dart';
import 'package:okra_distributer/view/daily_expense/bloc/date_picker_bloc/data_picker_bloc.dart';
import 'package:okra_distributer/view/daily_expense/bloc/date_picker_bloc/data_picker_event.dart';
import 'package:okra_distributer/view/daily_expense/bloc/date_picker_bloc/data_picker_state.dart';
import 'package:okra_distributer/view/daily_expense/UI/daily_expense_added_screen.dart';
import 'package:okra_distributer/view/daily_expense/data/billed_items.dart';
import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';

class DailyExpenseScreen extends StatefulWidget {
  const DailyExpenseScreen({super.key});

  @override
  State<DailyExpenseScreen> createState() => _DailyExpenseScreenState();
}

class _DailyExpenseScreenState extends State<DailyExpenseScreen> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool IsPressed = true;
  DailyExpenseBloc dailyExpenseBloc = DailyExpenseBloc();

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2070),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatDate(_selectedDate);
      });
    }
    return formatDate(_selectedDate);
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'No time selected';
    }
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formatter = DateFormat('hh:mm:ss a');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    _dateController.text = formatDate(_selectedDate);
    context.read<Popbloc>().add(SelectBanks(''));
    dailyExpenseBloc.add(DailyExpenseTypeActionEvent());
    super.initState();
  }

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  int? ExpenseTypeID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Daily Expense",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: appborder)),
                            child: BlocBuilder<DailyExpenseBloc,
                                DailyExpenseState>(
                              bloc: dailyExpenseBloc,
                              buildWhen: (current, previous) =>
                                  previous is DailyExpenseTypeActionState,
                              builder: (context, state) {
                                if (state is DailyExpenseTypeActionState) {
                                  List<String> typeNames = state.expenseTypes
                                      .map((expenseType) =>
                                          expenseType.sTypeName)
                                      .toList();

                                  return DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Expense Type',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: typeNames
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: state.selectedItem ?? null,
                                          onChanged: (value) {
                                            dailyExpenseBloc.add(
                                                DailyExpenseTypeChangedActionEvent(
                                                    expenseTypes:
                                                        state.expenseTypes,
                                                    selectedItem: value!));

                                            ExpenseTypeID =
                                                typeNames.indexOf(value);

                                            ExpenseTypeID = ExpenseTypeID! + 1;
                                          },
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            width: 150,
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness:
                                                  MaterialStateProperty.all(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          )));
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: BlocBuilder<DailyExpenseDateBloc, DateState>(
                              builder: (context, state) {
                            dSaleDate = state.date;

                            return GestureDetector(
                              onTap: () async {
                                context.read<DailyExpenseDateBloc>().add(
                                    DateEventChange(
                                        date: await _selectDate(context)));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                height: 56,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: appborder)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.date,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Icon(Icons.calendar_today,
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: appborder),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              IsPressed = false;
                            },
                            child: Text('Cash'),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blueAccent),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .030,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 188, 189),
                            )),
                            width: MediaQuery.of(context).size.width * .40,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: BlocBuilder<Popbloc, Popstate>(
                                builder: (context, state) {
                                  if (state.customers == null) {}
                                  if (state.selectedBank != null) {
                                    iBankIDPAIDAmount = state
                                        .getBankIdByName(state.selectedBank!);
                                  }
                                  return (DropdownButton<String>(
                                    isExpanded: true,
                                    underline: SizedBox.shrink(),
                                    style: TextStyle(
                                      color: Color(0xFF91919F),
                                      fontFamily: 'Roboto',
                                    ),
                                    hint: Text('Select Bank',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontFamily: 'Roboto')),
                                    value: state.selectedBank ?? "Select Bank",
                                    onChanged: (String? newValue) async {
                                      if (newValue != null &&
                                          newValue.isNotEmpty) {
                                        int? bankId =
                                            state.getBankIdByName(newValue);
                                        if (bankId != null) {
                                          (state.copyWith(
                                              selectedBanks: newValue));
                                          context.read<Popbloc>().add(
                                              UpdateSelectedBanks(newValue));
                                        } else {
                                          context
                                              .read<Popbloc>()
                                              .add(ClearSelection());
                                        }
                                      }
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: "Select Bank",
                                        child: Text("Select Bank"),
                                      ),
                                      ...?state.banks
                                          ?.map<DropdownMenuItem<String>>(
                                              (Bank value) {
                                        return DropdownMenuItem<String>(
                                          value: value.name,
                                          child: Text(value.name),
                                        );
                                      }).toList(),
                                    ],
                                  ));
                                },
                              ),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .030,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: appborder),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Enter Description',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          alignLabelWithHint: true,
                          border: InputBorder.none,
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BlocConsumer<DailyExpenseBloc, DailyExpenseState>(
              bloc: dailyExpenseBloc,
              listener: (context, state) {
                if (state is DailyExpenseAddedState) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DailyExpenseAddedScreen()));
                }
              },
              listenWhen: (current, previous) =>
                  current is DailyExpenseActionState,
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    GetStorage _box = GetStorage();
                    if (ExpenseTypeID == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a Expense Type')),
                      );
                    } else if (_amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter amount')),
                      );
                    } else if (_descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter description')),
                      );
                    } else if (iBankIDPAIDAmount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a Bank')),
                      );
                    } else {
                      dailyExpenseBloc.add(AddDailyExpenseEvent(
                          dailyExpense: DailyExpense(
                        iExpenseTypeID: ExpenseTypeID,
                        iBankID: iBankIDPAIDAmount,
                        iTableID: 00,
                        dcAmount: _amountController.text.toString(),
                        sDescription: _descriptionController.text.toString(),
                        iFirmID: _box.read('iFirmID'),
                        iSystemUserID: _box.read('iSystemUserID'),
                        dDate: dSaleDate,
                        sSyncStatus: 0,
                        sEntrySource: "mobile",
                        dtCreatedDate: dtCreatedDate,
                      )));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: appBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: state is DailyExpenseLoadingState
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Add daily expense",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
