import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'Home/home_screen.dart';
import 'Order/order_screen.dart';
import 'Profile/profile_screen.dart';
import 'Wallet/wallet_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomeScreen homeScreen;
  late WalletScreen walletScreen;
  late OrderScreen orderScreen;
  late ProfileScreen profileScreen;

  @override
  void initState() {
    homeScreen = const HomeScreen();
    walletScreen = const WalletScreen();
    orderScreen = const OrderScreen();
    profileScreen = const ProfileScreen();
    pages = [homeScreen, orderScreen, walletScreen, profileScreen];
    currentPage = homeScreen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: height*0.07,
        color: black,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(
            () {
              currentTabIndex = index;
            },
          );
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: white,
          ),
          Icon(
            Icons.shop_outlined,
            color: white,
          ),
          Icon(
            Icons.wallet_outlined,
            color: white,
          ),
          Icon(
            Icons.person_outlined,
            color: white,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
