# Pasta `dish/widgets/`

Contém os widgets de "pratos mais pedidos" e o `DishCard` de um prato (utilizado em algumas telas do app como a tela de Restaurante e nos resultados de busca).

| MostOrderedDishes na Restaurant Screen | DishCard | 
|-------------|-------------|
| ![most ordered dishes example](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/restaurant_screen.png) | ![dish card example](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/dish_card_screenshot.PNG)|

---
## `most_ordered_dishes.dart`
Este widget define o componente `MostOrderedDishes`, responsável por exibir uma lista dos pratos mais pedidos de um restaurante. Como esse é um comportamendo mockado no app,  ele recebe uma lista completa de `Dish` e um `Restaurant`, e exibe no máximo os três primeiros pratos, utilizando o widget DishCard para a renderização visual.

### Funcionalidade
- Recebe todos os pratos disponíveis (`allDishes`) e um restaurante associado.
- Exibe, no máximo, três pratos — representando os “mais pedidos”.
- Utiliza o componente `DishCard` para apresentar cada prato.
- Adiciona um título "Mais pedidos" estilizado acima da lista.
  
### Decisão Técnica
- A lógica de mock para os "mais pedidos" foi implementada com um simples `sublist`, o que permite fácil substituição futura por uma lógica real baseada em dados de pedidos.
- A escolha de um `Column` para exibição vertical dos `DishCard` segue o padrão visual do app, além de permitir expansão automática com o conteúdo.

### Código comentado

```dart
// Componente que simula pratos mais pedidos
class MostOrderedDishes extends StatelessWidget {
  final List<Dish> allDishes;  // Lista completa de pratos disponíveis
  final Restaurant restaurant; // Restaurante ao qual os pratos pertencem

  const MostOrderedDishes({
    required this.allDishes,
    required this.restaurant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Seleciona os 3 primeiros pratos, se houver pelo menos 3
    final List<Dish> mostOrdered =
        allDishes.length >= 3 ? allDishes.sublist(0, 3) : allDishes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text('Mais pedidos', style: AppTextStyles.dishTitle),
        ),
        const SizedBox(height: 8),
        
        // Lista dos pratos mais pedidos usando o DishCard
        Column(
          children: mostOrdered
              .map((dish) => DishCard(dish: dish, restaurant: restaurant))
              .toList(),
        ),
      ],
    );
  }
}

```
---
## `dish_card.dart`
Este widget define o componente `DishCard`, responsável por exibir um prato em forma de card interativo. Ele é usado em diversas telas do app, como a tela de restaurante e resultados de busca, e permite ao usuário visualizar detalhes do prato, bem como adicioná-lo ou removê-lo do carrinho.

![dish card example](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/dish_card_screenshot.PNG)

### Funcionalidade
- Exibe informações completas de um prato (`Dish`): imagem, nome, preço e descrição
- Permite que o usuário adicione ou remova o prato diretamente do card, integrando-se com o `BagProvider`
- Se clicado, abre a tela de detalhes (`DishDetailsScreen`) para mais informações do prato
- Exibe a quantidade atual do prato no carrinho, com ícones para incrementar ou decrementar

### Decisão Técnica
- Foi usado `InkWell` para tornar o card clicável e responsivo
- A imagem do prato é carregada localmente de `assets/`, com `BoxFit.cover` para preencher a largura do card
- A renderização condicional (`quantity == 0 ? ... : ...`) permite alternar entre o botão de "adicionar" e o controle de quantidade no carrinho
- O uso de `context.watch<BagProvider>()` garante que as mudanças no estado da sacola reflitam automaticamente no card

### Código comentado

```dart
// Card de um prato
class DishCard extends StatelessWidget {
  final Dish dish;             // O prato a ser exibido
  final Restaurant restaurant; // Restaurante ao qual o prato pertence

  const DishCard({super.key, required this.dish, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final bagProvider = context.watch<BagProvider>();   // Estado da sacola
    final quantity = bagProvider.getDishQuantity(dish); // Quantidade no carrinho

    return InkWell(
      onTap: () {
        // Abre a tela de detalhes do prato
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishDetailsScreen(
              dish: dish,
              restaurant: restaurant,
            ),
          ),
        );
      },
      child: Card(
        color: AppColors.backgroundCardTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do prato
            Image.asset(
              'assets/${dish.imagePath}',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Conteúdo textual e botões
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Linha superior: nome do prato e controle de quantidade
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
                                // Adiciona o prato ao carrinho
                                bagProvider.addDish(
                                  dish,
                                  quantity + 1,
                                  restaurant,
                                );
                              },
                            )
                          : Row(
                              children: [
                                // Botão para remover uma unidade
                                IconButton(
                                  icon:
                                      const Icon(Icons.remove_circle_outline),
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
                                // Quantidade atual no carrinho
                                Text(
                                  '$quantity',
                                  style: AppTextStyles.dishPrice.copyWith(
                                    color: AppColors.mainColor,
                                  ),
                                ),
                                // Botão para adicionar mais uma unidade
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
                  // Preço do prato
                  Text(
                    "R\$ ${dish.price.toStringAsFixed(2)}",
                    style: AppTextStyles.dishPrice,
                  ),
                  const SizedBox(height: 6),
                  // Descrição do prato
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
