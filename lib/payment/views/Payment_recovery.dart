import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/bloc/popUpbloc/popBloc.dart';
import 'package:okra_distributer/bloc/popUpbloc/popEvent.dart';
import 'package:okra_distributer/bloc/popUpbloc/popState.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:okra_distributer/payment/views/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class PaymentRecovery extends StatefulWidget {
  const PaymentRecovery({
    super.key,
  });

  @override
  State<PaymentRecovery> createState() => _PaymentRecoveryState();
}

class _PaymentRecoveryState extends State<PaymentRecovery> {
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  final db = DBHelper();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<http.Response> sendPaymentToApi(
      PermanentCustomerPayment payment) async {
    final appID = await db.getAppId();
    final token = await _getToken();
    if (token == null) {
      print('Authorization token is missing');

      throw Exception('Authorization token is missing');
    }
    final url = Uri.parse(Constant.sendApi);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization_token': token,
      'app_id': appID.toString(),
    };

    final body = jsonEncode({
      'app_id': appID.toString(),
      'authorization_token': token,
      'iPermanentCustomerID': payment.iPermanentCustomerID,
      'iBankID': payment.iBankID,
      'dcPaidAmount': payment.dcPaidAmount,
      'sInvoiceNo': payment.sInvoiceNo,
      'sBank': payment.sBank,
      'sDescription': payment.sDescription,
      'dDate': payment.dDate!.toIso8601String(),
    });

    final response = await http.post(url, headers: headers, body: body);

    return response;
  }

  DBHelper dbHelper = DBHelper();
  final dateController = TextEditingController();
  final payController = TextEditingController();
  final refController = TextEditingController();
  final noteController = TextEditingController();
  final textEditingController = TextEditingController();
  final String location = 'enable Location';
  bool IsPressed = true;

  Future<void> _handleSaveLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location saved!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving location: $e')),
      );
    }
  }

