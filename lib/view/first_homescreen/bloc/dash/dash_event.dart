abstract class DashEvent {}

class InitialDashEvent extends DashEvent {}

class DashInitialEvent extends DashEvent {}

class DashThisWeekEvent extends DashEvent {}

class DashThisMonthEvent extends DashEvent {}

class DashLastMonthEvent extends DashEvent {}

class DashThisQuarterEvent extends DashEvent {}

class DashThisYearEvent extends DashEvent {}

class DashCustomDate extends DashEvent {
  String fastDay;
  String lastDay;
  DashCustomDate({required this.fastDay, required this.lastDay});
}
