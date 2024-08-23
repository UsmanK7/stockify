import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:okra_distributer/payment/views/UpdationScreen.dart';
import 'package:okra_distributer/payment/views/apicheckingScreen.dart';
import 'package:okra_distributer/view/first_homescreen/first_home_screen.dart';
import 'package:sqflite/sqflite.dart';

class GetDataScreen extends StatefulWidget {
  const GetDataScreen({super.key});

  @override
  State<GetDataScreen> createState() => _GetDataScreenState();
}

class _GetDataScreenState extends State<GetDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is not Heading"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompletionScreen()));
                },
                child: Text("Get All Data")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdationScreen()));
                },
                child: Text('Update Data')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirstHomeScreen()));
                },
                child: Text('Go To HomeScreen')),
          ],
        ),
      ),
    );
  }
}