//Pop Up DialougeBox
  Future<void> showDetailsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(children: <Widget>[
                BlocBuilder<Popbloc, Popstate>(
                  builder: (context, state) {
                    if (state.countries == null) {
                      return CircularProgressIndicator();
                    }

                    //For Country
                    return DropdownButton<String>(
                      hint: Text('Select Country',
                          style:
                              TextStyle(fontSize: 15.sp, fontFamily: 'Roboto')),
                      value: state.selectedCountry,
                      style: TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        try {
                          if (newValue != null && newValue.isNotEmpty) {
                            int? countryId = state.getCountryIdByName(newValue);
                            if (countryId != null) {
                              context
                                  .read<Popbloc>()
                                  .add(SelectStates(countryId));
                              context
                                  .read<Popbloc>()
                                  .add(UpdateSelectedCountry(newValue));
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      items: state.countries
                          ?.map<DropdownMenuItem<String>>((Country value) {
                        return DropdownMenuItem<String>(
                          value: value.sCountryName,
                          child: Text(
                            value.sCountryName!.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ]),

              //For State
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: <Widget>[
                  BlocBuilder<Popbloc, Popstate>(
                    builder: (context, state) {
                      if (state.states == null) {}
                      return DropdownButton<String>(
                        hint: Text('Select State',
                            style: TextStyle(
                                fontSize: 15.sp, fontFamily: 'Roboto')),
                        value: state.selectedState,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            int? stateId = state.getStateIdByName(newValue);
                            if (stateId != null) {
                              context
                                  .read<Popbloc>()
                                  .add(SelectCities(stateId));

                              context
                                  .read<Popbloc>()
                                  .add(UpdateSelectedState(newValue));
                            } else {
                              //If Id is Nor there
                            }
                          }
                        },
                        items: state.states
                            ?.map<DropdownMenuItem<String>>((States value) {
                          return DropdownMenuItem<String>(
                            value: value.stateName,
                            child: Text(value.stateName!),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              //For city
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  BlocBuilder<Popbloc, Popstate>(
                    builder: (context, state) {
                      if (state.cities == null) {}
                      return DropdownButton<String>(
                        hint: Text('Select City',
                            style: TextStyle(
                                fontSize: 15.sp, fontFamily: 'Roboto')),
                        value: state.selectedCity != null &&
                                state.cities?.any((City city) =>
                                        city.name == state.selectedCity) ==
                                    true
                            ? state.selectedCity
                            : null,
                        onChanged: (String? newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            int? cityId = state.getCityIdByName(newValue);
                            if (cityId != null) {
                              context.read<Popbloc>().add(SelectAreas(cityId));
                              context
                                  .read<Popbloc>()
                                  .add(UpdatedCityName(newValue));
                            } else {
                              //If id not there
                            }
                          }
                        },
                        items: state.cities
                            ?.map<DropdownMenuItem<String>>((City value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              //For area
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  BlocBuilder<Popbloc, Popstate>(
                    builder: (context, state) {
                      if (state.areas == null) {
                        // Handle nulll
                      }
                      return DropdownButton<String>(
                        hint: Text('Select Area',
                            style: TextStyle(
                                fontSize: 15.sp, fontFamily: 'Roboto')),
                        value: state.selectedArea != null &&
                                state.areas?.any((Area area) =>
                                        area.name == state.selectedArea) ==
                                    true
                            ? state.selectedArea
                            : null,
                        onChanged: (String? newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            int? areaId = state.getAreaIdByName(newValue);
                            if (areaId != null) {
                              context
                                  .read<Popbloc>()
                                  .add(UpdateSelectedArea(newValue));
                              context
                                  .read<Popbloc>()
                                  .add(SelectCustomer(areaId));
                            } else {}
                          }
                        },
                        items: state.areas
                            ?.map<DropdownMenuItem<String>>((Area value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),

              // For area
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  final popBloc = context.read<Popbloc>();
                  final selectedAreaId = popBloc.state.selectedAreaId;
                  if (selectedAreaId != null) {
                    popBloc.add(SelectCustomer(selectedAreaId));
                    Navigator.pop(context);
                  }
                },
                child: Text("Search")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //For Country
    context.read<Popbloc>().add(SelectCountries(''));
    context.read<Popbloc>().add(SelectBanks(''));
    Future.delayed(Duration.zero, () {
      context.read<Popbloc>().add(ClearSelection());
    });

    //for satte
    Future.delayed(Duration.zero, () {
      final currentState = context.read<Popbloc>().state;
      int? countryId = currentState.getCountryIdByName('');
      if (countryId != null) {
        context.read<Popbloc>().add(SelectStates(countryId));
      }
    });
    //For city
    Future.delayed(Duration.zero, () {
      final currentState = context.read<Popbloc>().state;
      int? stateId = currentState.getStateIdByName('');
      if (stateId != null) {
        context.read<Popbloc>().add(SelectCities(stateId));
      }
    });

    //For area
    Future.delayed(Duration.zero, () {
      final currentState = context.read<Popbloc>().state;
      int? cityId = currentState.getCityIdByName('');
      if (cityId != null) {
        context.read<Popbloc>().add(SelectAreas(cityId));
      }
    });

    Future.delayed(Duration(milliseconds: 500), () {
      context.read<Popbloc>().add(LoadAllCustomer());
    });
    //For Customer
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    print('rebuild');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Payment Recovery',
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .50,
                        child: GestureDetector(
                          onTap: () {},
                          child: TextField(
                            readOnly: true,
                            controller: dateController,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2070))
                                        .then((date) {
                                      if (date != null) {
                                        context
                                            .read<Popbloc>()
                                            .add(SelectDate(date));
                                        dateController.text =
                                            DateFormat.yMd().format(date);
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.calendar_month)),
                              hintText: 'Date',
                              hintStyle: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color(0xFF91919F),
                                  fontFamily: 'Roboto'),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .010,
                      ),
                      Icon(Icons.timer),
                      BlocBuilder<Popbloc, Popstate>(
                        builder: (context, state) {
                          if (state.currentTime != null) {
                            return Text(
                              state.currentTime!,
                              style: TextStyle(fontSize: 13.sp),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .009,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Color.fromARGB(255, 188, 188, 189),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * .90,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          //customer
                          child: Row(
                            children: [
                              BlocBuilder<Popbloc, Popstate>(
                                builder: (context, state) {
                                  print('State isLoading: ${state.isLoading}');
                                  print('State customers: ${state.customers}');

                                  if (state.customers == null ||
                                      state.customers!.isEmpty) {
                                    return Center(
                                        child: Text('No customers available'));
                                  }

                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: false,
                                      hint: Text(
                                        'Select Customer',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      value: state.selectedCustomer,
                                      onChanged: (String? newValue) {
                                        if (newValue != null &&
                                            newValue.isNotEmpty) {
                                          int? customerId = state
                                              .getCustomerIdByName(newValue);
                                          if (customerId != null) {
                                            context.read<Popbloc>().add(
                                                UpdateSlectedCustomer(
                                                    newValue));
                                          } else {
                                            print(
                                                'No customer ID found for selected name.');
                                          }
                                        }
                                      },
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: 'Select Customer',
                                          child: Text("Select Customer"),
                                        ),
                                        ...state.customers!
                                            .map<DropdownMenuItem<String>>(
                                          (Customer value) {
                                            return DropdownMenuItem<String>(
                                              value: value.name,
                                              child:
                                                  Text(value.name ?? 'No Name'),
                                            );
                                          },
                                        ).toList(),
                                      ],
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        height: 40,
                                        width: 235,
                                      ),
                                      dropdownStyleData:
                                          const DropdownStyleData(
                                        maxHeight: 200,
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: textEditingController,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: textEditingController,
                                            decoration: InputDecoration(
                                              isDense: false,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              hintText:
                                                  'Search for a customer...',
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return item.value
                                              .toString()
                                              .contains(searchValue);
                                        },
                                      ),
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          textEditingController.clear();
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .020,
                              ),
                              BlocBuilder<Popbloc, Popstate>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () {
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        showDetailsDialog(context);
                                      });
                                      context
                                          .read<Popbloc>()
                                          .add(ClearSelection());

                                      textEditingController.clear();
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 2),
                                        child: Image(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .060,
                                          image: const AssetImage(
                                              'assets/images/Search_ic.png'),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .030,
                  ),

                  // 2nd text feild for payments and Banks
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .90,
                        height: MediaQuery.of(context).size.height * .070,
                        child: TextField(
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          controller: payController,
                          decoration: const InputDecoration(
                            suffix: Text(
                              'Rs',
                              style: TextStyle(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: Colors
                              .white, // Background color to overlap with the text field border
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 12.sp, // Adjust font size as needed
                              color: Color(0xFF91919F),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .030,
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 163),
                      child: Text(
                        "Payment Methods",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 20.sp),
                      )),
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
                                print(
                                    'Dropdown state: ${state.selectedCustomer}, ${state.selectedBank}');

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
                                        context
                                            .read<Popbloc>()
                                            .add(UpdateSelectedBanks(newValue));
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

                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .90,
                        height: MediaQuery.of(context).size.height * .070,
                        child: TextField(
                          maxLines: 1,
                          controller: noteController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: Colors
                              .white, // Background color to overlap with the text field border
                          child: Text(
                            'Remarks',
                            style: TextStyle(
                              fontSize: 12.sp, // Adjust font size as needed
                              color: Color(0xFF91919F),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .030,
                  ),

                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .90,
                        height: MediaQuery.of(context).size.height * .070,
                        child: TextField(
                          maxLines: 1,
                          controller: refController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: Colors
                              .white, // Background color to overlap with the text field border
                          child: Text(
                            'Refernce',
                            style: TextStyle(
                              fontSize: 12.sp, // Adjust font size as needed
                              color: Color(0xFF91919F),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .030,
                  ),

                  //Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<Popbloc, Popstate>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              final appID = await db.getAppId();
                              // if (IsPressed == true) {
                              // final payment = PermanentCustomerPayment(iBankID: 1);
                              // } else {
                              //   PermanentCustomerPayment(
                              //       iBankID: state.selectedBankId);
                              // }
                              if (state.selectedCustomer != null &&
                                  state.selectedCustomerId != 0) {
                                final payment = PermanentCustomerPayment(
                                  iPermanentCustomerID:
                                      state.selectedCustomerId,
                                  iBankID: state.selectedBankId,
                                  dcPaidAmount:
                                      double.parse(payController.text),
                                  sInvoiceNo: refController.text,
                                  sBank: state.selectedBank,
                                  sDescription: noteController.text,
                                  dDate: DateTime.now(),
                                );

                                print('Payment object created: $payment');
                                context.read<Popbloc>().add(
                                      InsertPayment(
                                        payment,
                                      ),
                                    );

                                if (await isInternetAvailable()) {
                                  try {
                                    // Send data to API
                                    final response =
                                        await sendPaymentToApi(payment);
                                    if (response.statusCode == 200) {
                                      print('Payment sent to API successfully');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Payment sent to server and saved locally')),
                                      );
                                    } else {
                                      print(
                                          'Failed to send payment to API: ${response.body}');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to send payment to server')),
                                      );
                                    }
                                  } catch (e) {
                                    print('Error sending payment to API: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error occurred while sending payment to server')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'No internet connection. Payment saved locally')),
                                  );
                                }
                                _handleSaveLocation();
                                context.read<Popbloc>().add(ClearSelection());
                                noteController.clear();
                                refController.clear();
                                dateController.clear();
                                payController.clear();

                                print(
                                    '  The Current Customer is ${state.selectedCustomer}');

                                print('InsertPayment event dispatched');
                                await dbHelper
                                    .getAllPermanentCustomerPayments();
                              } else {
                                SnackBar(
                                    content: Text('No Customer is Selected'));
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    "Pay",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.sp),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.30,
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         // Navigator.push(
                      //         //     context,
                      //         //     MaterialPageRoute(
                      //         //         builder: (context) => Customerreciptlist()));

                      //         DBHelper dbHelper = DBHelper();
                      //         await dbHelper.printSalesmanLocations();
                      //         await dbHelper.checkTableExists();
                      //       },
                      //       style: ButtonStyle(
                      //         backgroundColor: WidgetStateProperty.all<Color>(
                      //           Colors.green,
                      //         ),
                      //         shape:
                      //             WidgetStateProperty.all<RoundedRectangleBorder>(
                      //                 RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.circular(15))),
                      //       ),
                      //       child: Text(
                      //         'Print',
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 20.sp,
                      //             fontFamily: 'Roboto'),
                      //       )),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.30,
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      //   child: ElevatedButton(
                      //       onPressed: _handleSaveLocation,
                      //       style: ButtonStyle(
                      //         backgroundColor: WidgetStateProperty.all<Color>(
                      //           Colors.green,
                      //         ),
                      //         shape:
                      //             WidgetStateProperty.all<RoundedRectangleBorder>(
                      //                 RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.circular(15))),
                      //       ),
                      //       child: Text(
                      //         'Save',
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 20.sp,
                      //             fontFamily: 'Roboto'),
                      //       )),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
