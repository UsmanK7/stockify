import 'package:equatable/equatable.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();

  List<Object> get props => [];
}

class DateEventChange extends DateEvent {
  String date;
  DateEventChange({required this.date});
  List<Object> get props => [date];
}
