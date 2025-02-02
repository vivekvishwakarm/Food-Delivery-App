import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Controller/database.dart';

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

  Stream? foodItemStream;

  onTheLoad() async {
    foodItemStream = await DatabaseMethods().getFoodItem("Pizza");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onTheLoad();
  }

  Widget allItemsVertically() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: foodItemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Details(detail: ds["Details"],name: ds["Name"],price: ds["Price"],image: ds["Image"],),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: width * 0.04,bottom: 20),
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
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mediterranean\nChickped Salad',
                                      style: UiHelper.boldTextStyle(),
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Text(
                                      ds["Name"],
                                      style: UiHelper.lightTextStyle(),
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Text(
                                      '\$'+ds["Price"],
                                      style: UiHelper.boldTextStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget allItems() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: foodItemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Details(detail: ds["Details"],name: ds["Name"],price: ds["Price"],image: ds["Image"],),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ds["Image"],
                                    height: width * 0.4,
                                    width: width * 0.4,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  ds["Name"],
                                  style: UiHelper.semiBoldTextStyle(),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Text(
                                  'Fresh and Healthy',
                                  style: UiHelper.lightTextStyle(),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Text(
                                  '\$' + ds["Price"],
                                  style: UiHelper.semiBoldTextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              :  const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
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
                          color: black,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Text(
                  'Delicious Food',
                  style: UiHelper.headLineTextStyle(),
                ),
                Text(
                  'Discover and Get Great Food',
                  style: UiHelper.lightTextStyle(),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.only(right: width * 0.04),
                  child: showItem(width: width),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: 300,
                  child: allItems(),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                allItemsVertically()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showItem({required double width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector (
          onTap: () async{
                iceCream = true;
                pizza = false;
                salad = false;
                burger = false;
                foodItemStream = await DatabaseMethods().getFoodItem("Ice-cream");
              setState(() {

              });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: iceCream ? black : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/ice-cream.png",
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
                color: iceCream ? white : black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream = false;
            pizza = true;
            salad = false;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Pizza");
            setState(
              () {

              },
            );
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: pizza ? black : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/pizza.png',
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
                color: pizza ? white : black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream = false;
            pizza = false;
            salad = true;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Salad");
            setState(
              () {

              },
            );
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: salad ? black : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/salad.png',
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
                color: salad ? white : black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream = false;
            pizza = false;
            salad = false;
            burger = true;
            foodItemStream = await DatabaseMethods().getFoodItem("Burger");
            setState(
              () {

              },
            );
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: burger ? black : white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/burger.png',
                height: width * 0.1,
                width: width * 0.1,
                fit: BoxFit.cover,
                color: burger ? white : black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
