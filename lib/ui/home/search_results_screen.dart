import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/dish/widgets/dish_card.dart';
import 'package:myapp/ui/home/widgets/restaurant_widget.dart';
import 'package:myapp/data/restaurant_data.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<RestaurantData>(context);

    // Restaurantes cujo nome bate com a busca
    final filteredRestaurants =
        restaurantData.listRestaurant.where((restaurant) {
          return restaurant.name.toLowerCase().contains(query.toLowerCase());
        }).toList();

    // Criar lista de pares Dish + Restaurant para manter a referência
    final filteredDishCards =
        restaurantData.listRestaurant.expand((restaurant) {
          return restaurant.dishes
              .where(
                (dish) =>
                    dish.name.toLowerCase().contains(query.toLowerCase()) ||
                    dish.description.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .map((dish) => DishCard(dish: dish, restaurant: restaurant));
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultados para "$query"',
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (filteredRestaurants.isNotEmpty) ...[
            const Text(
              "Restaurantes encontrados",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.highlightTextColor,
              ),
            ),

            //Divider(color: AppColors.highlightTextColor),
            const SizedBox(height: 16),

            ...filteredRestaurants.map(
              (restaurant) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RestaurantWidget(restaurant: restaurant),
              ),
            ),
            Divider(color: AppColors.highlightTextColor),
            const SizedBox(height: 12),
          ],
          if (filteredDishCards.isNotEmpty) ...[
            const Text(
              "Pratos encontrados",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.highlightTextColor,
              ),
            ),

            //Divider(color: AppColors.highlightTextColor),
            const SizedBox(height: 12),

            ...filteredDishCards,
          ],
          if (filteredRestaurants.isEmpty && filteredDishCards.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text(
                  "Nenhum resultado encontrado.",
                  style: TextStyle(
                    color: AppColors.highlightTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
