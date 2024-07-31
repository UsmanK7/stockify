// import 'package:flutter/material.dart';
// import 'package:okra_distributer/components/text_component.dart';
// import 'package:okra_distributer/consts/const.dart';
// import 'package:okra_distributer/view/sale/bloc/sale_bloc.dart';
// import 'package:okra_distributer/view/sale/data/billed_items.dart';

// class SaleItemCard extends StatelessWidget {
//   final int index;
//   final String title;
//   final int saleQty;
//   final int bonusQty;
//   final String unit;
//   final double QtyPrice;
//   final double DiscountPercentage;
//   final double DiscountPrice;

//   SaleItemCard({
//     super.key,
//     required this.index,
//     required this.unit,
//     required this.title,
//     required this.saleQty,
//     required this.bonusQty,
//     required this.DiscountPercentage,
//     required this.DiscountPrice,
//     required this.QtyPrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double totalQtyPrice = saleQty * QtyPrice;
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         padding: EdgeInsets.only(top: 3),
//         width: TotalScreenWidth(context),
//         height: 106,
//         color: appsearchBoxColor,
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   AppText(
//                       title: "#${index}",
//                       color: Colors.black,
//                       font_size: 16.0,
//                       fontWeight: FontWeight.bold),
//                   GestureDetector(
//                     onTap: () {
//                       billedItems.removeAt(index);
//                     },
//                     child: Container(
//                       width: 55,
//                       height: 20,
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             AppText(
//                                 title: "Delete",
//                                 color: Colors.white,
//                                 font_size: 10,
//                                 fontWeight: FontWeight.bold),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Icon(size: 10, Icons.close),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         decoration: TextDecoration.underline,
//                         color: Colors.black,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     // AppText(
//                     //     title: "Next Cola 1.4 Ltr",
//                     //     color: Colors.black,
//                     //     font_size: 15,
//                     //     fontWeight: FontWeight.bold),
//                     // AppText(
//                     //     title: "Okrasoft",
//                     //     color: Color(0xff595252),
//                     //     font_size: 10,
//                     //     fontWeight: FontWeight.bold),
//                   ],
//                 ),
//                 AppText(
//                     title: "${saleQty} ${unit} + ${bonusQty} (Bonus)",
//                     color: Colors.black,
//                     font_size: 12,
//                     fontWeight: FontWeight.bold)
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               height: 12,
//                               width: 6,
//                               color: Color(0xff50E91A),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             AppText(
//                                 title: "Sale Qty",
//                                 color: Colors.black,
//                                 font_size: 10,
//                                 fontWeight: FontWeight.w800),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 6,
//                         ),
//                         AppText(
//                             title:
//                                 "${saleQty} QTY x ${QtyPrice} = + ${totalQtyPrice} Rs",
//                             color: Colors.black,
//                             font_size: 10,
//                             fontWeight: FontWeight.w800),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               height: 12,
//                               width: 6,
//                               color: Color(0xff7F3DFF),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             AppText(
//                                 title: "Bonus QTY",
//                                 color: Colors.black,
//                                 font_size: 10,
//                                 fontWeight: FontWeight.w800),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 6,
//                         ),
//                         AppText(
//                             title: "${bonusQty} Bonus x 0 = 0 Rs",
//                             color: Colors.black,
//                             font_size: 10,
//                             fontWeight: FontWeight.w800),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               height: 12,
//                               width: 6,
//                               color: Color(0xffE11B1B),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             AppText(
//                                 title: "Discount",
//                                 color: Colors.black,
//                                 font_size: 10,
//                                 fontWeight: FontWeight.w800),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 6,
//                         ),
//                         AppText(
//                             title: "2 % | 500 Rs = - 400 Rs",
//                             color: Colors.black,
//                             font_size: 10,
//                             fontWeight: FontWeight.w800),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   height: 48,
//                   width: 90,
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: 43,
//                         width: 100,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black)),
//                         child: Center(
//                           child: AppText(
//                               title: QtyPrice.toString(),
//                               color: Colors.black,
//                               font_size: 14,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 33, left: 14),
//                         width: 55,
//                         height: 15,
//                         color: appsearchBoxColor,
//                         child: Center(
//                           child: AppText(
//                               title: "Subtotal",
//                               color: appBlue,
//                               font_size: 13,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
