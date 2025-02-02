import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Controller/database.dart';
import 'package:random_string/random_string.dart';

import '../../Controller/shared_prefe.dart';
import '../../Widget/ui_helper.dart';
import '../../utils/colors.dart';
import '../bottom_nav_bar.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = "", email = "", password = "";
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  registration() async {
    // Check if email and password are not null or empty
    if (email != null &&
        email.trim().isNotEmpty &&
        password != null &&
        password.trim().isNotEmpty) {
      try {
        // Register user with Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(
              "Registered Successfully",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        );

        String id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo={
          "Name": nameController.text,
          "Email":emailController.text,
          "Wallet":"0",
          "Id":id
        };

        await DatabaseMethods().addUserDetails(addUserInfo, id);
        // Store locally
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserWallet('0');
        await SharedPreferenceHelper().saveUserId(id);

        // Navigate to BottomNavBar screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase exceptions
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.yellowAccent,
              content: Text(
                "The password provided is too weak",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.yellowAccent,
              content: Text(
                'An account already exists with this email',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                'The email address is not valid',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Registration failed: ${e.message}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        }
      } catch (error) {
        // Handle general errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'An error occurred: $error',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      }
    } else {
      // If email or password is empty, show a warning
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Please provide a valid email and password",
            style: TextStyle(fontSize: 18),
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
                        height: height * 0.5,
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Text(
                                "Sign Up",
                                style: UiHelper.semiBoldTextStyle()
                                    .copyWith(fontSize: 24),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your name";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: UiHelper.semiBoldTextStyle(),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your E-mail";
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
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your password";
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
                                        email = emailController.text;
                                        name = nameController.text;
                                        password = passwordController.text;
                                      });
                                    }
                                    registration();
                                  },
                                  child: Text(
                                    'SIGN UP',
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
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account? Login',
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
