import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

AppBar getAppBar({
  required BuildContext context,
  String? title,
  bool showBackButton = false,
  bool showBagIcon = true,
  List<Widget>? actions,
}) {
  BagProvider bagProvider = Provider.of<BagProvider>(context);

  // Lista de ações da AppBar
  final List<Widget> finalActions = [];

  // Adiciona ações personalizadas
  if (actions != null) {
    finalActions.addAll(actions);
  }

  // Adiciona o ícone da sacola, se habilitado
  if (showBagIcon) {
    finalActions.add(
      badges.Badge(
        showBadge: bagProvider.dishesOnBag.isNotEmpty,
        position: badges.BadgePosition.bottomStart(start: 0, bottom: 0),
        badgeContent: Text(
          bagProvider.dishesOnBag.length.toString(),
          style: const TextStyle(fontSize: 10),
        ),
        child: IconButton(
          icon: const Icon(Icons.shopping_basket),
          onPressed: () {
            final restaurant = bagProvider.selectedRestaurant;
            if (restaurant == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sua sacola está vazia')),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(restaurant: restaurant),
              ),
            );
          },
        ),
      ),
    );
  }

  return AppBar(
    leading:
        showBackButton
            ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
            : null,
    title: title != null ? Text(title) : null,
    centerTitle: true,
    actions: finalActions,
  );
}
