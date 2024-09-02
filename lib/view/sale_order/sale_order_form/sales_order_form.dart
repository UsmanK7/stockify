import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/view/sale/bloc/date_picker_bloc/data_picker_bloc.dart';
import 'package:okra_distributer/view/sale/bloc/date_picker_bloc/data_picker_event.dart';
import 'package:okra_distributer/view/sale/bloc/date_picker_bloc/data_picker_state.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_bloc.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_state.dart';
import 'package:okra_distributer/view/sale_order/bloc/sale_order_bloc/sale_order_event.dart';
import 'package:okra_distributer/view/sale_order/data/sale_order_billed_items.dart';
import 'package:okra_distributer/view/sale_order/sale_order_form/Items_order_screen.dart';
import 'package:okra_distributer/view/sale_order/sale_order_form/customer_ui/customer_screen.dart';
import 'package:okra_distributer/view/sale_order/sale_order_form/printer.dart';
import 'package:okra_distributer/view/sale_order/sale_order_form/sale_order_added_screen.dart';
import 'package:sqflite/sqflite.dart';

class SalesOrderForm extends StatefulWidget {
  final Database database;
  const SalesOrderForm({super.key, required this.database});

  @override
  State<SalesOrderForm> createState() => _SalesOrderFormState();
}

class _SalesOrderFormState extends State<SalesOrderForm> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2070),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _dateController.text = formatDate(_selectedDate);
    }
    return formatDate(_selectedDate);
  }

  DateBloc dateBloc = DateBloc();
  TextEditingController noteController = TextEditingController();
  TextEditingController paidBillController = TextEditingController();
  SaleOrderBloc saleOrderBloc = SaleOrderBloc();
  @override
  void initState() {
    _dateController.text = formatDate(_selectedDate);
    super.initState();
  }

  Future<String> _handleSaveLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );

      return "error";
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return "error";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return "error";
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      SalesmanLocation location = SalesmanLocation(
        iTableID: 1,
        sTableName: 'example_table',
        sLongitude: position.longitude.toString(),
        sLatitude: position.latitude.toString(),
        sLocation:
            '${place.locality}, ${place.country} , ${place.subLocality},${place.street}',
        sDateTime: DateTime.now().toString(),
      );
      await DBHelper().insertSalesmanLocation(location);
      await DBHelper().printSalesmanLocations();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Location saved!')),
      // );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving location: $e')),
      );
    }
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appBlue,
        title: AppText(
          color: Colors.white,
          title: "Sales Order Form",
          font_size: 18.0,
          fontWeight: FontWeight.w300,
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.calendar_month),
          BlocBuilder<DateBloc, DateState>(builder: (context, state) {
            dSaleDate = state.date;
            return TextButton(
              onPressed: () async {
                context
                    .read<DateBloc>()
                    .add(DateEventChange(date: await _selectDate(context)));
              },
              child: Text(
                state.date,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            );
          }),
          SizedBox(
            height: MediaQuery.of(context).size.height * .020,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              CustomerOrderScreen(
                database: widget.database,
              ),
              ItemOrdersScreen(),
              Column(
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         padding:
                  //             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(10),
                  //                 bottomLeft: Radius.circular(10)),
                  //             color: Colors.white),
                  //         child: TextField(
                  //           controller: paidBillController,
                  //           keyboardType: TextInputType.number,
                  //           decoration: InputDecoration(
                  //             hintText: 'Add Payment',
                  //             border: InputBorder.none,
                  //             hintStyle: TextStyle(
                  //                 fontSize: 15.sp,
                  //                 color: Color(0xFF91919F),
                  //                 fontFamily: 'Roboto'),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //       decoration: BoxDecoration(
                  //           color: appsearchBoxColor,
                  //           borderRadius: BorderRadius.only(
                  //               topRight: Radius.circular(15),
                  //               bottomRight: Radius.circular(15))),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: <Widget>[
                  //           BlocBuilder<Popbloc, Popstate>(
                  //               builder: (context, state) {
                  //             if (state.selectedBank != null) {
                  //               iBankIDPAIDAmount =
                  //                   state.getBankIdByName(state.selectedBank!);
                  //               print(iBankIDPAIDAmount);
                  //             }
                  //             if (state.banks == null) {}
                  //             return DropdownButton<String>(
                  //               underline: SizedBox.shrink(),
                  //               hint: Text(
                  //                 'Credit',
                  //                 style: TextStyle(
                  //                     fontSize: 18.sp, fontFamily: 'Roboto'),
                  //               ),
                  //               value: state.selectedBank,
                  //               style: TextStyle(color: Colors.black),
                  //               onChanged: (String? newValue) {
                  //                 try {
                  //                   if (newValue != null && newValue.isNotEmpty) {
                  //                     int? bankID = state.getBankIdByName(newValue);
                  //                     if (bankID != null) {
                  //                       context
                  //                           .read<Popbloc>()
                  //                           .add(SelectBanks(newValue));
                  //                       context
                  //                           .read<Popbloc>()
                  //                           .add(UpdateSelectedBanks(newValue));
                  //                     }
                  //                   }
                  //                 } catch (e) {
                  //                   ScaffoldMessenger.of(context).showSnackBar(
                  //                     SnackBar(content: Text('Error: $e')),
                  //                   );
                  //                 }
                  //               },
                  //               items: state.banks
                  //                   ?.map<DropdownMenuItem<String>>((Bank value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value.name,
                  //                   child: Text(value.name),
                  //                 );
                  //               }).toList(),
                  //             );
                  //           }),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   children: [
                  //     AppText(
                  //         title: "Note",
                  //         color: Colors.black,
                  //         font_size: 20,
                  //         fontWeight: FontWeight.w300)
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: MediaQuery.of(context).size.width * .60,
                  //       child: TextField(
                  //         controller: noteController,
                  //         decoration: InputDecoration(
                  //             border:
                  //                 OutlineInputBorder(borderSide: BorderSide.none),
                  //             fillColor: Colors.white,
                  //             filled: true),
                  //         maxLines: 4,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         height: 106,
                  //         decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.black)),
                  //         child: Center(
                  //           child: Image(
                  //             image: AssetImage("assets/images/image.png"),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: BlocConsumer(
                            listener: (context, state) {
                              // if (state is FormAddedState) {
                              //   Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               SaleOrderAddedScreen(
                              //                 database: widget.database,
                              //               )));
                              // }
                            },
                            listenWhen: (previous, current) =>
                                current is SaleOrderActionState,
                            buildWhen: (previous, current) =>
                                current is SaleOrderState,
                            bloc: saleOrderBloc,
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () async {
                                  if (selectedCustomerId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Please select a customer')),
                                    );
                                  } else {
                                    saleOrderBloc
                                        .add(SaleAdddingLoadingEvent());

                                    // Print statements for all variables
                                    // SaleOrderbilledItems.forEach((item) {
                                    //   print(item);
                                    // });
                                    // print(selectedCustomerId);

                                    dcGrandTotal =
                                        dcTotalBill! - dctotaldiscount!;

                                    // String returning_value =
                                    //     await _handleSaveLocation();
                                    // if (returning_value == "error") {
                                    //   saleOrderBloc.add(FormErrorEvent());
                                    //   return;
                                    // }

                                    // DBHelper().printSalesmanLocations();

                                    saleOrderBloc.add(AddSaleInvoice(
                                        selectedCustomerId: selectedCustomerId!,
                                        // iBankIDPAIDAmount: iBankIDPAIDAmount!,
                                        dcTotalBill: dcTotalBill!,
                                        // dcPaidBillAmount: dcPaidBillAmount!,
                                        dcGrandTotal: dcGrandTotal,
                                        dctotaldiscount: dctotaldiscount!,
                                        sTotal_Item: sTotal_Item!,
                                        dSaleDate: dSaleDate!,
                                        dtCreatedDate: dtCreatedDate));

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SaleOrderAddedScreen(
                                                  database: widget.database,
                                                )));
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: appBlue,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                      child: state is FormAddingLoadingState
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : Text(
                                              "Save invoice",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: BlocConsumer(
                            listener: (context, state) {
                              // if (state is FormAddedPrintState) {
                              //   Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               SaleOrderAddedScreen(
                              //                 database: widget.database,
                              //               )));
                              // }
                            },
                            // listenWhen: (previous, current) =>
                            //     current is SaleOrderActionState,
                            buildWhen: (previous, current) =>
                                current is SaleOrderState,
                            bloc: saleOrderBloc,
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () async {
                                  if (selectedCustomerId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Please select a customer')),
                                    );
                                  } else {
                                    saleOrderBloc
                                        .add(SaleAdddingLoadingPrintEvent());

                                    // Print statements for all variables
                                    // SaleOrderbilledItems.forEach((item) {
                                    //   print(item);
                                    // });
                                    // print(selectedCustomerId);

                                    dcGrandTotal =
                                        dcTotalBill! - dctotaldiscount!;

                                    // String returning_value =
                                    //     await _handleSaveLocation();
                                    // if (returning_value == "error") {
                                    //   saleOrderBloc.add(FormErrorEvent());
                                    //   return;
                                    // }

                                    // DBHelper().printSalesmanLocations();

                                    saleOrderBloc.add(AddSaleInvoice(
                                        selectedCustomerId: selectedCustomerId!,
                                        // iBankIDPAIDAmount: iBankIDPAIDAmount!,
                                        dcTotalBill: dcTotalBill!,
                                        // dcPaidBillAmount: dcPaidBillAmount!,
                                        dcGrandTotal: dcGrandTotal,
                                        dctotaldiscount: dctotaldiscount!,
                                        sTotal_Item: sTotal_Item!,
                                        dSaleDate: dSaleDate!,
                                        dtCreatedDate: dtCreatedDate));

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ThermalPrintScreen()));
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: appBlue,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                      child: state
                                              is FormAddingLoadingPrintState
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : Text(
                                              "Save & Print",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                ),
                              );
                            }),
                      ),
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   ThermalPrintScreen()));
                      //     },
                      //     child: Container(
                      //       height: 50,
                      //       decoration: BoxDecoration(
                      //         color: appBlue,
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //       child: Center(
                      //           child: Text(
                      //         "Save & Print",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w600),
                      //       )),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
