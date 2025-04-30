import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Controller/database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:food_delivery_app/Widget/food_carousel_slider.dart';
import '../../Widget/ui_helper.dart';
import '../../utils/colors.dart';
import 'details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool iceCream = false, pizza = false, salad = false, burger = false;
  bool isConnected = true; // For internet connectivity check
  Stream? foodItemStream;

  @override
  void initState() {
    super.initState();
    checkInternetConnection(); // Check internet connection on startup
    onTheLoad();
  }

  // Check internet connectivity
  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  // Load food items from Firestore
  onTheLoad() async {
    if (isConnected) {
      foodItemStream = await DatabaseMethods().getFoodItem("Pizza");
      setState(() {});
    }
  }

  // Show a message if no internet connection
  Widget noInternetMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 50,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 20),
          Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please check your internet connection and try again.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await checkInternetConnection();
              if (isConnected) {
                onTheLoad();
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: height * 0.01, left: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello, Vivek',
                      style: UiHelper.boldTextStyle(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.04),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.015),
                Text(
                  'Delicious Food',
                  style: UiHelper.headLineTextStyle(),
                ),
                Text(
                  'Discover and Get Great Food',
                  style: UiHelper.lightTextStyle(),
                ),
                SizedBox(height: height * 0.015),
                Container(
                  padding: EdgeInsets.only(right: width * 0.04),
                    height: height*0.24,
                    child: FoodCarouselSlider(),
                ),
                SizedBox(height: height * 0.015),
                Padding(
                  padding: EdgeInsets.only(right: width * 0.04),
                  child: showItem(width: width),
                ),
                SizedBox(height: height * 0.02),
                allItemsVertically(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Display food items vertically
  Widget allItemsVertically() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: foodItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!isConnected) {
          return noInternetMessage();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              'No food items found.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      detail: ds["Detail"],
                      name: ds["Name"],
                      price: ds["Price"],
                      image: ds["Image"],
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: width * 0.04, bottom: 20),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            ds["Image"],
                            height: width * 0.3,
                            width: width * 0.3,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: width * 0.3);
                            },
                          ),
                        ),
                        SizedBox(width: width * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["Name"],
                                style: UiHelper.boldTextStyle(),
                              ),
                              SizedBox(height: height * 0.005),
                              Text(
                                'Fresh and Healthy', // Optional: Add a description field in Firestore
                                style: UiHelper.lightTextStyle(),
                              ),
                              SizedBox(height: height * 0.005),
                              Text(
                                '\$' + ds["Price"],
                                style: UiHelper.boldTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Display category icons for filtering
  Widget showItem({required double width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            iceCream = true;
            pizza = false;
            salad = false;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Ice-cream");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: iceCream ? selectColor : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/icons/ice-cream-icon.png",
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            iceCream = false;
            pizza = true;
            salad = false;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Pizza");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: pizza ? selectColor : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/icons/pizzaIcon.png",
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            iceCream = false;
            pizza = false;
            salad = true;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Salad");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: salad ? selectColor : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/icons/saladIcon.png",
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            iceCream = false;
            pizza = false;
            salad = false;
            burger = true;
            foodItemStream = await DatabaseMethods().getFoodItem("Burger");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: burger ? selectColor : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/icons/burgerIcon.png",
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}