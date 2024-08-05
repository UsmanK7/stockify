import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/views/Constant.dart';
import 'package:okra_distributer/payment/views/GettingDataScreen.dart';
import 'package:okra_distributer/payment/views/sendingDeviceInfo.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and Password are required')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(Constant.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final token = jsonData['token'];
        final userId = jsonData['user_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('user_id', userId);

        if (token != null) {
          await Future.delayed(Duration(seconds: 1));
          final sendingDeviceInfo = SendingDeviceInfo();
          await sendingDeviceInfo.sendDeviceData(userId);

          print('Token: $token');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GetDataScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid username or password'),
            ),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    } catch (error) {
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during login'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Text(
              "Login",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Roboto', fontSize: 24.sp),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .90,
                  height: MediaQuery.of(context).size.height * .070,
                  child: TextField(
                    controller: usernameController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xFFD9D9D9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.white,
                    child: Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF91919F),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //Password
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .90,
                  height: MediaQuery.of(context).size.height * .070,
                  child: TextField(
                    controller: passwordController,
                    maxLines: 1,
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xFFD9D9D9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.white,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF91919F),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.07,
              child: TextButton(
                onPressed: login,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
