import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class ThermalPrintScreen extends StatefulWidget {
  final String invoiceData;

  const ThermalPrintScreen({Key? key, required this.invoiceData}) : super(key: key);

  @override
  _ThermalPrintScreenState createState() => _ThermalPrintScreenState();
}

class _ThermalPrintScreenState extends State<ThermalPrintScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _getBluetoothDevices();
  }

  void _getBluetoothDevices() async {
    final devices = await bluetooth.getBondedDevices();
    setState(() {
      _devices = devices;
    });
  }

  void _connectToDevice() async {
    if (_selectedDevice != null) {
      await bluetooth.connect(_selectedDevice!);
    }
  }

  void _printInvoice() async {
    await bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printCustom("Sales Invoice", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom(widget.invoiceData, 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank you!", 2, 1);
        bluetooth.printNewLine();
        bluetooth.paperCut();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Printer not connected!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thermal Printing'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<BluetoothDevice>(
              hint: Text('Select Bluetooth Device'),
              value: _selectedDevice,
              onChanged: (BluetoothDevice? value) {
                setState(() {
                  _selectedDevice = value;
                });
                _connectToDevice();
              },
              items: _devices.map((device) {
                return DropdownMenuItem<BluetoothDevice>(
                  value: device,
                  child: Text(device.name!),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _printInvoice,
              child: Text('Print Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}
