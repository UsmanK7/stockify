abstract class SaleEvent {}

class SaleInitalEvent extends SaleEvent {}

class SaleDropdownSelectEvent extends SaleEvent {
  String selectedItem;
  List<String> products;
  SaleDropdownSelectEvent({required this.selectedItem, required this.products});
}

class SaleUnitSelectedEvent extends SaleEvent {
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

class BonusQuantityChangeEvent extends SaleEvent {
  String newValue;
  BonusQuantityChangeEvent({required this.newValue});
}

class RefreshEvent extends SaleEvent {}

class AddSaleInvoice extends SaleEvent {
  int selectedCustomerId;
  int iBankIDPAIDAmount;
  double dcTotalBill;
  double dcPaidBillAmount;
  double dcGrandTotal;
  double dctotaldiscount;
  String sTotal_Item;
  String dSaleDate;
  int sSyncStatus = 0;
  String dtCreatedDate;

  AddSaleInvoice({
    required this.selectedCustomerId,
    required this.iBankIDPAIDAmount,
    required this.dcTotalBill,
    required this.dcPaidBillAmount,
    required this.dcGrandTotal,
    required this.dctotaldiscount,
    required this.sTotal_Item,
    required this.dSaleDate,
    required this.dtCreatedDate,
  });
}

class SaleAdddingLoadingEvent extends SaleEvent {}

class FormErrorEvent extends SaleEvent {}
