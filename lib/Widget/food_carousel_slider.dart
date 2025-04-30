import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FoodCarouselSlider extends StatelessWidget {
  final List<String> bannerImage=[
    'assets/images/banner/ice-cream-banner.jpg',
    'assets/images/banner/burger-banner.jpg',
    'assets/images/banner/pizza-banner.jpg',
    'assets/images/banner/salad-banner.jpg',
  ];

  FoodCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            autoPlayInterval:const Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: 16 / 9,
            initialPage: 0,
          ),
          items: bannerImage.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
