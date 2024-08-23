
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/view/unknown/unknown_bloc/unknown_event.dart';
import 'package:okra_distributer/view/unknown/unknown_bloc/unknown_state.dart';
import 'package:sqflite/sqflite.dart';

class SaleOrderPopBloc extends Bloc<PopEvent, Popstate> {
  final Database dbHelper;
  Timer? _timer;

  SaleOrderPopBloc(this.dbHelper) : super(Popstate()) {
    on<SelectCountries>(_mapCountry);
    on<SelectStates>(_mapState);
    on<SelectCities>(_mapCity);
    on<SelectAreas>(_mapArea);
    on<SelectBanks>(_mapBank);
    on<UpdateSelectedCountry>(_mapUpdateSelectedCountry);
    on<UpdateSelectedState>(_mapSelectedState);
    on<UpdatedCityName>(_mapSelectedCity);
    on<UpdateSelectedArea>(_mapSelectedArea);
    on<SelectCustomer>(_mapCustomer);
    on<UpdateSlectedCustomer>(_mapUpdateSelectedCustomer);
    on<UpdateSelectedBanks>(_mapUpdateSelectedBanks);
    on<InsertPayment>(_insertPayment);
    on<ClearSelection>(_clearSection);
    on<FetchCustomerExpenses>(_mapFetchCustomerExpenses);
    on<LoadAllCustomer>(_loadAllCustomer);

    on<LoadAllPayments>(_loadAllPayments);
    // on<UpdateDropdownValue>(_updateDropdownValue);
    on<SelectDate>(_mapSelectDate);
    on<FetchCurrentTime>(_mapFetchCurrentTime);
    on<FilterPaymentsByDate>(_filterPaymentsByDate);
    // on<UpdateSelectedDate>(_updateDate);

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      add(FetchCurrentTime());
    });
  }

  void _mapFetchCurrentTime(FetchCurrentTime event, Emitter<Popstate> emit) {
    final String formattedTime =
        DateFormat('hh:mm:ss a').format(DateTime.now());
    emit(state.copyWith(currentTime: formattedTime));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  //For Maping Country
  void _mapCountry(SelectCountries event, Emitter<Popstate> emit) async {
    emit(state.copyWith(countries: null));
    try {
      final db = await DBHelper();
      final countryModels = await db.getCountries();
      emit(state.copyWith(countries: countryModels));
    } catch (e) {
      emit(state.copyWith(countries: []));
    }
  }

  //For Mapping Banks
  void _mapBank(SelectBanks event, Emitter<Popstate> emit) async {
    print('_mapBank called');
    emit(state.copyWith(banks: null));
    try {
      final db = await DBHelper();
      final bankModels = await db.getBanks();
      print('Fetched banks: $bankModels');
      if (bankModels != null && bankModels.isNotEmpty) {
        print('Banks list is not empty');
        emit(state.copyWith(banks: bankModels));
      } else {
        print('Banks list is empty');
        emit(state.copyWith(banks: []));
      }
    } catch (e) {
      print('Error fetching banks: $e');
      emit(state.copyWith(banks: []));
    }
  }

  //For Mapping States of Country

  void _mapState(SelectStates event, Emitter<Popstate> emit) async {
    emit(state.copyWith(isLoading: true, states: null));

    try {
      List<States> states = await DBHelper().getStates(event.countryId);
      emit(state.copyWith(states: states, isLoading: false));
    } catch (e) {
      emit(state.copyWith(states: [], isLoading: false));
    }
  }

  //For Loading All Payments if Not Date Filter is Applied

  void _loadAllPayments(LoadAllPayments event, Emitter<Popstate> emit) async {
    final db = await DBHelper();
    final allPayments = await db.getPermanentCustomerPayments();
    emit(state.copyWith(filteredPayments: allPayments));
  }

  void _loadAllCustomer(LoadAllCustomer event, Emitter<Popstate> emit) async {
    final db = await DBHelper();
    final allCustomer = await db.getAllCustomers();
    emit(state.copyWith(customers: allCustomer));
  }

  //For Mapping Citites In States

  void _mapCity(SelectCities event, Emitter<Popstate> emit) async {
    emit(state.copyWith(cities: null, selectedArea: null));
    try {
      final db = await DBHelper();
      final cityModels = await db.getCities(event.stateId);
      emit(state.copyWith(cities: cityModels));
    } catch (e) {
      emit(state.copyWith(cities: []));
    }
  }

  //For Mapping Areas in Citites

  void _mapArea(SelectAreas event, Emitter<Popstate> emit) async {
    emit(state.copyWith(areas: null));
    try {
      final db = await DBHelper();
      final areaModels = await db.getAreas(event.cityId);
      emit(state.copyWith(areas: areaModels));
    } catch (e) {
      emit(state.copyWith(areas: []));
    }
  }

  void _mapCustomer(SelectCustomer event, Emitter<Popstate> emit) async {
    emit(state.copyWith(isLoading: true, customers: null));

    try {
      List<Customer> customers;
      if (event.areaId != null) {
        customers = await DBHelper().getCustomerByArea(event.areaId);
        print('Customers loaded by area: $customers');
      } else {
        customers = await DBHelper().getAllCustomers();
        print('All customers loaded: $customers');
      }

      emit(state.copyWith(customers: customers, isLoading: false));
    } catch (e) {
      print('Error loading customers: $e');

      emit(state.copyWith(customers: [], isLoading: false));
    }
  }

  // void _mapFetchCustomerExpenses(
  //     FetchCustomerExpenses event, Emitter<Popstate> emit) async {
  //   final db = DBHelper();
  //   final List<Map<String, dynamic>> data = await db.rawQuery('''
  //   SELECT
  //     strftime('%m', dtCreatedDate) as month,
  //     SUM(dcDefaultAmount) as defaultAmount,
  //     SUM(dcPreviousAmount) as previousAmount
  //   FROM permanent_customer
  //   WHERE iPermanentCustomerID =?
  //   GROUP BY strftime('%m', dtCreatedDate)
  //   ORDER BY month
  // ''', [event.customerId]);

  //   emit(state.copyWith(customerExpenses: data));
  // }
  //IF Country is Updated

  void _mapUpdateSelectedCountry(
      UpdateSelectedCountry event, Emitter<Popstate> emit) {
    emit(state.copyWith(selectedCountry: event.countryName));
  }

  // void _updateDate(UpdateSelectedDate event, Emitter<Popstate> emit) {
  //   emit(state.copyWith(selectedDate: event.updateDate));
  // }

  // IF Banks Is Updated

  void _mapUpdateSelectedBanks(
      UpdateSelectedBanks event, Emitter<Popstate> emit) {
    print('Updating selected bank to: ${event.bankName}');
    emit(state.copyWith(selectedBanks: event.bankName));
    print('Selected bank updated to: ${state.selectedBank}');
  }

  //IF The State is Updated

  void _mapSelectedState(UpdateSelectedState event, Emitter<Popstate> emit) {
    emit(state.copyWith(selectedState: event.stateName));
  }
  //IF City is Updated

  void _mapSelectedCity(UpdatedCityName event, Emitter<Popstate> emit) {
    emit(state.copyWith(selectedCity: event.cityName));
  }
  //iF Area is UpDated

  void _mapSelectedArea(UpdateSelectedArea event, Emitter<Popstate> emit) {
    emit(state.copyWith(selectedArea: event.areaName));
  }

  // IF Customer State uis Updated

  void _mapUpdateSelectedCustomer(
      UpdateSlectedCustomer event, Emitter<Popstate> emit) {
    emit(state.copyWith(
        selectedCustomer: event.customerName,
        selectedCustomerId: state.getCustomerIdByName(event.customerName)));
  }

  //For Date

  void _mapSelectDate(SelectDate event, Emitter<Popstate> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  //To For Clearing the DropDown  and to initital value

  void _clearSection(ClearSelection event, Emitter<Popstate> emit) {
    Popstate newState = state.copyWith(
      selectedCustomerId: 0,
      selectedCustomer: 'Select Customer',
      selectedBankId: null,
      selectedBanks: 'CounterCash',
    );
    emit(newState);
    print(
        'State after clearing: ${newState.selectedCustomer}, ${newState.selectedBank}');
  }

  //For Inserting Payments

  void _insertPayment(InsertPayment event, Emitter<Popstate> emit) async {
    final payment = event.payment;
    final db = await DBHelper();
    int? iPermanentCustomerID = state.selectedCustomerId;
    print('Inserting payment for customer ID: $iPermanentCustomerID');
    if (iPermanentCustomerID != null) {
      print('Customer ID is not null, inserting payment...');
      await db.insertPermanentCustomerPayment(PermanentCustomerPayment(
        iPermanentCustomerPaymentsID: null,
        iPermanentCustomerID: iPermanentCustomerID,
        dcPaidAmount: payment.dcPaidAmount,
        sBank: payment.sBank,
        iBankID: payment.iBankID,
        sInvoiceNo: payment.sInvoiceNo,
        sDescription: payment.sDescription,
        dDate: payment.dDate,
      ));
      print('Payment inserted successfully!');
    } else {
      print('No customer selected');
    }
  }

  void _mapFetchCustomerExpenses(
      FetchCustomerExpenses event, Emitter<Popstate> emit) async {
    final db = await DBHelper();

    try {
      List<Map<String, dynamic>> saleData =
          await db.fetchSaleDataByCustomerId(event.customerId);

      List<Map<String, dynamic>> paymentData =
          await DBHelper().fetchPaymentDataByCustomerId(event.customerId);
      late double maxYValue;
      List<double> paid = List.filled(12, 0.0);
      List<double> sale = List.filled(12, 0.0);

      for (var item in saleData) {
        String? saleDateStr = item['dSaleDate'];
        if (saleDateStr != null) {
          try {
            List<String> parts = saleDateStr.split('-');
            int year = int.parse(parts[0]);
            int month = int.parse(parts[1]);
            int monthIndex = month - 1;
            sale[monthIndex] += item['dcTotalBill']?.toDouble() ?? 0.0;
          } catch (e) {
            print("Error parsing sale date: $e");
          }
        }
      }

      for (var item in paymentData) {
        String? paymentDateStr = item['dDate'];
        if (paymentDateStr != null) {
          try {
            List<String> parts = paymentDateStr.split('-');
            int year = int.parse(parts[0]);
            int month = int.parse(parts[1]);
            int monthIndex = month - 1;
            paid[monthIndex] += item['dcPaidAmount']?.toDouble() ?? 0.0;
          } catch (e) {
            print("Error parsing payment date: $e");
          }
        }
      }

      double maxPrevious =
          paid.reduce((curr, next) => curr > next ? curr : next);
      double maxDefault =
          sale.reduce((curr, next) => curr > next ? curr : next);
      maxYValue = (maxPrevious > maxDefault ? maxPrevious : maxDefault) * 1.2;

      // setState(() {
      //   paidAmount = paid;
      //   saleAmount = sale;
      //   isLoading = false;
      // });

      emit(state.copyWith(
        paidAmount: paid,
        saleAmount: sale,
        isloading: false,
        maxValue: maxYValue,
      ));
    } catch (e) {
      print("Error fetching or processing data: $e");
    }
  }

  void _filterPaymentsByDate(
      FilterPaymentsByDate event, Emitter<Popstate> emit) async {
    final db = await DBHelper();
    final allPayments = await db.getPermanentCustomerPayments();
    final filteredPayments = allPayments.where((payment) {
      return payment.dDate!
              .isAfter(event.startDate.subtract(Duration(days: 1))) &&
          payment.dDate!.isBefore(event.endDate
              .add(Duration(days: 1))
              .add(Duration(hours: 23, minutes: 59, seconds: 59)));
    }).toList();
    emit(state.copyWith(
      filteredPayments: filteredPayments,
      startDate: event.startDate,
      endDate: event.endDate,
    ));
  }
//   void _updateDropdownValue(
//   UpdateDropdownValue event,
//   Emitter<Popstate> emit,
// ) {
//   emit(state.copyWith(selectedDropdownValue: event.newValue));
// }
}
