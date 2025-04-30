import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/colors.dart';
import '../../Widget/ui_helper.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController amountController = TextEditingController();
  bool _isLoading = false; // Added loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Material(
                  elevation: 2.0,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: Text(
                        "Wallet",
                        style: UiHelper.headLineTextStyle(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),

                // Wallet Balance Section
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/wallet.png",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 40.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Wallet",
                            style: UiHelper.lightTextStyle(),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "\$1000", // Static wallet balance for UI
                            style: UiHelper.boldTextStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Add Money Section
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Add money",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAmountButton("100"),
                    _buildAmountButton("500"),
                    _buildAmountButton("1000"),
                    _buildAmountButton("2000"),
                  ],
                ),
                const SizedBox(height: 50.0),

                // Add Money Button
                GestureDetector(
                  onTap: () {
                    // Open dialog to enter custom amount
                    openEdit();
                  },
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      width: MediaQuery.of(context).size.width,
                      height:  MediaQuery.of(context).size.height*0.058,
                      decoration: BoxDecoration(
                        // color: const Color(0xFF008080),
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  // Amount Button Widget
  Widget _buildAmountButton(String amount) {
    return GestureDetector(
      onTap: () {
        // Handle amount button tap
        setState(() {
          _isLoading = true; // Show loading indicator
        });

        // Simulate a delay for loading
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE9E2E2)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          "\$" + amount,
          style: UiHelper.semiBoldTextStyle(),
        ),
      ),
    );
  }

  // Open Dialog to Enter Custom Amount
  Future<void> openEdit() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.cancel),
                  ),
                  const SizedBox(width: 60.0),
                  const Center(
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Amount Input Field
              const Text("Amount"),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20.0),

              // Pay Button
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _isLoading = true; // Show loading indicator
                    });

                    // Simulate a delay for loading
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        _isLoading = false; // Hide loading indicator
                      });
                    });
                  },
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008080),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Pay",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}