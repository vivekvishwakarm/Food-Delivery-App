import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/View/Login/sign_up.dart';

import '../../utils/colors.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mailController = TextEditingController();
  String email = "";
  final _formkey = GlobalKey<FormState>();

  // resetPassword() async {
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Password reset has been sent',
  //           style: TextStyle(fontSize: 18,color: Colors.yellowAccent),
  //         ),
  //       ),
  //     );
  //   } on FirebaseException catch (e) {
  //     if(e.code == 'user-not-found'){
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             'No user found of that email',
  //             style: TextStyle(fontSize: 18),
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  resetPassword() async {
    if (email.isEmpty) {
      // Email is empty, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid email address.',
            style: TextStyle(fontSize: 18, color: Colors.redAccent,backgroundColor: Colors.white),
          ),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset email has been sent',
            style: TextStyle(fontSize: 18, color: Colors.greenAccent),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      } else {
        errorMessage = 'Failed to send reset email. Try again later.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ),
      );
    } catch (e) {
      // Handle any other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              "Password Recovery",
              style: TextStyle(
                color: white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Enter your mail",
            style: TextStyle(
              color: white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: mailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your mail";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: white,
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 30,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        if(_formkey.currentState!.validate()){
                          setState(() {
                            email = mailController.text;
                          });
                          resetPassword();
                        }
                      },
                      child: Text(
                        "Send Email",
                        style: TextStyle(
                            color: black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                text: "Don\'t have an account? ",
                                style: TextStyle(fontSize: 16)),
                            TextSpan(
                              text: "Create",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.yellow.shade300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
