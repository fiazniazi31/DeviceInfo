import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/register.dart';
import 'package:myapp/secreens/homeSecreen.dart';
import 'package:myapp/services/authService.dart';
import "package:flutter_signin_button/flutter_signin_button.dart";

class Login extends StatefulWidget {
  static String id = "./login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 20,
              ),
              const Text('Login',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              SizedBox(
                height: 25,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Enter Username", border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Enter Password", border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 25,
              ),
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if (emailController.text == "" ||
                            passwordController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("All fields are required"),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          User? result = await AuthService().login(
                              emailController.text,
                              passwordController.text,
                              context);
                          if (result != null) {
                            print("Succeed");
                            print(result.email);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeSecreen(result)));
                          } else if (result == null) {
                            print("Its nul");
                          }
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Text('Login')),
              SizedBox(
                height: 15,
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              SignInButton(Buttons.Google, text: "Continute with Google",
                  onPressed: () async {
                await AuthService().signInWithGoogle();
              }),
              SizedBox(
                height: 30,
              ),
              Text("If don't have account registere"),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text("here"))
            ],
          ),
        ),
      ),
    );
  }
}
