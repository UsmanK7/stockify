class ProductModel {
  final int id;
  final String product_name;
  final String unit;
  final double price;
  final int unitType;
  final int productIndex;
  final int bonusQty;
  final String sSaleStatus;
  final String sSaleType;
  final double Qty;
  final double disountNumber;
  final double discountPercentage;

  ProductModel(
      {required this.id,
      required this.product_name,
      required this.unit,
      required this.productIndex,
      required this.sSaleStatus,
      required this.sSaleType,
      required this.unitType,
      required this.price,
      required this.bonusQty,
      required this.Qty,
      required this.disountNumber,
      required this.discountPercentage});
  String toString() {
    return 'ProductModel{id: $id, product_name: $product_name,unitType: $unitType, unit: $unit, price: $price, bonusQty: $bonusQty, Qty: $Qty, disountNumber: $disountNumber, discountPercentage: $discountPercentage}';
  }
}
