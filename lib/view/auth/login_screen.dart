import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/auth/bloc/auth_bloc.dart';
import 'package:okra_distributer/view/auth/bloc/auth_event.dart';
import 'package:okra_distributer/view/auth/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    authBloc.add(InitialAuthEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Login page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBlue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: "Enter email"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(hintText: "Enter password"),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    bloc: authBloc,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          authBloc.add(LoginRequest(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          color: appBlue,
                          alignment: Alignment.center,
                          child: state is LoadingState
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    },
                    buildWhen: (previous, current) =>
                        current is! AuthActionState,
                    listenWhen: (previous, current) =>
                        current is AuthActionState,
                    listener: (context, state) {
                      if (state is LoginFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                        authBloc.add(InitialAuthEvent());
                      } else if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.green,
                                ),
                                child: Icon(Icons.check),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("logged in as ${state.user}")
                            ],
                          )),
                        );
                        authBloc.add(InitialAuthEvent());
                        // Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
