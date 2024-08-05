import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:okra_distributer/bloc/UpdatedBloc/updateEvent.dart';
import 'package:okra_distributer/bloc/UpdatedBloc/updateState.dart';
import 'package:okra_distributer/payment/views/apicheckingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/payment/views/Constant.dart';

// Bloc for handling data update tasks
class UpdationBloc extends Bloc<UpdationEvent, UpdationState> {
  final db = DBHelper();
  String? _token;
  final int _totalTasks = 12;
  int _completedTasks = 0;
  List<TaskStatus> _taskStatuses = [];

  UpdationBloc() : super(FirstState()) {
    _initializeTaskStatuses();
    on<UpdateData>(_onUpdateData);
    on<UpdatingProgress>(_onUpdatingProgress);
    on<UpdatingTaskStatus>(_onUpdatingTaskStatus);
  }

  // Initialize task statuses
  void _initializeTaskStatuses() {
    _taskStatuses = [
      TaskStatus(name: "Fetch Firm Details", status: "Pending"),
      TaskStatus(name: "Fetch User Details", status: "Pending"),
      TaskStatus(name: "Fetch User Type Details", status: "Pending"),
      TaskStatus(name: "Fetch Areas", status: "Pending"),
      TaskStatus(name: "Fetch Store Details", status: "Pending"),
      TaskStatus(name: "Fetch Product Companies", status: "Pending"),
      TaskStatus(name: "Fetch Product Groupings", status: "Pending"),
      TaskStatus(name: "Fetch Products", status: "Pending"),
      TaskStatus(name: "Fetch Countries", status: "Pending"),
      TaskStatus(name: "Fetch States", status: "Pending"),
      TaskStatus(name: "Fetch Cities", status: "Pending"),
      TaskStatus(name: "Fetch Customers", status: "Pending"),
    ];
  }

  // Handle data update event
  Future<void> _onUpdateData(
      UpdateData event, Emitter<UpdationState> emit) async {
    _token = await _getToken();

    if (_token != null) {
      await _fetchData(_fetchFirmDetails, 0, emit);
      await _fetchData(_fetchUserDetails, 1, emit);
      await _fetchData(_fetchUserTypeDetails, 2, emit);
      await _fetchData(_fetchAreas, 3, emit);
      await _fetchData(_fetchStoreDetails, 4, emit);
      await _fetchData(_fetchProductCompanyDetails, 5, emit);
      await _fetchData(_fetchProductGrouping, 6, emit);
      await _fetchData(_fetchProducts, 7, emit);
      await _fetchData(_fetchCountries, 8, emit);
      await _fetchData(_fetchStates, 9, emit);
      await _fetchData(_fetchCities, 10, emit);
      await _fetchData(_fetchCustomers, 11, emit);

      emit(SucessfulState());
    } else {
      emit(FailedDState("Token is missing"));
    }
  }

  // Handle progress update event
  Future<void> _onUpdatingProgress(
      UpdatingProgress event, Emitter<UpdationState> emit) async {
    _completedTasks = event.completedTasks;
    final progress = _completedTasks / _totalTasks;
    emit(LoadingState(progress, List.from(_taskStatuses)));
  }

  // Handle task status update event
  Future<void> _onUpdatingTaskStatus(
      UpdatingTaskStatus event, Emitter<UpdationState> emit) async {
    _taskStatuses[event.taskIndex].status = event.status;
    emit(LoadingState(_completedTasks / _totalTasks, List.from(_taskStatuses)));
  }

  // Retrieve token from shared preferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Fetch data and update task status
  Future<void> _fetchData(
    Future<void> Function() fetchFunction,
    int taskIndex,
    Emitter<UpdationState> emit,
  ) async {
    try {
      await fetchFunction();
      _completedTasks++;
      add(UpdatingProgress(_completedTasks));
      // add(UpdatingTaskStatus(taskIndex, "Done"));
    } catch (e) {
      add(UpdatingTaskStatus(taskIndex, "Failed"));
    }
  }

