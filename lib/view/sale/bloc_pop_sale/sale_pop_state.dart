import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:okra_distributer/payment/Models/model.dart';

class Popstate extends Equatable {
  final List<Country>? countries;
  final double? maxValue;

  int? currentIndex;

  final List<States>? states;
  final List<City>? cities;
  final List<Map<String, dynamic>>? customerExpenses;
  final DateTimeRange? dateRange;
  final List<Area>? areas;
  final List<Customer>? customers;
  final List<Bank>? banks;
  final String? selectedBank;
  final DateTime? startDate;
  final List<double>? saleAmount;
  final List<double>? paidAmount;
  final bool isLoading;

  //   List<double> saleAmount = List.filled(12, 0.0);
  // List<double> paidAmount = List.filled(12, 0.0);

  final DateTime? endDate;
  final String? selectedCountry;
  final String? currentTime;
  final String? selectedState;
  final String? selectedCity;
  final String? selectedArea;
  final String? selectedCustomer;
  final DateTime? selectedDate;
  final String? paymentStatus;
  final int? selectedCustomerId;
  final int? selectedBankId;
  final List<PermanentCustomerPayment>? filteredPayments;
  final List<Customer>? filterCustomer;

  Popstate(
      {this.countries,
      this.saleAmount,
      this.filterCustomer,
      this.paidAmount,
      this.currentIndex = 1,
      this.states,
      this.maxValue,
      this.startDate,
      this.endDate,
      this.isLoading = false,
      this.cities,
      this.areas,
      this.customerExpenses,
      this.customers,
      this.dateRange,
      this.selectedDate,
      this.currentTime,
      this.selectedCountry,
      this.selectedArea,
      this.selectedCity,
      this.selectedState,
      this.selectedCustomer,
      this.selectedBank,
      this.banks,
      this.filteredPayments,
      this.selectedCustomerId,
      this.selectedBankId = 2,
      this.paymentStatus});

  int? getCountryIdByName(String countryName) {
    final country = countries?.firstWhere(
      (country) => country.sCountryName == countryName,
    );
    return country?.iCountryID;
  }

  int? getBankIdByName(String bankName) {
    final bank = banks?.firstWhere((bank) => bank.name == bankName);
    return bank?.id;
  }

  int? getStateIdByName(String stateName) {
    final state = states?.firstWhere(
      (state) => state.stateName == stateName,
      orElse: () => null!,
    );
    return state?.id;
  }

  int? get selectedCountryId => getCountryIdByName(selectedCountry ?? '');
  int? get selectedStateId => getStateIdByName(selectedState ?? '');
  int? get selectedCityId => getCityIdByName(selectedCity ?? '');
  int? get selectedAreaId => getAreaIdByName(selectedArea ?? '');

  int? getCustomerIdByName(String name) {
    try {
      return customers?.firstWhere((customer) => customer.name == name).id;
    } catch (e) {
      print('Customer not found for name: $name');
      return null;
    }
  }

  int? getCityIdByName(String cityName) {
    final city = cities?.firstWhere(
      (city) => city.name == cityName,
      // ignore: null_check_always_fails
      orElse: () => null!, // Handle not found case
    );
    return city?.id;
  }

  int? getAreaIdByName(String areaName) {
    final area = areas?.firstWhere(
      (area) => area.name == areaName,
      orElse: () => null!,
    );
    return area?.id;
  }

  Popstate copyWith(
      {List<Country>? countries,
      List<States>? states,
      final double? maxValue,
      List<City>? cities,
      final bool? isloading,
      final List<double>? saleAmount,
      final int? currentIndex,
      final List<double>? paidAmount,
      List<Area>? areas,
      bool? isLoading,
      List<PermanentCustomerPayment>? filteredPayments,
      List<Customer>? customers,
      final List<Bank>? banks,
      final DateTime? startDate,
      final DateTime? endDate,
      final List<Map<String, dynamic>>? customerExpenses,
      final String? selectedCountry,
      final String? selectedBanks,
      final String? selectedState,
      final String? selectedCity,
      final String? selectedArea,
      DateTimeRange? dateRange,
      final DateTime? selectedDate,
      final String? currentTime,
      final int? selectedBankId,
      final int? selectedCustomerId,
      String? paymentStatus,
      String? selectedCustomer}) {
    return Popstate(
        countries: countries ?? this.countries,
        states: states ?? this.states,
        cities: cities ?? this.cities,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        areas: areas ?? this.areas,
        isLoading: isLoading ?? this.isLoading,
        currentIndex: currentIndex ?? this.currentIndex,
        filterCustomer: filterCustomer ?? this.filterCustomer,
        saleAmount: saleAmount ?? this.saleAmount,
        paidAmount: paidAmount ?? this.paidAmount,
        customers: customers ?? this.customers,
        banks: banks ?? this.banks,
        maxValue: maxValue ?? this.maxValue,
        currentTime: currentTime ?? this.currentTime,
        dateRange: dateRange ?? this.dateRange,
        filteredPayments: filteredPayments ?? this.filteredPayments,
        selectedBank: selectedBanks ?? this.selectedBank,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        selectedState: selectedState ?? this.selectedState,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedArea: selectedArea ?? this.selectedArea,
        selectedCustomer: selectedCustomer ?? this.selectedCustomer,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
        selectedBankId: selectedBankId ?? this.selectedBankId,
        customerExpenses: customerExpenses ?? this.customerExpenses,
        selectedDate: selectedDate ?? this.selectedDate);
  }

  @override
  List<Object?> get props => [
        countries,
        states,
        startDate,
        cities,
        endDate,
        currentIndex,
        saleAmount,
        paidAmount,
        areas,
        maxValue,
        customers,
        filterCustomer,
        isLoading,
        banks,
        selectedBank,
        selectedCountry,
        customerExpenses,
        selectedArea,
        selectedCity,
        selectedState,
        currentTime,
        selectedCustomer,
        paymentStatus,
        selectedDate,
        selectedCustomerId,
        selectedBankId,
        filteredPayments
      ];
}
