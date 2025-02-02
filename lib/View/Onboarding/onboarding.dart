import 'package:flutter/material.dart';

import '../../Model/content_model.dart';
import '../../Widget/ui_helper.dart';
import '../../utils/colors.dart';
import '../Login/sign_up.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: height * 0.5,
                        width: width,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: height * 0.04),
                      Text(
                        contents[i].title,
                        style: UiHelper.semiBoldTextStyle().copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        contents[i].description,
                        style: UiHelper.lightTextStyle(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index, context),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignUp()));
              } else {
                _controller.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn);
              }
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: height * 0.06,
                width: width * 0.7,
                margin: const EdgeInsets.all(40),
                alignment: Alignment.center,
                child: Text(
                  currentIndex == contents.length - 1 ? 'start' : 'Next',
                  style: UiHelper.semiBoldTextStyle().copyWith(color: white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 18 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.red : Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
