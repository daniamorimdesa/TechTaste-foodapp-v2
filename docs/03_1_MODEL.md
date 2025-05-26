# Pasta `model/`

A pasta model/ concentra as definições das estruturas de dados utilizadas no app. Cada modelo representa uma entidade essencial da aplicação, como usuários, endereços, restaurantes, pratos e formas de pagamento.

---

## `address.dart`

### Funcionalidade
Representa o endereço de entrega utilizado pelo usuário no momento do pedido.

### Decisão técnica
- Modelo imutável com `const constructor`;
- Possui método `copyWith` para facilitar modificações parciais;
- `get fullAddress` retorna uma string formatada para exibição.

### Código comentado

```dart
// Classe que representa o endereço de entrega do usuário
class Address {
  // Atributos que compõem um endereço completo:
  String street;        // Rua
  String number;        // Número da residência
  String neighborhood;  // Bairro
  String city;          // Cidade
  String state;         // Estado
  String cep;           // Código postal (CEP)
  String label;         // Rótulo do endereço, como "Casa" ou "Trabalho"
  String description;   // Descrição complementar, como "Apto 302"
  bool isPrimary;       // Indica se é o endereço principal

  // Construtor com parâmetros obrigatórios e `isPrimary` com valor padrão `false`
  Address({
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.cep,
    required this.label,
    required this.description,
    this.isPrimary = false,
  });

  // Construtor que retorna um endereço "vazio" (útil para inicializações)
  factory Address.empty() {
    return Address(
      street: '',
      number: '',
      neighborhood: '',
      city: '',
      state: '',
      cep: '',
      label: '',
      description: '',
      isPrimary: false,
    );
  }

  // Getter que retorna o endereço completo formatado para exibição
  String get fullAddress {
    // Adiciona a descrição, caso exista.
    final desc = description.isNotEmpty ? ', $description' : '';

    // Formata todos os campos como uma única string.
    return '$street, $number - $neighborhood, $city - $state, $cep ($label)$desc';
  }

  // Método que cria uma nova instância de Address com campos atualizados opcionalmente
  Address copyWith({
    String? street,
    String? number,
    String? neighborhood,
    String? city,
    String? state,
    String? cep,
    String? label,
    String? description,
    bool? isPrimary,
  }) {
    return Address(
      street: street ?? this.street,
      number: number ?? this.number,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      cep: cep ?? this.cep,
      label: label ?? this.label,
      description: description ?? this.description,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  // Sobrescreve o operador de igualdade para comparar objetos Address por valor
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.street == street &&
        other.number == number &&
        other.neighborhood == neighborhood &&
        other.city == city &&
        other.state == state &&
        other.cep == cep &&
        other.label == label &&
        other.description == description &&
        other.isPrimary == isPrimary;
  }

  // Gera um hash code consistente com os campos utilizados na comparação
  @override
  int get hashCode {
    return Object.hash(
      street,
      number,
      neighborhood,
      city,
      state,
      cep,
      label,
      description,
      isPrimary,
    );
  }
}

```
---
## `credit_card.dart`

### Funcionalidade
Representa um cartão de crédito salvo pelo usuário para facilitar o pagamento de pedidos.

### Decisão técnica
- Modelo com atributos imutáveis (`final`);
- Inclui método `copyWith` para permitir modificações pontuais;
- `maskedNumber` retorna a versão mascarada do número do cartão para exibição segura.

### Código comentado

```dart
// Classe que representa um cartão de crédito armazenado
class CreditCard {
  final String cardName;     // Nome impresso no cartão
  final String last4Digits;  // Últimos 4 dígitos do cartão (ex: "1234")
  final String expiryDate;   // Data de validade no formato MM/AA
  final String brand;        // Bandeira do cartão (Visa, Mastercard, etc.)
  final bool isPrimary;      // Indica se é o cartão principal

  // Construtor com todos os campos obrigatórios, exceto `isPrimary` que é opcional com valor padrão `false`
  CreditCard({
    required this.cardName,
    required this.last4Digits,
    required this.expiryDate,
    required this.brand,
    this.isPrimary = false,
  });

  // Getter que retorna o número do cartão mascarado, exibindo apenas os últimos 4 dígitos
  String get maskedNumber => '•••• •••• •••• $last4Digits';

  // Método que retorna uma nova instância de CreditCard com campos modificados opcionalmente
  CreditCard copyWith({
    String? cardName,
    String? last4Digits,
    String? expiryDate,
    String? brand,
    bool? isPrimary,
  }) {
    return CreditCard(
      cardName: cardName ?? this.cardName,
      last4Digits: last4Digits ?? this.last4Digits,
      expiryDate: expiryDate ?? this.expiryDate,
      brand: brand ?? this.brand,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  // Sobrescreve o operador de igualdade para comparação por valor
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreditCard &&
          runtimeType == other.runtimeType &&
          cardName == other.cardName &&
          last4Digits == other.last4Digits &&
          expiryDate == other.expiryDate &&
          brand == other.brand &&
          isPrimary == other.isPrimary;

  // Gera o hash code baseado nos campos do cartão
  @override
  int get hashCode =>
      cardName.hashCode ^
      last4Digits.hashCode ^
      expiryDate.hashCode ^
      brand.hashCode ^
      isPrimary.hashCode;
}

```
---
## `dish.dart`

### Funcionalidade
Representa um prato individual disponível no cardápio de um restaurante, com suas informações principais como nome, descrição, preço e imagem.

### Decisão técnica
- Modelo simples e direto para representar dados de um prato;
- Inclui métodos `toMap` e `fromMap` para facilitar serialização/desserialização (por exemplo, ao salvar ou carregar de um banco de dados ou API);
- Sobrescreve `toString` para facilitar o debug e exibição.

### Código comentado

```dart
// Classe que representa um prato do cardápio de um restaurante
class Dish {
  final String id;  // Identificador único do prato (pode ser usado para busca ou comparação)
  final String name; // Nome do prato 
  final String description;  // Descrição detalhada do prato 
  final int price; // Preço do prato
  final String imagePath;  // Caminho da imagem ilustrativa do prato
  final String restaurantName;  // Nome do restaurante ao qual o prato pertence

  // Construtor com todos os campos obrigatórios
  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.restaurantName,
  });

  // Converte o objeto Dish em um mapa (útil para armazenamento em banco de dados, etc.)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'restaurantName': restaurantName,
    };
  }

  // Cria um objeto Dish a partir de um mapa (útil para leitura de banco de dados ou JSON)
  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imagePath: map['imagePath'],
      restaurantName: map['restaurantName'],
    );
  }

  // Sobrescreve a representação em string do objeto para facilitar o debug e a leitura
  @override
  String toString() {
    return 'Dish{id: $id, name: $name, description: $description, price: $price, imagePath: $imagePath, restaurantName: $restaurantName}';
  }
}

```
