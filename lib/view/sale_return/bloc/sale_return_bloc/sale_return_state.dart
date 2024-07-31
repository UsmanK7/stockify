abstract class SaleReturnState {
  SaleReturnState();
}

abstract class SaleReturnActionState extends SaleReturnState {
  SaleReturnActionState();
}

class SaleInitialState extends SaleReturnState {}

class SaleLoadingState extends SaleReturnState {}

class SaleLoadedState extends SaleReturnState {}

class SaleSuccessState extends SaleReturnState {
  List<String> items;
  final selectedItem;
  SaleSuccessState({
    required this.items,
    required this.selectedItem,
  });
}

class ProductSelectedState extends SaleReturnState {
  List<String> units;
  List<int> units_number;
  int product_index;
  List<bool> unitBool;
  final selectedUnit;
  ProductSelectedState({
    required this.units,
    required this.product_index,
    required this.unitBool,
    required this.units_number,
    required this.selectedUnit,
  });
}

class SaleUnitSelectedState extends SaleReturnState {
  double price;
  String sSaleStatus;
  String sSaleType;
  double total_price;
  int unit_type;
  String StockQTY;
  SaleUnitSelectedState(
      {required this.price,
      required this.unit_type,
      required this.sSaleStatus,
      required this.sSaleType,
      required this.StockQTY,
      required this.total_price});
}

class BonusQuantityChangeState extends SaleReturnState {
  String newValue;
  BonusQuantityChangeState({required this.newValue});
}

class RefreshState extends SaleReturnState {}

class FormAddingLoadingState extends SaleReturnState {}

class FormAddedState extends SaleReturnActionState {}

class FormErrorState extends SaleReturnState {}
