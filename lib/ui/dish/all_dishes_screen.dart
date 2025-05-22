import 'package:flutter/material.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/ui/dish/widgets/dish_card.dart';

class AllDishesScreen extends StatelessWidget {
  final List<Dish> dishes;
  final Restaurant restaurant;

  const AllDishesScreen({
    required this.dishes,
    required this.restaurant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos os pratos")),
      body: ListView(
        children:
            dishes
                .map((dish) => DishCard(dish: dish, restaurant: restaurant))
                .toList(),
      ),
    );
  }
}
