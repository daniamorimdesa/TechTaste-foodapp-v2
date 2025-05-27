# Pasta `restaurant/`

Contém a tela dedicada à visualização detalhada de um restaurante selecionado, incluindo seus pratos em destaque e o botão para ver o cardápio completo.

| Restaurant Screen | See more button | 
|-------------|------------------------|
| ![Restaurant](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/restaurant_screen.png) | ![See more button](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/see_more_button.PNG) |

---
## `restaurant_screen.dart`

### Funcionalidade

A `RestaurantScreen` é a tela dedicada à visualização de um restaurante específico selecionado na home. Sua função é exibir:

- A imagem do restaurante
- Os pratos mais pedidos (`MostOrderedDishes`)
- Um botão que leva à visualização completa do cardápio (`AllDishesScreen`)
  
### Decisão Técnica

- A navegação é feita com `MaterialPageRoute`, permitindo empilhar telas
- Utiliza um `ListView` para tornar a tela scrollável, especialmente útil em restaurantes com muitos pratos
- A imagem é exibida por meio do caminho estático armazenado no modelo `Restaurant`, permitindo fácil reuso e consistência visual
- O botão "Ver mais" está centralizado, com navegação clara e intuitiva para o usuário
- Todos os dados exibidos são passados via parâmetros da classe `Restaurant`, garantindo modularidade e flexibilidade

### Código comentado

```dart
import 'package:flutter/material.dart';
import 'package:myapp/model/restaurant.dart'; // Modelo de restaurante
import 'package:myapp/model/widgets/appbar.dart'; // AppBar customizada
import 'package:myapp/ui/dish/all_dishes_screen.dart'; // Tela com todos os pratos
import 'package:myapp/ui/dish/widgets/most_ordered_dishes.dart'; // Componente de pratos mais pedidos
import 'package:myapp/ui/restaurant/widgets/see_more_button.dart'; // Botão "Ver mais"

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant; // Restaurante selecionado

  const RestaurantScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizada com o nome do restaurante
      appBar: getAppBar(context: context, title: restaurant.name),

      // Conteúdo principal da tela
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Imagem do restaurante
          Image.asset('assets/${restaurant.imagePath}', height: 160),

          const SizedBox(height: 16),

          // Componente que exibe os pratos mais pedidos
          MostOrderedDishes(
            allDishes: restaurant.dishes,
            restaurant: restaurant,
          ),

          const SizedBox(height: 16),

          // Botão centralizado que leva à tela com todos os pratos
          Center(
            child: SeeMoreButton(
              onPressed: () {
                // Navegação para a tela AllDishesScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllDishesScreen(
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

```
---
# Pasta `restaurant/widgets/`

## `see_more_button.dart`

### Funcionalidade
O `SeeMoreButton` é um botão reutilizável exibido ao final da tela de um restaurante, permitindo ao usuário navegar para a tela com todos os pratos (`AllDishesScreen`) daquele restaurante.

### Decisão técnica
Optou-se por usar um `TextButton` estilizado com as cores do tema do app, aproveitando o `WidgetStateProperty.resolveWith` para alterar a cor do texto quando o botão está pressionado. Isso garante feedback visual sem a complexidade de criar um botão personalizado.


### Código comentado

```dart
// Botão de "ver mais" da tela de Restaurante
class SeeMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SeeMoreButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, // Ação executada ao clicar no botão
      style: ButtonStyle(
        // Define a cor do texto com base no estado do botão
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.pressedColor; // Cor ao pressionar
          }
          return AppColors.buttonsColor; // Cor normal
        }),
      ),
      child: const Text("Ver mais"), // Texto exibido no botão
    );
  }
}

