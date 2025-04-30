import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/View/Login/sign_up.dart';

import '../../Widget/ui_helper.dart';
import '../../utils/colors.dart';
import '../bottom_nav_bar.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  final _formkey = GlobalKey<FormState>();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  userLogin() async {
    if (email.trim().isNotEmpty &&
        password.trim().isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        // Navigate to BottomNavBar on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "No user found for that email",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Wrong password provided",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Invalid email format",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login failed: ${e.message}",
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        }
      } catch (error) {
        // Handle general errors (e.g., network issues)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "An error occurred: $error",
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        );
      }
    } else {
      // If email or password is empty, show a warning
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter both email and password",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Container(
                width: width,
                height: height * 0.4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFff5c30),
                      Color(0xFFe74b1a),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.35),
                height: height * 0.5,
                width: width,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const Text(""),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: height * 0.05,
                  left: width * 0.04,
                  right: width * 0.04,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: width * 0.6,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.07,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      elevation: 10.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.03,
                        ),
                        width: width,
                        height: height * 0.45,
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Text(
                                "Login",
                                style: UiHelper.semiBoldTextStyle()
                                    .copyWith(fontSize: 24),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: userEmailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your email";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: UiHelper.semiBoldTextStyle(),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: userPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your Password";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: UiHelper.semiBoldTextStyle(),
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    color: black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPassword()));
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: UiHelper.semiBoldTextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(25),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width * 0.5, height * 0.055),
                                    backgroundColor: const Color(0xFFff5c30),
                                  ),
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        email = userEmailController.text;
                                        password = userPasswordController.text;
                                      });
                                    }
                                    userLogin();
                                  },
                                  child: Text(
                                    'LOGIN',
                                    style: UiHelper.semiBoldTextStyle()
                                        .copyWith(color: white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: Text(
                        'Don\'t have an account? Sign Up',
                        style: UiHelper.semiBoldTextStyle(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
