# Pasta `dish/widgets/`

Contém os widgets de pratos mais pedidos e o DishCard de um prato (utilizado em algumas telas do app como a tela de Restaurante e nos resultados de busca).

---
## `most_ordered_dishes.dart`
Este widget define o componente MostOrderedDishes, responsável por exibir uma lista dos pratos mais pedidos de um restaurante. Como esse é um comportamendo mockado no app,  ele recebe uma lista completa de Dish e um Restaurant, e exibe no máximo os três primeiros pratos, utilizando o widget DishCard para a renderização visual.

### Funcionalidade

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
Exibe os detalhes completos de um prato selecionado, permitindo ao usuário ajustar a quantidade e adicioná-lo à sacola. Também reflete a quantidade previamente escolhida caso o usuário retorne de outra tela, como a sacola.

### Decisão Técnica
-  A tela é um `StatefulWidget` para manter e atualizar a quantidade escolhida dinamicamente
-  O estado escuta o `RouteObserver` para detectar quando o usuário retorna de uma rota sobreposta e atualizar a quantidade com base na sacola atual
-  A integração com o `BagProvider` (via Provider) permite gerenciar e sincronizar os dados da sacola
-  Uso de `RouteAware` para atualizar o estado quando o usuário retorna à tela
-  Uso de `MediaQuery` para ajustar dinamicamente o tamanho da imagem com base na altura da tela

### Código comentado

```dart
// Tela de detalhes de um prato
class DishDetailsScreen extends StatefulWidget {
  final Dish dish;              // Prato selecionado
  final Restaurant restaurant;  // Restaurante ao qual pertence

  const DishDetailsScreen({
    super.key,
    required this.dish,
    required this.restaurant,
  });

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> with RouteAware {
  int quantity = 1;            // Quantidade selecionada do prato
  bool hasInitialized = false; // Evita chamadas múltiplas no didChangeDependencies

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasInitialized) {
      _updateQuantityFromBag(); // Inicializa com a quantidade já adicionada na sacola (se houver)
      hasInitialized = true;
    }

    // Inscreve-se no observer de rotas
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute); // Escuta mudanças de rota
  }

  void _updateQuantityFromBag() {
    final bagProvider = Provider.of<BagProvider>(context, listen: false);
    final currentQty = bagProvider.getDishQuantity(widget.dish);
    if (currentQty > 0) {
      setState(() {
        quantity = currentQty;
      });
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // Evita vazamento de memória
    super.dispose();
  }

  @override
  void didPopNext() {
    _updateQuantityFromBag(); // Atualiza ao retornar de uma rota superior (como a sacola)
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context);

    return Scaffold(
      appBar: getAppBar(context: context, title: widget.restaurant.name), // AppBar personalizada
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/${widget.dish.imagePath}',
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            // Nome e preço
            Text(widget.dish.name, style: AppTextStyles.dishTitleBigger),
            const SizedBox(height: 2),
            Text(
              'R\$ ${widget.dish.price.toStringAsFixed(2)}',
              style: AppTextStyles.dishPriceBigger,
            ),
            const SizedBox(height: 2),
            Text(widget.dish.description, style: AppTextStyles.sectionTitle),
            const SizedBox(height: 10),

            // Seletor de quantidade
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: AppColors.mainColor),
                  onPressed: decreaseQuantity,
                ),
                Text(quantity.toString(), style: AppTextStyles.body),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.mainColor),
                  onPressed: increaseQuantity,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botão Adicionar à sacola
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: () {
                  bagProvider.updateDishQuantity(widget.dish, quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Atualizado na sacola')),
                  );
                },
                child: Text('Adicionar', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
