import 'package:flutter/material.dart';
import 'package:food_delivery_app/Widget/ui_helper.dart';
import 'package:food_delivery_app/utils/colors.dart';
import '../../Controller/database.dart';
import '../../Controller/shared_prefe.dart';

class Details extends StatefulWidget {
  final String image, name, detail, price;

  const Details({
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
    super.key,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;
  int total = 0;
  String? userId;
  bool isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getUserId();
    total = int.parse(widget.price); // Safely parse the price
  }

  Future<void> _getUserId() async {
    userId = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  void _updateQuantity(bool isIncrement) {
    setState(() {
      if (isIncrement) {
        quantity++;
        total += int.tryParse(widget.price) ?? 0;
      } else {
        if (quantity > 1) {
          quantity--;
          total -= int.tryParse(widget.price) ?? 0;
        }
      }
    });
  }

  Future<void> _addToCart() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "User not logged in. Please log in to add items to the cart."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isAddingToCart = true;
    });

    try {
      Map<String, dynamic> addFoodToCart = {
        "Name": widget.name,
        "Quantity": quantity.toString(),
        "Total": total.toString(),
        "Image": widget.image,
      };

      await DatabaseMethods().addFoodToCart(addFoodToCart, userId!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Food added to cart!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add to cart: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: const Text("Detail"),
        centerTitle: true,
        leading: _buildBackButton(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Padding(
              padding:  const EdgeInsets.only(right: 15),
              child:  Icon(
                Icons.favorite_border,
                color: buttonColor,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top:10,left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize:
          //     MainAxisSize.min, // Ensure the Column doesn't expand infinitely
          children: [
            _buildFoodImage(),
            const SizedBox(height: 15.0),
            _buildFoodNameAndQuantity(),
            const SizedBox(height: 20.0),
            _buildFoodDescription(),
            const SizedBox(height: 30.0),
            _buildDeliveryTime(),
            const Spacer(),
            _buildAddToCartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(
        Icons.arrow_back_ios_new_outlined,
        color: Colors.black,
      ),
    );
  }

  Widget _buildFoodImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        widget.image,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.5,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFoodNameAndQuantity() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.name,
            style: UiHelper.semiBoldTextStyle(),
          ),
        ),
        _buildQuantityControl(),
      ],
    );
  }

  Widget _buildQuantityControl() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _updateQuantity(false),
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Text(
          quantity.toString(),
          style: UiHelper.semiBoldTextStyle(),
        ),
        const SizedBox(width: 20.0),
        GestureDetector(
          onTap: () => _updateQuantity(true),
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodDescription() {
    return Text(
      widget.detail,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: UiHelper.lightTextStyle(),
    );
  }

  Widget _buildDeliveryTime() {
    return Row(
      children: [
        Text(
          "Delivery Time",
          style: UiHelper.semiBoldTextStyle(),
        ),
        const SizedBox(width: 25.0),
         Icon(
          Icons.alarm,
          color: buttonColor,
        ),
        const SizedBox(width: 5.0),
        Text(
          "30 min",
          style: UiHelper.semiBoldTextStyle(),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Price",
                style: UiHelper.semiBoldTextStyle(),
              ),
              Text(
                "\$$total",
                style: UiHelper.headLineTextStyle().copyWith(color: buttonColor),
              ),
            ],
          ),
          GestureDetector(
            onTap: isAddingToCart ? null : _addToCart,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    isAddingToCart ? "Adding..." : "Add to cart",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
