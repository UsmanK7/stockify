abstract class DashState {}

abstract class DashActionState extends DashState {}

class InitialState extends DashState {}

class DashSuccessState extends DashState {
  String firstDate;
  String lastDate;
  int totalOrder;
  double paidBillAmount;
  double totalSaleAmount;
  double totalDiscount;
  DashSuccessState(
      {required this.totalDiscount,
      required this.totalOrder,
      required this.firstDate,
      required this.paidBillAmount,
      required this.lastDate,
      required this.totalSaleAmount});
}
