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
