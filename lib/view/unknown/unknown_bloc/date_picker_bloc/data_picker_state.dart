import 'package:equatable/equatable.dart';
import 'package:okra_distributer/consts/const.dart';

class DateState extends Equatable {
  final String date;

  DateState({String? date}) : date = date ?? formatDate(DateTime.now());

  DateState copyWith({String? date}) {
    return DateState(date: date ?? this.date);
  }

  @override
  List<Object> get props => [date];
}
