import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/auth/bloc/auth_event.dart';
import 'package:okra_distributer/view/auth/bloc/auth_state.dart';
import 'package:get_storage/get_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    on<InitialAuthEvent>(initialAuthEvent);
    on<LoginRequest>(loginRequest);
  }

  FutureOr<void> loginRequest(
      LoginRequest event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    final Uri url = Uri.parse(loginUrl);
    final Uri user_details_url = Uri.parse(userdetailsUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'username': event.email,
      'password': event.password,
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('error')) {
        print(jsonResponse['error']);
        emit(LoginFailed(error: jsonResponse['error']));
        // emit(InitialAuthState());
      } else if (jsonResponse.containsKey('success')) {
        final _box = GetStorage();
        final _token = 'token';

        final token = jsonResponse['token'];
        _box.write(_token, token);
        final token_body = {
          'authorization_token': token,
          'get_all': 1,
        };
        final user_details_response = await http.post(user_details_url,
            headers: headers, body: jsonEncode(token_body));
        if (user_details_response.statusCode == 200) {
          final user_details = jsonDecode(user_details_response.body);
          // print(user_details['user']['id']);

          final _iFirmID = user_details['user']['iFirmID'];
          final _iSystemUserID = user_details['user']['id'];
          final _iStoreID = user_details['user']['iStoreID'];
          _box.write("iFirmID", _iFirmID);
          _box.write("iStoreID", _iStoreID);
          _box.write("iSystemUserID", _iSystemUserID);
        } else {
          print("failed");
        }
        // final user_details = jsonDecode(user_details_response.body);

        // print(user_details['user']['id']);
        emit(LoginSuccess(user: event.email));
        // emit(InitialAuthState());
      }
    } else {
      print("error in auth post");
    }
  }

  FutureOr<void> initialAuthEvent(
      InitialAuthEvent event, Emitter<AuthState> emit) {
    emit(InitialAuthState());
  }
}
