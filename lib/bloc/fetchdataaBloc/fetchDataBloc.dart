import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:okra_distributer/bloc/fetchdataaBloc/fectDataState.dart';
import 'package:okra_distributer/bloc/fetchdataaBloc/fetchdataevent.dart';
import 'package:okra_distributer/payment/views/apicheckingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/Models/model.dart';
import 'package:okra_distributer/payment/views/Constant.dart';

class CompletionBloc extends Bloc<CompletionEvent, CompletionState> {
  String? _token;
  final int _totalTasks = 12;
  final db = DBHelper();

  int _completedTasks = 0;
  List<TaskStatus> _taskStatuses = [];

  CompletionBloc() : super(InitialState()) {
    _initializeTaskStatuses();
    on<FetchData>(_onFetchData);
    on<UpdateProgress>(_onUpdateProgress);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
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

  Future<void> _onFetchData(
      FetchData event, Emitter<CompletionState> emit) async {
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

      emit(SuccessState());
    } else {
      emit(FailureState("Token is missing"));
    }
  }

  Future<void> _onUpdateProgress(
      UpdateProgress event, Emitter<CompletionState> emit) async {
    _completedTasks = event.completedTasks;
    final progress = _completedTasks / _totalTasks;
    emit(LoadingState(progress, List.from(_taskStatuses)));
  }

  Future<void> _onUpdateTaskStatus(
      UpdateTaskStatus event, Emitter<CompletionState> emit) async {
    _taskStatuses[event.taskIndex].status = event.status;
    emit(LoadingState(_completedTasks / _totalTasks, List.from(_taskStatuses)));
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> _fetchData(
    Future<void> Function() fetchFunction,
    int taskIndex,
    Emitter<CompletionState> emit,
  ) async {
    try {
      await fetchFunction();
      _completedTasks++;
      add(UpdateProgress(_completedTasks));
      add(UpdateTaskStatus(taskIndex, "Done"));
    } catch (e) {
      add(UpdateTaskStatus(taskIndex, "Failed"));
    }
  }

  Future<void> _fetchFirmDetails() async {
    final appID = await db.getAppId();

    final response = await http.post(
      Uri.parse(Constant.firmUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      FirmSetting firmSetting = FirmSetting.fromJson(jsonData);
      final db = DBHelper();
      await db.updateFirmSetting(firmSetting);
    } else {
      throw Exception("Failed to fetch firm details");
    }
  }

  Future<void> _fetchUserDetails() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.userUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
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
      throw Exception("Failed to fetch user details");
    }
  }

  Future<void> _fetchUserTypeDetails() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.usertypeUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<UserType> userTypes = (jsonData as List)
          .map<UserType>((jsonUserType) => UserType.fromJson(jsonUserType))
          .toList();
      final db = DBHelper();
      for (var userType in userTypes) {
        await db.updateUserType(userType);
      }
    } else {
      throw Exception("Failed to fetch user type details");
    }
  }

  Future<void> _fetchProducts() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.product),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Product> products = (jsonData as List)
          .map<Product>((jsonproduct) => Product.fromJson(jsonproduct))
          .toList();
      final db = DBHelper();
      for (var product in products) {
        await db.updateProducts(product);
      }
    } else {
      throw Exception("Failed to fetch products");
    }
  }

  Future<void> _fetchStoreDetails() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.storeUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Store> stores = (jsonData as List)
          .map<Store>((jsonStore) => Store.fromJson(jsonStore))
          .toList();
      final db = DBHelper();
      for (var store in stores) {
        await db.updateStore(store);
      }
    } else {
      throw Exception("Failed to fetch store details");
    }
  }

  Future<void> _fetchProductCompanyDetails() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.productComapnaiesUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<ProductCompany> productCompanies = (jsonData as List)
          .map<ProductCompany>((jsonproductCompany) =>
              ProductCompany.fromJson(jsonproductCompany))
          .toList();
      final db = DBHelper();
      for (var productCompany in productCompanies) {
        await db.updateProductCompanies(productCompany);
      }
    } else {
      throw Exception("Failed to fetch product companies");
    }
  }

  Future<void> _fetchProductGrouping() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.productGrouping),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<ProductGrouping> productGroupings = (jsonData as List)
          .map<ProductGrouping>((jsonproductGrouping) =>
              ProductGrouping.fromJson(jsonproductGrouping))
          .toList();
      final db = DBHelper();
      for (var productGrouping in productGroupings) {
        await db.updateProductComGrp(productGrouping);
      }
    } else {
      throw Exception("Failed to fetch product groupings");
    }
  }

  Future<void> _fetchCountries() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.country),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Country> countries = (jsonData as List)
          .map<Country>((jsonCountry) => Country.fromJson(jsonCountry))
          .toList();
      final db = DBHelper();
      for (var country in countries) {
        await db.updateCountry(country);
      }
    } else {
      throw Exception("Failed to fetch countries");
    }
  }

  Future<void> _fetchStates() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.state),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<States> states = (jsonData as List)
          .map<States>((jsonState) => States.fromJson(jsonState))
          .toList();
      final db = DBHelper();
      for (var state in states) {
        await db.updateState(state);
      }
    } else {
      throw Exception("Failed to fetch states");
    }
  }

  Future<void> _fetchCities() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.cities),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<City> cities = (jsonData as List)
          .map<City>((jsonCity) => City.fromJson(jsonCity))
          .toList();
      final db = DBHelper();
      for (var city in cities) {
        await db.updateCities(city);
      }
    } else {
      throw Exception("Failed to fetch cities");
    }
  }

  Future<void> _fetchCustomers() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.customer),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Customer> customers = (jsonData as List)
          .map<Customer>((jsonCustomer) => Customer.fromJson(jsonCustomer))
          .toList();
      final db = DBHelper();
      for (var customer in customers) {
        await db.updateCustomer(customer);
      }
    } else {
      throw Exception("Failed to fetch customers");
    }
  }

  Future<void> _fetchAreas() async {
    final appID = await db.getAppId();
    final response = await http.post(
      Uri.parse(Constant.areas),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorization_token': _token,
        'get_all': '1',
        'app_id': appID.toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Area> areas = (jsonData as List)
          .map<Area>((jsonArea) => Area.fromJson(jsonArea))
          .toList();
      final db = DBHelper();
      for (var area in areas) {
        await db.updateAreas(area);
      }
    } else {
      throw Exception("Failed to fetch areas");
    }
  }
}
