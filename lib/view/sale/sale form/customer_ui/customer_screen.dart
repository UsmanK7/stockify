import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';

import 'package:okra_distributer/view/sale/bloc/date_picker_bloc/data_picker_bloc.dart';
import 'package:okra_distributer/view/sale/bloc/date_picker_bloc/data_picker_event.dart';
import 'package:okra_distributer/view/sale/bloc/date_picker_bloc/data_picker_state.dart';
import 'package:okra_distributer/view/sale/bloc_pop_sale/sale_pop_bloc.dart';
import 'package:okra_distributer/view/sale/bloc_pop_sale/sale_pop_event.dart';
import 'package:okra_distributer/view/sale/bloc_pop_sale/sale_pop_state.dart';

import 'package:okra_distributer/view/sale/data/billed_items.dart';
import 'package:sqflite/sqflite.dart';

class CustomerScreen extends StatefulWidget {
  final Database database;
  const CustomerScreen({super.key, required this.database});
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

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
  DBHelper dbHelper = DBHelper();
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
                BlocBuilder<SalePopBloc, Popstate>(
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
                                  .read<SalePopBloc>()
                                  .add(SelectStates(countryId));
                              context
                                  .read<SalePopBloc>()
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
                  BlocBuilder<SalePopBloc, Popstate>(
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
                                  .read<SalePopBloc>()
                                  .add(SelectCities(stateId));

                              context
                                  .read<SalePopBloc>()
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
                  BlocBuilder<SalePopBloc, Popstate>(
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
                              context
                                  .read<SalePopBloc>()
                                  .add(SelectAreas(cityId));
                              context
                                  .read<SalePopBloc>()
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
                  BlocBuilder<SalePopBloc, Popstate>(
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
                                  .read<SalePopBloc>()
                                  .add(UpdateSelectedArea(newValue));
                              context
                                  .read<SalePopBloc>()
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
                  final popBloc = context.read<SalePopBloc>();
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
    _dateController.text = formatDate(_selectedDate);
    //For Country
    context.read<SalePopBloc>().add(SelectCountries(''));
    context.read<SalePopBloc>().add(SelectBanks(''));
    Future.delayed(Duration.zero, () {
      context.read<SalePopBloc>().add(ClearSelection());
    });

    //for satte
    Future.delayed(Duration.zero, () {
      final currentState = context.read<SalePopBloc>().state;
      int? countryId = currentState.getCountryIdByName('');
      if (countryId != null) {
        context.read<SalePopBloc>().add(SelectStates(countryId));
      }
    });
    //For city
    Future.delayed(Duration.zero, () {
      final currentState = context.read<SalePopBloc>().state;
      int? stateId = currentState.getStateIdByName('');
      if (stateId != null) {
        context.read<SalePopBloc>().add(SelectCities(stateId));
      }
    });

    //For area
    Future.delayed(Duration.zero, () {
      final currentState = context.read<SalePopBloc>().state;
      int? cityId = currentState.getCityIdByName('');
      if (cityId != null) {
        context.read<SalePopBloc>().add(SelectAreas(cityId));
      }
    });

    Future.delayed(Duration(milliseconds: 500), () {
      context.read<SalePopBloc>().add(LoadAllCustomer());
    });
    //For Customer
  }

  String dropdownvalue = "Credit";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            BlocBuilder<SalePopBloc, Popstate>(
              builder: (context, state) {
                if (state.selectedCustomer != null) {
                  selectedCustomerId =
                      state.getCustomerIdByName(state.selectedCustomer!);
                }
                if (state.customers == null || state.customers!.isEmpty) {
                  return Center(child: Text('No customers available'));
                }

                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Customer',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      value: state.selectedCustomer,
                      onChanged: (String? newValue) {
                        if (newValue != null && newValue.isNotEmpty) {
                          int? customerId = state.getCustomerIdByName(newValue);
                          selectedCustomerId = state
                              .getCustomerIdByName(state.selectedCustomer!);
                          if (customerId != null) {
                            context
                                .read<SalePopBloc>()
                                .add(UpdateSlectedCustomer(newValue));
                          } else {
                            print('No customer ID found for selected name.');
                          }
                        }
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Select Customer',
                          child: Text("Select Customer"),
                        ),
                        ...state.customers!.map<DropdownMenuItem<String>>(
                          (Customer value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Text(value.name ?? 'No Name'),
                            );
                          },
                        ).toList(),
                      ],
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for a customer...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<SalePopBloc, Popstate>(
              builder: (context, state) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 500), () {
                        showDetailsDialog(context);
                      });
                      context.read<SalePopBloc>().add(ClearSelection());

                      textEditingController.clear();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        color: appsearchBoxColor,
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Row(
                            children: [
                              AppText(
                                  title: "Filter",
                                  color: Colors.black87,
                                  font_size: 15,
                                  fontWeight: FontWeight.w500),
                              SizedBox(
                                width: 10,
                              ),
                              Image(
                                width: MediaQuery.of(context).size.width * .060,
                                image: const AssetImage(
                                    'assets/images/Search_ic.png'),
                              ),
                            ],
                          )),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: appborder)),
                child: Padding(
                    padding: EdgeInsets.only(top: 4, right: 10, left: 10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Reference No", border: InputBorder.none),
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            // BlocBuilder<SaleBloc, SaleState>(builder: (context, state) {

            // }),
            BlocBuilder<DateBloc, DateState>(

                // buildWhen: (previous, current) =>
                //     previous.date != current.date,
                builder: (context, state) {
              dSaleDate = state.date;
              return Expanded(
                child: GestureDetector(
                  onTap: () async {
                    context
                        .read<DateBloc>()
                        .add(DateEventChange(date: await _selectDate(context)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 56,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: appborder)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.date,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .020,
        ),
      ],
    );
  }
}
