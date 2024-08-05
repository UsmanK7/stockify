import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:okra_distributer/payment/Models/model.dart';

abstract class PopEvent extends Equatable {
  PopEvent();
  @override
  List<Object> get props => [];
}

class SelectCountries extends PopEvent {
  final String countryName;
  SelectCountries(this.countryName);
}

class SelectBanks extends PopEvent {
  final String bankName;
  SelectBanks(this.bankName);
}

class SelectStates extends PopEvent {
  final int countryId;
  SelectStates(this.countryId);

  @override
  List<Object> get props => [countryId];
}

class SelectCities extends PopEvent {
  final int stateId;

  SelectCities(this.stateId);

  @override
  List<Object> get props => [stateId];
}

class SelectAreas extends PopEvent {
  final int cityId;

  SelectAreas(
    this.cityId,
  );

  @override
  List<Object> get props => [cityId];
}

class SelectCustomer extends PopEvent {
  final int areaId;

  SelectCustomer(this.areaId);

  @override
  List<Object> get props => [areaId];
}

class UpdateSlectedCustomer extends PopEvent {
  final String customerName;
  UpdateSlectedCustomer(this.customerName);
  @override
  List<Object> get props => [customerName];
}

class UpdateSelectedBanks extends PopEvent {
  final String bankName;
  UpdateSelectedBanks(this.bankName);
  @override
  List<Object> get props => [bankName];
}

class UpdateSelectedCountry extends PopEvent {
  final String countryName;
  UpdateSelectedCountry(this.countryName);

  @override
  List<Object> get props => [countryName];
}

class UpdateSelectedState extends PopEvent {
  final String stateName;
  UpdateSelectedState(this.stateName);
  @override
  List<Object> get props => [stateName];
}

class UpdatedCityName extends PopEvent {
  final String cityName;
  UpdatedCityName(this.cityName);
  @override
  List<Object> get props => [cityName];
}

class UpdateSelectedArea extends PopEvent {
  final String areaName;
  UpdateSelectedArea(this.areaName);
  @override
  List<Object> get props => [areaName];
}

class SelectDate extends PopEvent {
  final DateTime date;
  SelectDate(this.date);
}

class InsertPayment extends PopEvent {
  final PermanentCustomerPayment payment;

  InsertPayment(
    this.payment,
  );

  @override
  List<Object> get props => [payment];
}

class ClearSelection extends PopEvent {}

class FilterPaymentsByDate extends PopEvent {
  final DateTime startDate;
  final DateTime endDate;

  FilterPaymentsByDate({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class LoadAllPayments extends PopEvent {}

class LoadAllCustomer extends PopEvent {}

class FetchCurrentTime extends PopEvent {}

class TaskStatusFailed extends PopEvent {}

class UpdateTaskStatus extends PopEvent {
  final int taskIndex;
  final String status;

  UpdateTaskStatus(this.taskIndex, this.status);
}

class UpdateDropdownValue extends PopEvent {
  final String newValue;

  UpdateDropdownValue(this.newValue);

  @override
  List<Object> get props => [newValue];
}

class FetchCustomerExpenses extends PopEvent {
  final int customerId;

  FetchCustomerExpenses(
    this.customerId,
  );
}
