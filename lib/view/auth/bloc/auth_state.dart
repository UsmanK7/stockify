abstract class AuthState {}

abstract class AuthActionState extends AuthState {}

class InitialAuthState extends AuthState {}

class LoadingState extends AuthState {}

class LoginSuccess extends AuthActionState {
  String user;
  LoginSuccess({required this.user});
}

class LoginFailed extends AuthActionState {
  String error;
  LoginFailed({required this.error});
}
