// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class ThermalPrintScreen extends StatefulWidget {
//   const ThermalPrintScreen({super.key});

//   @override
//   State<ThermalPrintScreen> createState() => _ThermalPrintScreenState();
// }

// class _ThermalPrintScreenState extends State<ThermalPrintScreen> {
//   double _widthInInches = 3.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Thermal Print Invoice"),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text("Invoice Width (inches):"),
//                 SizedBox(width: 10),
//                 DropdownButton<double>(
//                   value: _widthInInches,
//                   items: [3.0, 4.0, 5.0].map((double value) {
//                     return DropdownMenuItem<double>(
//                       value: value,
//                       child: Text(value.toString()),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       _widthInInches = newValue!;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: PdfPreview(
//               build: (format) => _generatePdf(format, _widthInInches),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Printing.layoutPdf(
//             onLayout: (format) => _generatePdf(format, _widthInInches),
//           );
//         },
//         child: Icon(Icons.print),
//       ),
//     );
//   }

//   Future<Uint8List> _generatePdf(
//       PdfPageFormat format, double widthInInches) async {
//     final pdf = pw.Document();
//     final pageWidth = widthInInches * PdfPageFormat.inch;
//     final pageHeight = 11.69 * PdfPageFormat.inch;

//     final customPageFormat = PdfPageFormat(
//       pageWidth,
//       pageHeight,
//       marginAll: 0,
//     );

//     // Example data
//     final List<Map<String, dynamic>> products = [
//       {
//         "productName": "Netcola",
//         "company": "Lays Company",
//         "quantity": "22+1",
//         "rate": "2000/Bundle",
//         "discount": "10% | 200",
//         "vatPercent": "18%",
//         "vatAmount": "360Rs",
//         "total": "2360Rs"
//       },
//       {
//         "productName": "Product B",
//         "company": "Company B",
//         "quantity": "10+2",
//         "rate": "1500/Bundle",
//         "discount": "5% | 150",
//         "vatPercent": "18%",
//         "vatAmount": "270Rs",
//         "total": "1620Rs"
//       },
//       {
//         "productName": "Product C",
//         "company": "Company C",
//         "quantity": "5+1",
//         "rate": "1000/Bundle",
//         "discount": "8% | 80",
//         "vatPercent": "18%",
//         "vatAmount": "180Rs",
//         "total": "1100Rs"
//       },
//     ];

//     pdf.addPage(
//       pw.Page(
//         pageFormat: customPageFormat,
//         build: (pw.Context context) {
//           return pw.Container(
//             padding: pw.EdgeInsets.all(10),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: <pw.Widget>[
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Text("Okrasoft",
//                         style: pw.TextStyle(
//                             fontSize: pageWidth / 20,
//                             fontWeight: pw.FontWeight.bold)),
//                   ],
//                 ),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Text("Second floor ajwa foods, balokhel road, Mianwali",
//                         style: pw.TextStyle(
//                           fontSize: pageWidth / 30,
//                         )),
//                   ],
//                 ),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Text("Phone : 0333-1234567",
//                         style: pw.TextStyle(
//                           fontSize: pageWidth / 30,
//                         )),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Text("Sale Order",
//                         style: pw.TextStyle(
//                           decoration: pw.TextDecoration.underline,
//                           fontSize: pageWidth / 30,
//                         )),
//                   ],
//                 ),
//                 pw.Divider(),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           "Customer Name:",
//                           style: pw.TextStyle(
//                             fontSize: pageWidth / 30,
//                           ),
//                         ),
//                         // pw.SizedBox(height: 5),
//                         pw.Text(
//                           "John Doe",
//                           style: pw.TextStyle(
//                             fontSize: pageWidth / 30,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.Divider(),
//                     pw.SizedBox(width: 20),
//                     pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           "Phone Number:",
//                           style: pw.TextStyle(
//                             fontSize: pageWidth / 30,
//                           ),
//                         ),
//                         // pw.SizedBox(height: 5),
//                         pw.Text(
//                           "123-456-7890",
//                           style: pw.TextStyle(
//                             fontSize: pageWidth / 30,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(width: 20),
//                     pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           "Customer Balance:",
//                           style: pw.TextStyle(
//                             fontSize: pageWidth / 30,
//                           ),
//                         ),
//                         // pw.SizedBox(height: 5),
//                         pw.Text(
//                           "\$100.00",
//                           style: pw.TextStyle(
//                             fontSize: pageWidth / 30,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 pw.Divider(),
//                 pw.SizedBox(height: 10),
//                 pw.Table(
//                   columnWidths: {
//                     0: pw.FixedColumnWidth(pageWidth / 20),
//                     1: pw.FlexColumnWidth(),
//                     2: pw.FixedColumnWidth(pageWidth / 6),
//                     3: pw.FixedColumnWidth(pageWidth / 6),
//                     4: pw.FixedColumnWidth(pageWidth / 6),
//                   },
//                   // border: pw.TableBorder.all(),
//                   children: [
//                     pw.TableRow(
//                       children: [
//                         pw.Text('S#',
//                             style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                                 fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Product Name',
//                             style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                                 fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Qty+Bonus',
//                             style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                                 fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Rate',
//                             style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                                 fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Discount',
//                             style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                                 fontWeight: pw.FontWeight.bold)),
//                       ],
//                     ),
//                     ...products.asMap().entries.map((entry) {
//                       int index = entry.key + 1;
//                       Map<String, dynamic> product = entry.value;
//                       return pw.TableRow(
//                         children: [
//                           pw.Text(index.toString(),
//                               style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                               )),
//                           pw.Column(
//                             crossAxisAlignment: pw.CrossAxisAlignment.start,
//                             children: [
//                               pw.Text(product['productName'],
//                                   style: pw.TextStyle(
//                                     fontSize: pageWidth / 40,
//                                     fontWeight: pw.FontWeight.bold,
//                                   )),
//                               pw.Text(product['company'],
//                                   style:
//                                       pw.TextStyle(fontSize: pageWidth / 45)),
//                             ],
//                           ),
//                           pw.Text(product['quantity'],
//                               style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                               )),
//                           pw.Text(product['rate'],
//                               style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                               )),
//                           pw.Text(product['discount'],
//                               style: pw.TextStyle(
//                                 fontSize: pageWidth / 40,
//                               )),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }
// }
