import 'package:flutter/material.dart';
import 'package:myapp/data/categories_data.dart';
import 'package:myapp/data/restaurant_data.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/model/widgets/appbar.dart';
import 'package:myapp/ui/home/widgets/category_widget.dart';
import 'package:myapp/ui/home/widgets/restaurant_widget.dart';
import 'package:myapp/ui/home/widgets/search_bar_widget.dart';
import 'package:myapp/ui/home/widgets/home_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    RestaurantData restaurantData = Provider.of<RestaurantData>(context);

    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: getAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25.0),
              Column(
                children: [
                  Center(child: Image.asset('assets/logo.png', width: 160)),
                  const SizedBox(height: 25.0),
                ],
              ),
              const Text(
                "Boas-vindas!",
                style: TextStyle(
                  color: AppColors.highlightTextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const SearchBarWidget(),
              const SizedBox(height: 24.0),
              const Text(
                "Escolha por categoria:",
                style: TextStyle(
                  color: AppColors.highlightTextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    CategoriesData.listCategories.length,
                    (index) {
                      final category = CategoriesData.listCategories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CategoryWidget(
                          category: category,
                          isSelected: selectedCategory == category,
                          onTap: () {
                            setState(() {
                              if (selectedCategory == category) {
                                selectedCategory = '';
                              } else {
                                selectedCategory = category;
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              Image.asset("assets/banners/banner_promo.png"),

              const SizedBox(height: 24.0),

              Text(
                selectedCategory.isEmpty
                    ? "Bem avaliados"
                    : "Resultados para: $selectedCategory",
                style: const TextStyle(
                  color: AppColors.highlightTextColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16.0),

              Column(
                children:
                    restaurantData.listRestaurant
                        .where((restaurant) {
                          if (selectedCategory.isEmpty) {
                            return restaurant.stars >= 4.0;
                          } else {
                            return restaurant.categories.contains(
                              selectedCategory,
                            );
                          }
                        })
                        .map(
                          (restaurant) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: RestaurantWidget(restaurant: restaurant),
                          ),
                        )
                        .toList(),
              ),

              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}
