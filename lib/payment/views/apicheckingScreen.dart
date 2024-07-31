import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/payment/views/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  String? _token;
  double _progress = 0.0;
  int _totalTasks = 12; // Total number of tasks
  int _completedTasks = 0; // Number of completed tasks

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
  }

  void _updateProgress() {
    setState(() {
      _progress = _completedTasks / _totalTasks;
    });
  }

  Future<void> _fetchData(Future<void> Function() fetchFunction) async {
    await fetchFunction();
    setState(() {
      _completedTasks++;
      _updateProgress();
    });
  }

  Future<void> _fetchFirmDetails() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.firmUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          FirmSetting firmSetting = FirmSetting.fromJson(jsonData);
          final db = DBHelper();
          await db.updateFirmSetting(firmSetting);
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchUserDetails() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.userUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          User user = User.fromJson(jsonData['user']);
          List<AuthPermission> permissions = [];
          if (jsonData.containsKey('permissions')) {
            permissions = (jsonData['permissions'] as List)
                .map((permission) => AuthPermission.fromJson(permission))
                .toList();
          }
          final db = DBHelper();
          await db.updateUserSetting(user);
          await db.insertPermissions(permissions);
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchUserTypeDetails() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.usertypeUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<UserType> userTypes = jsonData
              .map<UserType>((jsonUserType) => UserType.fromJson(jsonUserType))
              .toList();
          final db = DBHelper();
          for (var userType in userTypes) {
            await db.updateUserType(userType);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchProducts() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.product),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<Product> products = jsonData
              .map<Product>((jsonproduct) => Product.fromJson(jsonproduct))
              .toList();
          final db = DBHelper();
          for (var product in products) {
            await db.updateProducts(product);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchStoreDetails() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.storeUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<Store> stores = jsonData
              .map<Store>((jsonStore) => Store.fromJson(jsonStore))
              .toList();
          final db = DBHelper();
          for (var store in stores) {
            await db.updateStore(store);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchProductCompanyDetails() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.productComapnaiesUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<ProductCompany> companies = jsonData
              .map<ProductCompany>(
                  (jsonCompany) => ProductCompany.fromJson(jsonCompany))
              .toList();
          final db = DBHelper();
          for (var company in companies) {
            await db.updateProductCompanies(company);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchProductGrouping() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.productGrouping),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<ProductGrouping> groupings = jsonData
              .map<ProductGrouping>(
                  (jsonGrouping) => ProductGrouping.fromJson(jsonGrouping))
              .toList();
          final db = DBHelper();
          for (var grouping in groupings) {
            await db.updateProductComGrp(grouping);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchCountries() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.country),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<Country> countries = jsonData
              .map<Country>((jsonCountry) => Country.fromJson(jsonCountry))
              .toList();
          final db = DBHelper();
          for (var country in countries) {
            await db.updateCountry(country);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchState() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.state),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<States> states = jsonData
              .map<States>((jsonState) => States.fromJson(jsonState))
              .toList();
          final db = DBHelper();
          for (var state in states) {
            await db.updateState(state);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchCities() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.cities),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<City> cities = jsonData
              .map<City>((jsonCity) => City.fromJson(jsonCity))
              .toList();
          final db = DBHelper();
          for (var city in cities) {
            await db.updateCities(city);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchAreas() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.areas),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<Area> areas = jsonData
              .map<Area>((jsonArea) => Area.fromJson(jsonArea))
              .toList();
          final db = DBHelper();
          for (var area in areas) {
            await db.updateAreas(area);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  Future<void> _fetchCustomer() async {
    if (_token != null) {
      try {
        final response = await http.post(
          Uri.parse(Constant.customer),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authorization_token': _token}),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          List<Customer> customers = jsonData
              .map<Customer>((jsonCustomer) => Customer.fromJson(jsonCustomer))
              .toList();
          final db = DBHelper();
          for (var customer in customers) {
            await db.updateCustomer(customer);
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchData(_fetchFirmDetails);
                _fetchData(_fetchUserDetails);
                _fetchData(_fetchUserTypeDetails);
                _fetchData(_fetchAreas);
                _fetchData(_fetchStoreDetails);
                _fetchData(_fetchProductCompanyDetails);
                _fetchData(_fetchProductGrouping);
                _fetchData(_fetchProducts);
                _fetchData(_fetchCountries);
                _fetchData(_fetchState);
                _fetchData(_fetchCities);
                _fetchData(_fetchCustomer);
              },
              child: Text('Sync all'),
            ),
          ],
        ),
      ),
    );
  }
}
