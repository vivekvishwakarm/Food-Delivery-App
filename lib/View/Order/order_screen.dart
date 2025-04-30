import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Widget/ui_helper.dart';
import 'package:food_delivery_app/utils/colors.dart';
import '../../Controller/database.dart';
import '../../Controller/shared_prefe.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? id, wallet;
  int total = 0;
  Stream? foodStream;

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  Future<void> getTheSharedPref() async {
    try {
      id = await SharedPreferenceHelper().getUserId();
      wallet = await SharedPreferenceHelper().getUserWallet();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load user data: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> onTheLoad() async {
    await getTheSharedPref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No items in the cart."));
        }

        // Calculate total only once
        int calculatedTotal = 0;
        for (var doc in snapshot.data.docs) {
          calculatedTotal += int.parse(doc["Total"]);
        }
        total = calculatedTotal;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(ds["Quantity"])),
                      ),
                      const SizedBox(width: 20.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          ds["Image"],
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Name"],
                            style: UiHelper.semiBoldTextStyle(),
                          ),
                          Text(
                            "\$" + ds["Total"],
                            style: UiHelper.semiBoldTextStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> checkout() async {
    if (wallet == null || id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User data not loaded. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int walletAmount = int.tryParse(wallet!) ?? 0;
    if (walletAmount < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Insufficient wallet balance."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      int newWalletAmount = walletAmount - total;
      await DatabaseMethods().updateUserWallet(id!, newWalletAmount.toString());
      await SharedPreferenceHelper().saveUserWallet(newWalletAmount.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Checkout successful!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to checkout: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: white,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: Text(
                  "Food Cart",
                  style: UiHelper.headLineTextStyle(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: foodCart(),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: UiHelper.boldTextStyle(),
                  ),
                  Text(
                    "\$" + total.toString(),
                    style: UiHelper.semiBoldTextStyle().copyWith(color: buttonColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: checkout,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: const Center(
                  child: Text(
                    "CheckOut",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}