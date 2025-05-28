# Pasta `dish/`

Agrupa as telas e widgets relacionados aos pratos servidos pelos restaurantes.

| All Dishes Screen | Dish Details Screen | 
|-------------|------------------------|
| ![all dishes](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/all_dishes_screenshot.png) | ![dish details](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/dish_details_screenshot.png) |

---
## `all_dishes_screen.dart`

### Funcionalidade
Apresenta todos os pratos disponíveis de um restaurante específico. É acessada a partir da tela `RestaurantScreen` através do botão “Ver mais”.

### Decisão Técnica
A tela recebe a lista de pratos (`dishes`) e o restaurante correspondente como parâmetros, garantindo que o contexto da navegação seja mantido. Cada prato é renderizado com o widget `DishCard`, que encapsula a visualização de informações individuais de cada prato.

### Código comentado

```dart
// Tela com todos os pratos do restaurante
class AllDishesScreen extends StatelessWidget {
  final List<Dish> dishes;        // Lista de pratos a serem exibidos
  final Restaurant restaurant;    // Restaurante de origem dos pratos

  const AllDishesScreen({
    required this.dishes,
    required this.restaurant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos os pratos")),  // AppBar com título fixo
      body: ListView(
        children: dishes
            .map((dish) => DishCard(                          // Para cada prato, renderiza um DishCard
              dish: dish,
              restaurant: restaurant,
            ))
            .toList(),
      ),
    );
  }
}
```
---
## `dish_details_screen.dart`

### Funcionalidade
Define a tela inicial do aplicativo, exibindo o logotipo, mensagens de boas-vindas e um botão para navegar para a tela principal.

### Decisão Técnica

