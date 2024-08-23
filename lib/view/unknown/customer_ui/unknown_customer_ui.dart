import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/view/sale_order/bloc/bloc_pop_sale_order/sale_pop_bloc.dart';
import 'package:okra_distributer/view/sale_order/bloc/bloc_pop_sale_order/sale_pop_event.dart';
import 'package:okra_distributer/view/sale_order/bloc/bloc_pop_sale_order/sale_pop_state.dart';
import 'package:okra_distributer/view/unknown/data/sale_order_billed_items.dart';

import 'package:sqflite/sqflite.dart';

class CustomerOrderScreen extends StatefulWidget {
  final Database? database;
  const CustomerOrderScreen({super.key, this.database});
  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  DBHelper dbHelper = DBHelper();
  TextEditingController textEditingController = TextEditingController();

  Future<void> showDetailsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  BlocBuilder<SaleOrderPopBloc, Popstate>(
                    builder: (context, state) {
                      if (state.selectedCustomer != null) {
                        selectedCustomerId =
                            state.getCustomerIdByName(state.selectedCustomer!);
                      }
                      if (state.customers == null || state.customers!.isEmpty) {
                        return Center(child: Text('No customers available'));
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
                            if (newValue != null && newValue.isNotEmpty) {
                              int? customerId =
                                  state.getCustomerIdByName(newValue);
                              selectedCustomerId = state
                                  .getCustomerIdByName(state.selectedCustomer!);
                              if (customerId != null) {
                                context
                                    .read<SaleOrderPopBloc>()
                                    .add(UpdateSlectedCustomer(newValue));
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
                            width: 235,
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
                  BlocBuilder<SaleOrderPopBloc, Popstate>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 500), () {
                            showDetailsDialog(context);
                          });
                          context
                              .read<SaleOrderPopBloc>()
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
                              width: MediaQuery.of(context).size.width * .060,
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

              //For State
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: <Widget>[
                  BlocBuilder<SaleOrderPopBloc, Popstate>(
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
                                  .read<SaleOrderPopBloc>()
                                  .add(SelectCities(stateId));

                              context
                                  .read<SaleOrderPopBloc>()
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
                  BlocBuilder<SaleOrderPopBloc, Popstate>(
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
                                  .read<SaleOrderPopBloc>()
                                  .add(SelectAreas(cityId));
                              context
                                  .read<SaleOrderPopBloc>()
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
                  BlocBuilder<SaleOrderPopBloc, Popstate>(
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
                                  .read<SaleOrderPopBloc>()
                                  .add(UpdateSelectedArea(newValue));
                              context
                                  .read<SaleOrderPopBloc>()
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
                  final popBloc = context.read<SaleOrderPopBloc>();
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
    context.read<SaleOrderPopBloc>().add(SelectCountries(''));
    context.read<SaleOrderPopBloc>().add(SelectBanks(''));
    Future.delayed(Duration.zero, () {
      context.read<SaleOrderPopBloc>().add(ClearSelection());
    });

    //for satte
    Future.delayed(Duration.zero, () {
      final currentState = context.read<SaleOrderPopBloc>().state;
      int? countryId = currentState.getCountryIdByName('');
      if (countryId != null) {
        context.read<SaleOrderPopBloc>().add(SelectStates(countryId));
      }
    });
    //For city
    Future.delayed(Duration.zero, () {
      final currentState = context.read<SaleOrderPopBloc>().state;
      int? stateId = currentState.getStateIdByName('');
      if (stateId != null) {
        context.read<SaleOrderPopBloc>().add(SelectCities(stateId));
      }
    });

    //For area
    Future.delayed(Duration.zero, () {
      final currentState = context.read<SaleOrderPopBloc>().state;
      int? cityId = currentState.getCityIdByName('');
      if (cityId != null) {
        context.read<SaleOrderPopBloc>().add(SelectAreas(cityId));
      }
    });

    Future.delayed(Duration(milliseconds: 500), () {
      context.read<SaleOrderPopBloc>().add(LoadAllCustomer());
    });
    //For Customer
  }

  String dropdownvalue = "Credit";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BlocBuilder<SaleOrderPopBloc, Popstate>(
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
                            int? customerId =
                                state.getCustomerIdByName(newValue);
                            selectedCustomerId = state
                                .getCustomerIdByName(state.selectedCustomer!);
                            if (customerId != null) {
                              context
                                  .read<SaleOrderPopBloc>()
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
                          width: 235,
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
              SizedBox(
                width: MediaQuery.of(context).size.width * .020,
              ),
              BlocBuilder<SaleOrderPopBloc, Popstate>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 500), () {
                        showDetailsDialog(context);
                      });
                      context.read<SaleOrderPopBloc>().add(ClearSelection());

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
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
