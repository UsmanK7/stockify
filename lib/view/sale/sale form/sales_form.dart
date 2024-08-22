import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:okra_distributer/components/btn.dart';

import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';

import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_bloc.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_event.dart';
import 'package:okra_distributer/view/sale/bloc/sale_bloc/sale_state.dart';
import 'package:okra_distributer/view/sale/bloc_pop_sale/sale_pop_bloc.dart';
import 'package:okra_distributer/view/sale/bloc_pop_sale/sale_pop_event.dart';
import 'package:okra_distributer/view/sale/bloc_pop_sale/sale_pop_state.dart';
import 'package:okra_distributer/view/sale/data/billed_items.dart';

import 'package:okra_distributer/view/sale/sale%20form/Items_screen.dart';

import 'package:okra_distributer/view/sale/sale%20form/customer_ui/customer_screen.dart';
import 'package:okra_distributer/view/sale/sale%20form/sale_added_screen.dart';
import 'package:sqflite/sqflite.dart';

class SalesForm extends StatefulWidget {
  final Database database;
  const SalesForm({super.key, required this.database});

  @override
  State<SalesForm> createState() => _SalesFormState();
}

class _SalesFormState extends State<SalesForm> {
  int currentStep = 0;
  TextEditingController noteController = TextEditingController();
  TextEditingController paidBillController = TextEditingController();
  SaleBloc saleBloc = SaleBloc();
  @override
  void initState() {
    super.initState();
  }

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
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

  Widget controlsBuilder(context, details) {
    return Row(
      children: [
        AppBtn(
          width: 120,
          height: 40,
          onTap: details.onStepCancel,
          color: currentStep == 0 ? appsearchBoxColor : appBlue,
          title: "Back",
        ),
        SizedBox(
          width: 10,
        ),
        AppBtn(
          onTap: details.onStepContinue,
          width: 120,
          height: 40,
          color: currentStep == 2 ? appsearchBoxColor : appBlue,
          title: "Next",
        ),
      ],
    );
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
          title: "Sales Form",
          font_size: 18.0,
          fontWeight: FontWeight.w300,
        ),
        centerTitle: true,
      ),
      body: Stepper(
          currentStep: currentStep,
          type: StepperType.horizontal,
          onStepContinue: continueStep,
          onStepCancel: cancelStep,
          onStepTapped: onStepTapped,
          controlsBuilder: controlsBuilder,
          steps: [
            Step(
              title: Text("Customer"),
              isActive: currentStep >= 0,
              state: currentStep >= 0 ? StepState.complete : StepState.disabled,
              content: CustomerScreen(
                database: widget.database,
              ),
            ),
            Step(
                title: Text("Items"),
                isActive: currentStep >= 1,
                state:
                    currentStep >= 1 ? StepState.complete : StepState.disabled,
                content: ItemsScreen()),
            Step(
                title: Text("Payment"),
                isActive: currentStep >= 2,
                state:
                    currentStep >= 2 ? StepState.complete : StepState.disabled,
                content: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4)),
                                color: Colors.white),
                            child: TextField(
                              controller: paidBillController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Add Payment',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color(0xFF91919F),
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: appsearchBoxColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              BlocBuilder<SalePopBloc, Popstate>(
                                  builder: (context, state) {
                                if (state.selectedBank != null) {
                                  iBankIDPAIDAmount = state
                                      .getBankIdByName(state.selectedBank!);
                                  print(iBankIDPAIDAmount);
                                }
                                if (state.banks == null) {}
                                return DropdownButton<String>(
                                  underline: SizedBox.shrink(),
                                  hint: Text(
                                    'Credit',
                                    style: TextStyle(
                                        fontSize: 18.sp, fontFamily: 'Roboto'),
                                  ),
                                  value: state.selectedBank,
                                  style: TextStyle(color: Colors.black),
                                  onChanged: (String? newValue) {
                                    try {
                                      if (newValue != null &&
                                          newValue.isNotEmpty) {
                                        int? bankID =
                                            state.getBankIdByName(newValue);
                                        if (bankID != null) {
                                          context
                                              .read<SalePopBloc>()
                                              .add(SelectBanks(newValue));
                                          context.read<SalePopBloc>().add(
                                              UpdateSelectedBanks(newValue));
                                        }
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  },
                                  items: state.banks
                                      ?.map<DropdownMenuItem<String>>(
                                          (Bank value) {
                                    return DropdownMenuItem<String>(
                                      value: value.name,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        AppText(
                            title: "Note",
                            color: Colors.black,
                            font_size: 20,
                            fontWeight: FontWeight.w300)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .50,
                          child: TextField(
                            controller: noteController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                fillColor: Colors.white,
                                filled: true),
                            maxLines: 4,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)),
                            child: Center(
                              child: Image(
                                image: AssetImage("assets/images/image.png"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocConsumer(
                        listener: (context, state) {
                          if (state is FormAddedState) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaleAddedScreen(
                                          database: widget.database,
                                        )));
                          }
                        },
                        listenWhen: (previous, current) =>
                            current is SaleActionState,
                        buildWhen: (previous, current) => current is SaleState,
                        bloc: saleBloc,
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              if (selectedCustomerId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please select a customer')),
                                );
                              } else if (billedItems.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please add atleast one item')),
                                );
                              } else if (paidBillController.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please add payment')),
                                );
                              } else {
                                saleBloc.add(SaleAdddingLoadingEvent());
                                // // Print statements for all variables
                                // print('billedItems: $billedItems');
                                dcPaidBillAmount =
                                    double.parse(paidBillController.text);

                                // // Print statements for all variables
                                // billedItems.forEach((item) {
                                //   print(item);
                                // });

                                // saleBloc.add(AddSaleInvoice());

                                String returning_value =
                                    await _handleSaveLocation();
                                if (returning_value == "error") {
                                  saleBloc.add(FormErrorEvent());
                                  return;
                                }

                                DBHelper().printSalesmanLocations();
                                saleBloc.add(AddSaleInvoice(
                                    selectedCustomerId: selectedCustomerId!,
                                    iBankIDPAIDAmount: iBankIDPAIDAmount!,
                                    dcTotalBill: dcTotalBill!,
                                    dcPaidBillAmount: dcPaidBillAmount!,
                                    dcGrandTotal: dcGrandTotal,
                                    dctotaldiscount: dctotaldiscount!,
                                    sTotal_Item: sTotal_Item!,
                                    dSaleDate: dSaleDate!,
                                    dtCreatedDate: dtCreatedDate));
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                color: appBlue,
                                borderRadius: BorderRadius.circular(4),
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
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          ]),
    );
  }
}
