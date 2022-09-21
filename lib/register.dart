import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/login.dart';
import 'package:myapp/secreens/homeSecreen.dart';
import 'package:myapp/services/authService.dart';

class Register extends StatefulWidget {
  static String id = "./register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red[400],
      appBar: AppBar(
        title: Text(
          "Register",
        ),
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 20,
              ),
              const Text('Sigh Up',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              SizedBox(
                height: 25,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter name", border: OutlineInputBorder()),
              ),
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
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    hintText: "Confirm Password", border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter Phone No",
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10)
                        )),
              ),
              SizedBox(
                height: 30,
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
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Password did't match."),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          User? result = await AuthService().register(
                              emailController.text,
                              passwordController.text,
                              context);
                          if (result != null) {
                            print("Succeed");
                            print(result.email);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Account has been register successfully"),
                              backgroundColor: Colors.green,
                            ));
                            Future.delayed(const Duration(seconds: 50));
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
                      child: Text('Sign Up')),
              SizedBox(
                height: 30,
              ),
              Text("Have an account go to"),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
