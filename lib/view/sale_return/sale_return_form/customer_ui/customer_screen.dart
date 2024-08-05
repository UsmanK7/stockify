import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:okra_distributer/bloc/popUpbloc/popBloc.dart';
import 'package:okra_distributer/bloc/popUpbloc/popEvent.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class CustomerOrderScreen extends StatefulWidget {
  final Database database;
  const CustomerOrderScreen({super.key, required this.database});
  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  DBHelper dbHelper = DBHelper();
  // Future<void> showDetailsDialog(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Enter Details'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Row(children: <Widget>[
  //               BlocBuilder<Popbloc, Popstate>(
  //                 builder: (context, state) {
  //                   if (state.countries == null) {
  //                     return CircularProgressIndicator();
  //                   }
  //                   return DropdownButton<String>(
  //                     hint: Text('Select Country',
  //                         style:
  //                             TextStyle(fontSize: 15.sp, fontFamily: 'Roboto')),
  //                     value: state.selectedCountry,
  //                     style: TextStyle(color: Colors.black),
  //                     onChanged: (String? newValue) {
  //                       try {
  //                         if (newValue != null && newValue.isNotEmpty) {
  //                           int? countryId = state.getCountryIdByName(newValue);
  //                           if (countryId != null) {
  //                             context
  //                                 .read<Popbloc>()
  //                                 .add(SelectStates(countryId));
  //                             context
  //                                 .read<Popbloc>()
  //                                 .add(UpdateSelectedCountry(newValue));
  //                           }
  //                         }
  //                       } catch (e) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(content: Text('Error: $e')),
  //                         );
  //                       }
  //                     },
  //                     items: state.countries
  //                         ?.map<DropdownMenuItem<String>>((Country value) {
  //                       return DropdownMenuItem<String>(
  //                         value: value.name,
  //                         child: Text(
  //                           value.name!.toString(),
  //                           style: TextStyle(color: Colors.black),
  //                         ),
  //                       );
  //                     }).toList(),
  //                   );
  //                 },
  //               ),
  //             ]),

  //             //For State
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.02,
  //             ),
  //             Row(
  //               children: <Widget>[
  //                 BlocBuilder<Popbloc, Popstate>(
  //                   builder: (context, state) {
  //                     if (state.states == null) {}
  //                     return DropdownButton<String>(
  //                       hint: Text('Select State',
  //                           style: TextStyle(
  //                               fontSize: 15.sp, fontFamily: 'Roboto')),
  //                       value: state.selectedState,

  //                       // value: state.selectedArea != null &&
  //                       //         state.areas?.any((Area area) =>
  //                       //                 area.name == state.selectedArea) ==
  //                       //             true
  //                       //     ? state.selectedArea
  //                       //     : null,
  //                       style: TextStyle(color: Colors.black),
  //                       onChanged: (String? newValue) {
  //                         if (newValue != null && newValue.isNotEmpty) {
  //                           int? stateId = state.getStateIdByName(newValue);
  //                           if (stateId != null) {
  //                             context
  //                                 .read<Popbloc>()
  //                                 .add(SelectCities(stateId));

  //                             context
  //                                 .read<Popbloc>()
  //                                 .add(UpdateSelectedState(newValue));
  //                           } else {
  //                             // Handle the case where the state ID is not found
  //                           }
  //                         }
  //                       },
  //                       items: state.states
  //                           ?.map<DropdownMenuItem<String>>((States value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value.name,
  //                           child: Text(value.name!),
  //                         );
  //                       }).toList(),
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),

  //             //For State
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.02,
  //             ),

  //             //For city
  //             SizedBox(height: 20),
  //             Row(
  //               children: <Widget>[
  //                 BlocBuilder<Popbloc, Popstate>(
  //                   builder: (context, state) {
  //                     if (state.cities == null) {}
  //                     return DropdownButton<String>(
  //                       hint: Text('Select City',
  //                           style: TextStyle(
  //                               fontSize: 15.sp, fontFamily: 'Roboto')),
  //                       value: state.selectedCity != null &&
  //                               state.cities?.any((City city) =>
  //                                       city.name == state.selectedCity) ==
  //                                   true
  //                           ? state.selectedCity
  //                           : null,

  //                       // value: state.selectedArea != null &&
  //                       //         state.areas?.any((Area area) =>
  //                       //                 area.name == state.selectedArea) ==
  //                       //             true
  //                       //     ? state.selectedArea
  //                       //     : null,

  //                       onChanged: (String? newValue) {
  //                         if (newValue != null && newValue.isNotEmpty) {
  //                           int? cityId = state.getCityIdByName(newValue);
  //                           if (cityId != null) {
  //                             context.read<Popbloc>().add(SelectAreas(cityId));
  //                             context
  //                                 .read<Popbloc>()
  //                                 .add(UpdatedCityName(newValue));
  //                           } else {
  //                             // Handle the case where the state ID is not found
  //                           }
  //                         }
  //                       },
  //                       items: state.cities
  //                           ?.map<DropdownMenuItem<String>>((City value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value.name,
  //                           child: Text(value.name!),
  //                         );
  //                       }).toList(),
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),

  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.02,
  //             ),

  //             //For area
  //             SizedBox(height: 20),
  //             Row(
  //               children: <Widget>[
  //                 BlocBuilder<Popbloc, Popstate>(
  //                   builder: (context, state) {
  //                     if (state.areas == null) {
  //                       // Handle the case where areas are null
  //                     }
  //                     return DropdownButton<String>(
  //                       hint: Text('Select Area',
  //                           style: TextStyle(
  //                               fontSize: 15.sp, fontFamily: 'Roboto')),
  //                       value: state.selectedArea != null &&
  //                               state.areas?.any((Area area) =>
  //                                       area.name == state.selectedArea) ==
  //                                   true
  //                           ? state.selectedArea
  //                           : null,
  //                       onChanged: (String? newValue) {
  //                         if (newValue != null && newValue.isNotEmpty) {
  //                           int? areaId = state.getAreaIdByName(newValue);
  //                           if (areaId != null) {
  //                             // Emit a new state with the updated selected area
  //                             context
  //                                 .read<Popbloc>()
  //                                 .add(UpdateSelectedArea(newValue));
  //                             context
  //                                 .read<Popbloc>()
  //                                 .add(SelectCustomer(areaId));
  //                           } else {
  //                             // Handle the case where the area ID is not found
  //                           }
  //                         }
  //                       },
  //                       items: state.areas
  //                           ?.map<DropdownMenuItem<String>>((Area value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value.name,
  //                           child: Text(value.name!),
  //                         );
  //                       }).toList(),
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),

  //             //Testing

  //             // For area
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 final popBloc = context.read<Popbloc>();
  //                 final selectedAreaId = popBloc.state.selectedAreaId;
  //                 if (selectedAreaId != null) {
  //                   popBloc.add(SelectCustomer(selectedAreaId));
  //                   Navigator.pop(context);
  //                 }
  //               },
  //               child: Text("Search")),
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text("Cancel")),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();

    //For Country
    context.read<Popbloc>().add(SelectCountries(''));
    context.read<Popbloc>().add(SelectBanks(''));

    print('SelectBanks event dispatched');
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
    //For Customer
    Future.delayed(Duration.zero, () {
      final currentState = context.read<Popbloc>().state;
      int? areaID = currentState.getAreaIdByName('');
      if (areaID != null) {
        context.read<Popbloc>().add(SelectCustomer(areaID));
      }
    });
  }

  String dropdownvalue = "Credit";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(10),
            //             bottomLeft: Radius.circular(10)),
            //         color: Colors.white),
            //     child: BlocBuilder<Popbloc, Popstate>(
            //       builder: (context, state) {
            //         if (state.selectedCustomer != null) {
            //           selectedCustomerId =
            //               state.getCustomerIdByName(state.selectedCustomer!);
            //         }
            //         customerselect = state.selectedCustomer;
            //         if (state.customers == null) {}
            //         return DropdownButton<String>(
            //           underline: SizedBox.shrink(),
            //           hint: Text('Select Customer',
            //               style:
            //                   TextStyle(fontSize: 15.sp, fontFamily: 'Roboto')),
            //           value: state.selectedCustomer,
            //           onChanged: (String? newValue) {
            //             if (newValue != null && newValue.isNotEmpty) {
            //               int? customerId = state.getCustomerIdByName(newValue);
            //               if (customerId != null) {
            //                 (state.copyWith(selectedCustomer: newValue));
            //                 context
            //                     .read<Popbloc>()
            //                     .add(UpdateSlectedCustomer(newValue));
            //                 context
            //                     .read<Popbloc>()
            //                     .add(SelectAreas(customerId));
            //               } else {}
            //             }
            //           },
            //           items: state.customers
            //               ?.map<DropdownMenuItem<String>>((Customer value) {
            //             return DropdownMenuItem<String>(
            //               value: value.name,
            //               child: Text(value.name),
            //             );
            //           }).toList(),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                // showDetailsDialog(context);
                // showDialougeBox();
                // print('Dialouge box was called ');
                // print('Container tapped');
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: appsearchBoxColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Image(
                            width: MediaQuery.of(context).size.width * .13,
                            image: AssetImage('assets/images/Search_ic.png')),
                        Text(
                          "Search",
                          style:
                              TextStyle(fontFamily: 'Roboto', fontSize: 17.sp),
                        )
                      ],
                    ),
                  )),
            )
          ]),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
