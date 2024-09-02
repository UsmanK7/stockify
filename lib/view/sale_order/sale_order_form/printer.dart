import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ThermalPrintScreen extends StatefulWidget {
  const ThermalPrintScreen({super.key});

  @override
  State<ThermalPrintScreen> createState() => _ThermalPrintScreenState();
}

class _ThermalPrintScreenState extends State<ThermalPrintScreen> {
  double _widthInInches = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thermal Print Invoice"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Invoice Width (inches):"),
                SizedBox(width: 10),
                DropdownButton<double>(
                  value: _widthInInches,
                  items: [3.0, 4.0, 5.0].map((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _widthInInches = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => _generatePdf(format, _widthInInches),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Printing.layoutPdf(
            onLayout: (format) => _generatePdf(format, _widthInInches),
          );
        },
        child: Icon(Icons.print),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, double widthInInches) async {
    final pdf = pw.Document();
    final pageWidth = widthInInches * PdfPageFormat.inch;
    final pageHeight =
        11.69 * PdfPageFormat.inch; // A4 height, adjust as needed

    // Create a custom page format with the selected width and a dynamic height
    final customPageFormat = PdfPageFormat(
      pageWidth,
      pageHeight,
      marginAll: 0,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: customPageFormat,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("Date: 2024/12/12",
                        style: pw.TextStyle(
                          fontSize: pageWidth / 30,
                        )),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Okrasoft",
                        style: pw.TextStyle(
                            fontSize: pageWidth / 20,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                // pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Second floor ajwa foods, balokhel road, Mianwali",
                        style: pw.TextStyle(
                          fontSize: pageWidth / 30,
                        )),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Phone : 0333-1234567",
                        style: pw.TextStyle(
                          fontSize: pageWidth / 30,
                        )),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Item",
                        style: pw.TextStyle(
                            fontSize: pageWidth / 25,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text("Qty",
                        style: pw.TextStyle(
                            fontSize: pageWidth / 25,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text("Price",
                        style: pw.TextStyle(
                            fontSize: pageWidth / 25,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Product 1"),
                    pw.Text("2"),
                    pw.Text("\$50"),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Product 2"),
                    pw.Text("1"),
                    pw.Text("\$30"),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Total",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("\$80",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
