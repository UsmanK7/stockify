abstract class SaleReturnEvent {}

class SaleInitalEvent extends SaleReturnEvent {}

class SaleDropdownSelectEvent extends SaleReturnEvent {
  String selectedItem;
  List<String> products;
  SaleDropdownSelectEvent({required this.selectedItem, required this.products});
}

class SaleUnitSelectedEvent extends SaleReturnEvent {
  List<String> units;
  List<bool> unitBool;
  int product_index;
  List<int> units_number;
  String selectedUnit;
  SaleUnitSelectedEvent(
      {required this.selectedUnit,
      required this.units,
      required this.product_index,
      required this.unitBool,
      required this.units_number});
}

class BonusQuantityChangeEvent extends SaleReturnEvent {
  String newValue;
  BonusQuantityChangeEvent({required this.newValue});
}

class RefreshEvent extends SaleReturnEvent {}

class AddSaleInvoice extends SaleReturnEvent {
  int selectedCustomerId;
  // int iBankIDPAIDAmount;
  double dcTotalBill;
  // double dcPaidBillAmount;
  double dcGrandTotal;
  double dctotaldiscount;
  String sTotal_Item;
  String dSaleDate;
  int sSyncStatus = 0;
  String dtCreatedDate;

  AddSaleInvoice({
    required this.selectedCustomerId,
    // required this.iBankIDPAIDAmount,
    required this.dcTotalBill,
    // required this.dcPaidBillAmount,
    required this.dcGrandTotal,
    required this.dctotaldiscount,
    required this.sTotal_Item,
    required this.dSaleDate,
    required this.dtCreatedDate,
  });
}

class SaleAdddingLoadingEvent extends SaleReturnEvent {}

class FormErrorEvent extends SaleReturnEvent {}
