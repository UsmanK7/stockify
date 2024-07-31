abstract class AuthEvent {}

class InitialAuthEvent extends AuthEvent {}

class LoginRequest extends AuthEvent {
  String email;
  String password;
  LoginRequest({required this.email, required this.password});
}
