import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/colors.dart';
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: white,
        selectedItemColor: buttonColor,
        unselectedItemColor: Colors.grey,
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
        onTap: (index) {
          setState(
            () {
              currentTabIndex = index;
            },
          );
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home_outlined,
              // color: black,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Order',
            icon: Icon(
              Icons.shop_outlined,

            ),
          ),
          BottomNavigationBarItem(
            label: 'Wallet',
            icon: Icon(
              Icons.wallet_outlined,

            ),
          ),
          BottomNavigationBarItem(
            label: 'profile',
            icon: Icon(
              Icons.person_outlined,

            ),
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
