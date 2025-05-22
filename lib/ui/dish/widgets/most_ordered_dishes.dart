import 'package:flutter/material.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/dish/widgets/dish_card.dart';

class MostOrderedDishes extends StatelessWidget {
  final List<Dish> allDishes;
  final Restaurant restaurant;

  const MostOrderedDishes({
    required this.allDishes,
    required this.restaurant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Pega os 3 primeiros pratos
    final List<Dish> mostOrdered =
        allDishes.length >= 3 ? allDishes.sublist(0, 3) : allDishes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text('Mais pedidos', style: AppTextStyles.dishTitle),
        ),
        const SizedBox(height: 8),
        Column(
          children:
              mostOrdered
                  .map((dish) => DishCard(dish: dish, restaurant: restaurant))
                  .toList(),
        ),
      ],
    );
  }
}