  // Fetch firm details
  Future<void> _fetchFirmDetails() async {
    final appID = await db.getAppId();

    try {
      final response = await http.post(
        Uri.parse(Constant.firmUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new store details to update.');
          add(UpdatingTaskStatus(0, "Already Updated"));
          return;
        }

        // Parse and update stores
        if (jsonData is List) {
          List<FirmSetting> firm = jsonData
              .map<FirmSetting>((jsonStore) => FirmSetting.fromJson(jsonStore))
              .toList();

          final db = DBHelper();
          for (var firm in firm) {
            await db.updateFirmSetting(firm);
          }
          add(UpdatingTaskStatus(0, "Done"));
        }
      } else {
        throw Exception("Failed to fetch store details");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fetch user details
  Future<void> _fetchUserDetails() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.userUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new user details to update.');
          add(UpdatingTaskStatus(1, "Already Updated"));

          return;
        }

        if (jsonData is Map && jsonData.isNotEmpty) {
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
          add(UpdatingTaskStatus(1, "Done"));
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed to fetch user details");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fetch user type details
  Future<void> _fetchUserTypeDetails() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.usertypeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new user type details to update.');

          add(UpdatingTaskStatus(2, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<UserType> userTypes = jsonData
              .map<UserType>((jsonUserType) => UserType.fromJson(jsonUserType))
              .toList();

          final db = DBHelper();
          for (var userType in userTypes) {
            await db.updateUserType(userType);
          }

          add(UpdatingTaskStatus(2, "Done"));
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed to fetch user type details");
      }
    } catch (e) {
      add(UpdatingTaskStatus(2, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch products
  Future<void> _fetchProducts() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.product),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new products to update.');
          add(UpdatingTaskStatus(3, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<Product> products = jsonData
              .map<Product>((jsonproduct) => Product.fromJson(jsonproduct))
              .toList();

          final db = DBHelper();
          for (var product in products) {
            await db.updateProducts(product);
          }
          add(UpdatingTaskStatus(3, "Done"));
        }
      } else {
        throw Exception("Failed to fetch products");
      }
    } catch (e) {
      add(UpdatingTaskStatus(3, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch store details
  Future<void> _fetchStoreDetails() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.storeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new store details to update.');
          add(UpdatingTaskStatus(4, "Already Updated"));
          return;
        }

        // Parse and update stores
        if (jsonData is List) {
          List<Store> stores = jsonData
              .map<Store>((jsonStore) => Store.fromJson(jsonStore))
              .toList();

          final db = DBHelper();
          for (var store in stores) {
            await db.updateStore(store);
          }
          add(UpdatingTaskStatus(4, "Done"));
        }
      } else {
        throw Exception("Failed to fetch store details");
      }
    } catch (e) {
      add(UpdatingTaskStatus(4, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch product company details
  Future<void> _fetchProductCompanyDetails() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.productComapnaiesUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new product companies to update.');
          add(UpdatingTaskStatus(5, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<ProductCompany> productCompanies = jsonData
              .map<ProductCompany>((jsonProductCompany) =>
                  ProductCompany.fromJson(jsonProductCompany))
              .toList();

          final db = DBHelper();
          for (var productCompany in productCompanies) {
            await db.updateProductCompanies(productCompany);
          }
          add(UpdatingTaskStatus(5, "Done"));
        }
      } else {
        throw Exception("Failed to fetch product companies");
      }
    } catch (e) {
      add(UpdatingTaskStatus(5, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch product groupings
  Future<void> _fetchProductGrouping() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.productGrouping),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new product groupings to update.');
          add(UpdatingTaskStatus(6, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<ProductGrouping> productGroupings = jsonData
              .map<ProductGrouping>((jsonProductGrouping) =>
                  ProductGrouping.fromJson(jsonProductGrouping))
              .toList();

          final db = DBHelper();
          for (var productGrouping in productGroupings) {
            await db.updateProductComGrp(productGrouping);
          }
          add(UpdatingTaskStatus(6, "Done"));
        }
      } else {
        throw Exception("Failed to fetch product groupings");
      }
    } catch (e) {
      add(UpdatingTaskStatus(6, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch areas
  Future<void> _fetchAreas() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.areas),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new areas to update.');
          add(UpdatingTaskStatus(7, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<Area> areas = jsonData
              .map<Area>((jsonArea) => Area.fromJson(jsonArea))
              .toList();

          final db = DBHelper();
          for (var area in areas) {
            await db.updateAreas(area);
          }
          add(UpdatingTaskStatus(7, "Done"));
        }
      } else {
        throw Exception("Failed to fetch areas");
      }
    } catch (e) {
      add(UpdatingTaskStatus(7, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch countries
  Future<void> _fetchCountries() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.country),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new countries to update.');
          add(UpdatingTaskStatus(8, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<Country> countries = jsonData
              .map<Country>((jsonCountry) => Country.fromJson(jsonCountry))
              .toList();

          final db = DBHelper();
          for (var country in countries) {
            await db.updateCountry(country);
          }
          add(UpdatingTaskStatus(8, "Done"));
        }
      } else {
        throw Exception("Failed to fetch countries");
      }
    } catch (e) {
      add(UpdatingTaskStatus(8, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch states
  Future<void> _fetchStates() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.state),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new states to update.');
          add(UpdatingTaskStatus(9, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<States> states = jsonData
              .map<States>((jsonState) => States.fromJson(jsonState))
              .toList();

          final db = DBHelper();
          for (var state in states) {
            await db.updateState(state);
          }
          add(UpdatingTaskStatus(9, "Done"));
        }
      } else {
        throw Exception("Failed to fetch states");
      }
    } catch (e) {
      add(UpdatingTaskStatus(9, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch cities
  Future<void> _fetchCities() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.cities),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new cities to update.');
          add(UpdatingTaskStatus(10, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<City> cities = jsonData
              .map<City>((jsonCity) => City.fromJson(jsonCity))
              .toList();

          final db = DBHelper();
          for (var city in cities) {
            await db.updateCities(city);
          }
          add(UpdatingTaskStatus(10, "Done"));
        }
      } else {
        throw Exception("Failed to fetch cities");
      }
    } catch (e) {
      add(UpdatingTaskStatus(10, "Failed"));
      print("Error: $e");
    }
  }

  // Fetch customers
  Future<void> _fetchCustomers() async {
    final appID = await db.getAppId();
    try {
      final response = await http.post(
        Uri.parse(Constant.customer),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authorization_token': _token,
          'get_all': '0',
          'app_id': appID.toString()
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List && jsonData.isEmpty) {
          print('Updated: No new customers to update.');
          add(UpdatingTaskStatus(11, "Already Updated"));
          return;
        }

        if (jsonData is List) {
          List<Customer> customers = jsonData
              .map<Customer>((jsonCustomer) => Customer.fromJson(jsonCustomer))
              .toList();

          final db = DBHelper();
          for (var customer in customers) {
            await db.updateCustomer(customer);
          }
          add(UpdatingTaskStatus(11, "Done"));
        }
      } else {
        throw Exception("Failed to fetch customers");
      }
    } catch (e) {
      add(UpdatingTaskStatus(11, "Failed"));
      print("Error: $e");
    }
  }
}
