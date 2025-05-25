# Pasta `data/`

A pasta `data/` concentra os arquivos responsáveis por armazenar ou carregar informações utilizadas no app. São dados simulados (mock) para uso local durante o desenvolvimento.

---

## `categories_data.dart`

### Funcionalidade

Esse arquivo centraliza a lista de categorias que aparecem no filtro da tela inicial. Ele funciona como um "repositório estático" de categorias, o que evita a repetição dessas strings em diferentes pontos do app.

### Decisão técnica

Optar por uma classe `abstract` com uma `List<String>` estática permite que outras partes da aplicação acessem esses dados de forma simples e direta, sem a necessidade de instanciar a classe.

### Código comentado

```dart
// categories_data.dart

// Classe abstrata que armazena uma lista fixa de categorias.
// Essas categorias são utilizadas, por exemplo, na Home, para filtrar os pratos.

abstract class CategoriesData {
  // Lista de categorias disponíveis no app
  static List<String> listCategories = [
    "Petiscos",
    "Principais",
    "Massas",
    "Sobremesas",
    "Bebidas",
  ];
}
```
---

## `restaurant_data.dart`

### Funcionalidade
Este arquivo define uma classe que carrega dinamicamente os dados dos restaurantes a partir de um arquivo JSON localizado em `assets/data.json`.
Ele também transforma os dados do JSON em objetos do tipo `Restaurant`.

### Decisão técnica
- A classe herda de `ChangeNotifier` pois futuramente pode ser conectada a um gerenciador de estado (como `Provider`);
- A leitura do JSON foi feita com `rootBundle.loadString`, método comum em apps Flutter que usam arquivos locais.

### Código comentado

```dart
// restaurant_data.dart

import 'dart:convert'; // Para decodificar o JSON
import 'package:flutter/material.dart'; // Para usar ChangeNotifier
import 'package:flutter/services.dart'; // Para acessar arquivos do bundle (assets)
import 'package:myapp/model/restaurant.dart'; // Importa o model Restaurant

// Classe que gerencia a lista de restaurantes do app
class RestaurantData extends ChangeNotifier {
  // Lista de objetos Restaurant que será populada
  List<Restaurant> listRestaurant = [];

  // Método para carregar os dados do arquivo JSON localizado em assets/data.json
  Future<void> getRestaurants() async {
    // Carrega o conteúdo do arquivo como string
    String jsonString = await rootBundle.loadString('assets/data.json');

    // Decodifica a string para um mapa
    Map<String, dynamic> data = json.decode(jsonString);

    // Extrai a lista de restaurantes
    List<dynamic> restaurantsData = data['restaurants'];

    // Transforma cada item da lista em um objeto Restaurant e adiciona à lista
    for (var restaurantData in restaurantsData) {
      listRestaurant.add(Restaurant.fromMap(restaurantData));
    }
  }
}

```
---
## Conclusão
A pasta `data/` contém os dados essenciais que alimentam a interface do aplicativo. A separação clara entre dados estáticos (`categories_data.dart`) e dados carregados dinamicamente (`restaurant_data.dart`) torna o projeto mais organizado e facilita a evolução para uma futura conexão com um backend real.
