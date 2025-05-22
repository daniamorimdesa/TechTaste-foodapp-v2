import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/account/account_screen.dart';
import 'package:myapp/ui/checkout/checkout_screen.dart';
import 'package:myapp/ui/home/widgets/home_drawer_button.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundCardTextColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeDrawerButton(
                text: 'Menu',
                onPressed: null, // apenas visual
                normalColor: AppColors.backgroundCardTextColor,
                pressedColor: AppColors.backgroundCardTextColor,
                textColor: AppColors.buttonsColor,
                pressedTextColor: AppColors.cardTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 20),
              HomeDrawerButton(
                text: 'Sacola',
                onPressed: () {
                  final restaurant =
                      context.read<BagProvider>().selectedRestaurant;
                  if (restaurant != null) {
                    Navigator.of(context).pop(); // fecha o drawer
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => CheckoutScreen(restaurant: restaurant),
                      ),
                    );
                  } else {
                    // pode exibir uma snackbar ou alerta
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sua sacola está vazia')),
                    );
                  }
                },

                normalColor: AppColors.backgroundCardTextColor,
                pressedColor: AppColors.buttonsColor,
                textColor: AppColors.cardTextColor,
                pressedTextColor: AppColors.backgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 20),
              HomeDrawerButton(
                text: 'Minha conta',
                onPressed: () {
                  Navigator.pop(context); // fecha o drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AccountScreen()),
                  );
                },
                normalColor: AppColors.backgroundCardTextColor,
                pressedColor: AppColors.buttonsColor,
                textColor: AppColors.cardTextColor,
                pressedTextColor: AppColors.backgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
