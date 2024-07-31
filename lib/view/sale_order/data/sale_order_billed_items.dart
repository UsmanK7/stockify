import 'package:okra_distributer/view/sale/model/product_model.dart';

List<ProductModel> SaleOrderbilledItems = [];
//sale form

int? selectedCustomerId;
int? iBankIDPAIDAmount;
double? dcTotalBill;
double? dcPaidBillAmount;
double dcGrandTotal = dcTotalBill! - dcPaidBillAmount!;

double? dctotaldiscount;
String? sTotal_Item;
String? dSaleDate;
int sSyncStatus = 0;
DateTime now = DateTime.now();
String dtCreatedDate = "${dSaleDate} ${now.hour}:${now.minute}:${now.second}";
var customerselect;
