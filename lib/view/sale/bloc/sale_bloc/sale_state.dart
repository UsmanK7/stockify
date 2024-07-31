abstract class SaleState {
  SaleState();
}

abstract class SaleActionState extends SaleState {
  SaleActionState();
}

class SaleInitialState extends SaleState {}

class SaleLoadingState extends SaleState {}

class SaleLoadedState extends SaleState {}

class SaleSuccessState extends SaleState {
  List<String> items;
  final selectedItem;
  SaleSuccessState({
    required this.items,
    required this.selectedItem,
  });
}

class ProductSelectedState extends SaleState {
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

class SaleUnitSelectedState extends SaleState {
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

class BonusQuantityChangeState extends SaleState {
  String newValue;
  BonusQuantityChangeState({required this.newValue});
}

class RefreshState extends SaleState {}

class FormAddingLoadingState extends SaleState {}

class FormAddedState extends SaleActionState {}

class FormErrorState extends SaleState {}
