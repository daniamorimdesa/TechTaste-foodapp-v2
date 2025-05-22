import 'package:flutter/material.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/model/restaurant.dart';

class BagProvider extends ChangeNotifier {
  final Map<Dish, int> _dishesOnBag = {};
  Restaurant? _selectedRestaurant;

  Map<Dish, int> get items => _dishesOnBag;

  Restaurant? get selectedRestaurant => _selectedRestaurant;

  List<Dish> get dishesOnBag => _dishesOnBag.keys.toList();

  int getDishQuantity(Dish dish) => _dishesOnBag[dish] ?? 0;

  void addDish(Dish dish, int quantity, Restaurant restaurant) {
    if (_selectedRestaurant == null) {
      _selectedRestaurant = restaurant;
    } else if (_selectedRestaurant!.id != restaurant.id) {
      // Caso o restaurante seja diferente, limpamos a sacola
      clearBag();
      _selectedRestaurant = restaurant;
    }

    _dishesOnBag[dish] = (_dishesOnBag[dish] ?? 0) + quantity;
    notifyListeners();
  }

  void updateDishQuantity(Dish dish, int quantity) {
    if (quantity <= 0) {
      _dishesOnBag.remove(dish);
    } else {
      _dishesOnBag[dish] = quantity;
    }

    if (_dishesOnBag.isEmpty) {
      _selectedRestaurant = null;
    }

    notifyListeners();
  }

  void removeDish(Dish dish) {
    _dishesOnBag.remove(dish);

    if (_dishesOnBag.isEmpty) {
      _selectedRestaurant = null;
    }

    notifyListeners();
  }

  void incrementDish(Dish dish) {
    final current = getDishQuantity(dish);
    updateDishQuantity(dish, current + 1);
  }

  void decrementDish(Dish dish) {
    final current = getDishQuantity(dish);
    if (current > 1) {
      updateDishQuantity(dish, current - 1);
    } else {
      removeDish(dish);
    }
  }

  void clearBag() {
    _dishesOnBag.clear();
    _selectedRestaurant = null;
    notifyListeners();
  }

  double getSubtotal() {
    double subtotal = 0.0;
    _dishesOnBag.forEach((dish, quantity) {
      subtotal += dish.price * quantity;
    });
    return subtotal;
  }

  Map<Dish, int> getMapbyAmount() => Map.from(_dishesOnBag);
}
