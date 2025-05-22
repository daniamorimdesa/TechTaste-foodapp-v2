import 'package:flutter/material.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/dish/dish_details_screen.dart';
import 'package:provider/provider.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  final Restaurant restaurant;

  const DishCard({super.key, required this.dish, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final bagProvider = context.watch<BagProvider>();
    final quantity = bagProvider.getDishQuantity(dish);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    DishDetailsScreen(dish: dish, restaurant: restaurant),
          ),
        );
      },
      child: Card(
        color: AppColors.backgroundCardTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/${dish.imagePath}',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dish.name,
                          style: AppTextStyles.dishTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      quantity == 0
                          ? IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              bagProvider.addDish(
                                dish,
                                quantity + 1,
                                restaurant,
                              );
                            },
                          )
                          : Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (quantity > 1) {
                                    bagProvider.updateDishQuantity(
                                      dish,
                                      quantity - 1,
                                    );
                                  } else {
                                    bagProvider.removeDish(dish);
                                  }
                                },
                              ),
                              Text(
                                '$quantity',
                                style: AppTextStyles.dishPrice.copyWith(
                                  color: AppColors.mainColor,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  bagProvider.addDish(
                                    dish,
                                    quantity + 1,
                                    restaurant,
                                  );
                                },
                              ),
                            ],
                          ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "R\$ ${dish.price.toStringAsFixed(2)}",
                    style: AppTextStyles.dishPrice,
                  ),
                  const SizedBox(height: 6),
                  Text(dish.description, style: AppTextStyles.body),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
