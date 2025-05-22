import 'package:flutter/material.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/model/widgets/appbar.dart';
import 'package:myapp/ui/dish/all_dishes_screen.dart';
import 'package:myapp/ui/dish/widgets/most_ordered_dishes.dart';
import 'package:myapp/ui/restaurant/widgets/see_more_button.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context: context, title: restaurant.name),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Image.asset('assets/${restaurant.imagePath}', height: 160),
          const SizedBox(height: 16),
          MostOrderedDishes(
            allDishes: restaurant.dishes,
            restaurant: restaurant,
          ),
          const SizedBox(height: 16),
          Center(
            child: SeeMoreButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AllDishesScreen(
                          dishes: restaurant.dishes,
                          restaurant: restaurant,
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
