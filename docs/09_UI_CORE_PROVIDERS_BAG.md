# `BagProvider` – Gerenciamento da sacola de pedidos
O `BagProvider` é uma classe do tipo `ChangeNotifier` que gerencia o estado da sacola de compras do usuário. Ele centraliza a lógica de adição, remoção e atualização de pratos pedidos, além de manter o contexto do restaurante selecionado.

---

## Objetivo
Permitir que o usuário adicione pratos à sacola, mantenha um controle de quantidades e preços, e garanta que os itens sejam todos do mesmo restaurante. Isso facilita o processo de checkout e evita pedidos mistos entre restaurantes.

---

## Principais responsabilidades

| Método                 | Função                                                                 |
|------------------------|------------------------------------------------------------------------|
| `addDish()`            | Adiciona um prato à sacola. Limpa a sacola se o restaurante for diferente. |
| `updateDishQuantity()` | Atualiza a quantidade de um prato. Remove se a quantidade for zero.    |
| `removeDish()`         | Remove o prato especificado da sacola.                                 |
| `incrementDish()`      | Aumenta a quantidade de um prato na sacola.                            |
| `decrementDish()`      | Diminui a quantidade e remove se chegar a zero.                        |
| `clearBag()`           | Esvazia completamente a sacola.                                        |
| `getSubtotal()`        | Retorna o valor total com base na soma dos pratos e quantidades.       |

---

## Estrutura interna

- `Map<Dish, int> _dishesOnBag` : Armazena os pratos selecionados e suas quantidades.  
- `Restaurant? _selectedRestaurant` : Define o restaurante atual da sacola. Impede misturar pedidos de diferentes restaurantes.

---

## Getters úteis

| Getter              | Retorno                                         |
|---------------------|-------------------------------------------------|
| `items`             | Mapa completo de pratos e quantidades.         |
| `selectedRestaurant`| Restaurante associado à sacola atual.          |
| `dishesOnBag`       | Lista com todos os pratos adicionados.         |
| `getDishQuantity()` | Quantidade de um prato específico.             |
| `getMapbyAmount()`  | Retorna um novo mapa com os itens da sacola.   |
| `getSubtotal()`     | Soma total da sacola.                          |

---

## Reatividade

A classe estende `ChangeNotifier`, o que permite que a UI reaja automaticamente a mudanças. Sempre que a sacola é alterada, `notifyListeners()` é chamado, garantindo que as telas dependentes sejam reconstruídas com os dados atualizados.

---

## Código comentado

```dart
// Provider responsável por gerenciar o estado da sacola de pedidos (bag)
class BagProvider extends ChangeNotifier {

  final Map<Dish, int> _dishesOnBag = {};     // Mapa que associa cada prato à sua quantidade na sacola
  Restaurant? _selectedRestaurant;            // Restaurante atualmente selecionado para os pedidos da sacola

  Map<Dish, int> get items => _dishesOnBag;   // Getter para acessar os itens da sacola com suas quantidades

  Restaurant? get selectedRestaurant => _selectedRestaurant;   // Getter para o restaurante atual

  List<Dish> get dishesOnBag => _dishesOnBag.keys.toList();    // Retorna a lista de pratos únicos adicionados à sacola

  int getDishQuantity(Dish dish) => _dishesOnBag[dish] ?? 0;   // Retorna a quantidade de um prato específico na sacola

  // Adiciona um prato à sacola, respeitando o restaurante selecionado
  void addDish(Dish dish, int quantity, Restaurant restaurant) {
    if (_selectedRestaurant == null) {
      // Se ainda não há restaurante selecionado, define o atual
      _selectedRestaurant = restaurant;
    } else if (_selectedRestaurant!.id != restaurant.id) {
      // Se o restaurante mudou, limpa a sacola antes de adicionar o novo prato
      clearBag();
      _selectedRestaurant = restaurant;
    }

    // Incrementa a quantidade do prato (ou define, se for a primeira vez)
    _dishesOnBag[dish] = (_dishesOnBag[dish] ?? 0) + quantity;

    // Notifica os listeners para atualizar a interface
    notifyListeners();
  }

  // Atualiza diretamente a quantidade de um prato específico
  void updateDishQuantity(Dish dish, int quantity) {
    if (quantity <= 0) {
      // Se a quantidade for 0 ou negativa, remove o prato
      _dishesOnBag.remove(dish);
    } else {
      // Caso contrário, atualiza o valor
      _dishesOnBag[dish] = quantity;
    }

    // Se a sacola ficar vazia, reseta o restaurante selecionado
    if (_dishesOnBag.isEmpty) {
      _selectedRestaurant = null;
    }

    notifyListeners();
  }

  // Remove um prato da sacola completamente
  void removeDish(Dish dish) {
    _dishesOnBag.remove(dish);

    // Se a sacola estiver vazia após a remoção, limpa o restaurante
    if (_dishesOnBag.isEmpty) {
      _selectedRestaurant = null;
    }

    notifyListeners();
  }

  // Incrementa a quantidade de um prato em +1
  void incrementDish(Dish dish) {
    final current = getDishQuantity(dish);
    updateDishQuantity(dish, current + 1);
  }

  // Decrementa a quantidade de um prato em -1, removendo se chegar a 0
  void decrementDish(Dish dish) {
    final current = getDishQuantity(dish);
    if (current > 1) {
      updateDishQuantity(dish, current - 1);
    } else {
      removeDish(dish);
    }
  }

  // Limpa todos os itens da sacola e o restaurante selecionado
  void clearBag() {
    _dishesOnBag.clear();
    _selectedRestaurant = null;
    notifyListeners();
  }

  // Calcula o subtotal com base nos pratos e suas quantidades
  double getSubtotal() {
    double subtotal = 0.0;
    _dishesOnBag.forEach((dish, quantity) {
      subtotal += dish.price * quantity;
    });
    return subtotal;
  }

  // Retorna uma cópia do mapa de pratos e quantidades
  Map<Dish, int> getMapbyAmount() => Map.from(_dishesOnBag);
}
