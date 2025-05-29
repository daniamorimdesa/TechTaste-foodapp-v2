# `UserDataProvider` – Gerenciamento de dados do usuário
O `UserDataProvider` é uma classe do tipo `ChangeNotifier` responsável por armazenar e gerenciar informações pessoais do usuário, incluindo dados cadastrais, endereços, métodos de pagamento e preferências de pagamento selecionadas no aplicativo. Esse provider atua como uma fonte única para dados persistentes e sensíveis ao contexto do usuário, garantindo que qualquer modificação seja automaticamente propagada à interface por meio de notificações reativas.

---

## Objetivo
Manter e centralizar os dados pessoais e financeiros do usuário durante o uso do app, incluindo:
- Dados básicos (nome completo, CPF, telefone)
- Lista de endereços (com endereço principal)
- Lista de cartões de crédito (com cartão principal)
- Métodos de pagamento selecionados (Pix, cartão, dinheiro)

---

## Principais responsabilidades

| Função | Descrição |
| --- | --- |
| `updateFullName()` | Atualiza o nome completo do usuário. |
| `updateCPF()` | Define o CPF do usuário. |
| `updatePhone()` | Define o número de telefone. |
| `clearUserData()` | Limpa os dados pessoais cadastrados. |
| `addAddress()`, `removeAddress()` | Gerencia a lista de endereços salvos. |
| `setPrimaryAddress()` | Define qual endereço será o principal. |
| `addCreditCard()`, `removeCreditCard()` | Gerencia os cartões adicionados. |
| `setPrimaryCard()` | Define um cartão como principal. |
| `setSelectedPaymentMethod()` | Registra o método de pagamento atual (cartão, Pix ou dinheiro). |
| `setCashChangeValue()` | Define o valor de troco para pagamentos em dinheiro. |
| `setSelectedCard()` | Define qual cartão será utilizado no pagamento atual. |

---

## Campos internos

- `String _fullName`, `_cpf`, `_phone`: dados cadastrais do usuário  
- `List<Address> _addresses`: lista de endereços, com controle de principal  
- `PaymentMethodType _selectedPaymentMethod`: método de pagamento atual  
- `bool _userHasSelectedPayment`: flag para controle da escolha ativa  
- `CashPaymentInfo? _cashPaymentInfo`: dados para pagamento em dinheiro  
- `String _pixKey`: chave Pix gerada automaticamente  
- `List<CreditCard> _creditCards`: lista de cartões salvos  
- `CreditCard? _selectedCard`: cartão selecionado para o pagamento

---

## Getters

| Getter | Retorno |
| --- | --- |
| `fullName`, `cpf`, `phone` | Dados cadastrais do usuário |
| `addresses` | Lista atual de endereços |
| `creditCards` | Lista de cartões cadastrados |
| `primaryCreditCard` | Primeiro cartão marcado como principal |
| `selectedCard` | Cartão atualmente selecionado para pagamento |
| `selectedPaymentMethod` | Tipo de pagamento atual (cartão, Pix, dinheiro) |
| `userHasSelectedPayment` | Indica se o usuário escolheu ativamente o método |
| `cashPaymentInfo` | Dados extras para pagamento em dinheiro |
| `cashChangeValue` | Valor de troco informado pelo usuário |
| `pixKey` | Chave Pix aleatória gerada para exibição/pagamento |

---

## Reatividade

Este provider utiliza `notifyListeners()` em todos os métodos de atualização. Isso garante que qualquer mudança nos dados do usuário será refletida automaticamente nas partes da interface que utilizam esse provider via `Consumer`, `Selector` ou `Provider.of(context)`.

---

## Geração de chave Pix

A chave Pix é gerada automaticamente com base no timestamp atual no momento da construção do provider. Isso simula um identificador único com o domínio `@techtaste.com`.

```dart
static String _generateRandomPixKey() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return 'pix-${now.toString().substring(5)}@techtaste.com';
}
```

---

## Código comentado

```dart
// Provider que gerencia todos os dados do usuário 
class UserDataProvider with ChangeNotifier {
  // === DADOS PESSOAIS ===
  String _fullName = '';
  String _cpf = '';
  String _phone = '';

  // Getters e métodos para atualizar os dados pessoais
  String get fullName => _fullName;
  void updateFullName(String name) {
    _fullName = name;
    notifyListeners(); // Notifica a UI sobre mudanças
  }

  String get cpf => _cpf;
  void updateCpf(String cpf) {
    _cpf = cpf;
    notifyListeners();
  }

  String get phone => _phone;
  void updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  // Limpa os dados pessoais (ex: ao deslogar)
  void clearUserData() {
    _fullName = '';
    _cpf = '';
    _phone = '';
    notifyListeners();
  }

  // === ENDEREÇOS ===
  final List<Address> _addresses = [];
  List<Address> get addresses => _addresses;

  // Adiciona novo endereço. O primeiro vira principal automaticamente.
  void addAddress(Address address) {
    if (_addresses.isEmpty) {
      address.isPrimary = true;
    }
    _addresses.add(address);
    notifyListeners();
  }

  // Atualiza um endereço existente
  void updateAddress(int index, Address newAddress) {
    _addresses[index] = newAddress;
    notifyListeners();
  }

  // Remove endereço da lista
  void removeAddress(Address address) {
    _addresses.remove(address);
    notifyListeners();
  }

  // Define qual endereço é o principal
  void setPrimaryAddress(Address address) {
    for (int i = 0; i < _addresses.length; i++) {
      final current = _addresses[i];
      final isSelected = current == address;
      _addresses[i] = current.copyWith(isPrimary: isSelected);
    }
    notifyListeners();
  }

  // Retorna o endereço principal
  Address? get primaryAddress => _addresses.firstWhere(
        (address) => address.isPrimary,
        orElse: () => _addresses.isNotEmpty ? _addresses[0] : null,
      );

  // === MÉTODO DE PAGAMENTO ===
  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.card;
  PaymentMethodType get selectedPaymentMethod => _selectedPaymentMethod;

  // Flag para indicar se o usuário já escolheu um método de pagamento
  bool _userHasSelectedPayment = false;
  bool get userHasSelectedPayment => _userHasSelectedPayment;

  // Atualiza o método de pagamento escolhido
  void setSelectedPaymentMethod(PaymentMethodType method) {
    _selectedPaymentMethod = method;
    _userHasSelectedPayment = true;
    notifyListeners();
  }

  // === PAGAMENTO EM DINHEIRO ===
  CashPaymentInfo? _cashPaymentInfo;
  CashPaymentInfo? get cashPaymentInfo => _cashPaymentInfo;

  void setCashPaymentInfo(CashPaymentInfo info) {
    _cashPaymentInfo = info;
    notifyListeners();
  }

  double _cashChangeValue = 0.0;
  double get cashChangeValue => _cashChangeValue;

  void setCashChangeValue(double value) {
    _cashChangeValue = value;
    notifyListeners();
  }

  // === PAGAMENTO VIA PIX ===
  String _pixKey = _generateRandomPixKey();
  String get pixKey => _pixKey;

  // Gera uma chave Pix única usando timestamp
  static String _generateRandomPixKey() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'pix-${now.toString().substring(5)}@techtaste.com';
  }

  // === CARTÕES DE CRÉDITO ===
  final List<CreditCard> _creditCards = [];
  List<CreditCard> get creditCards => _creditCards;

  // Retorna o cartão marcado como principal
  CreditCard? get primaryCreditCard {
    return _creditCards.firstWhere(
      (card) => card.isPrimary,
      orElse: () => _creditCards.isNotEmpty ? _creditCards[0] : null,
    );
  }

  // Adiciona novo cartão (evita duplicatas pelo final do número)
  void addCreditCard(CreditCard card) {
    if (_creditCards.any((c) => c.last4Digits == card.last4Digits)) return;
    _creditCards.add(card);
    notifyListeners();
  }

  // Remove cartão
  void removeCreditCard(CreditCard card) {
    _creditCards.remove(card);
    notifyListeners();
  }

  // Define o cartão principal
  void setPrimaryCard(CreditCard selectedCard) {
    for (int i = 0; i < _creditCards.length; i++) {
      final card = _creditCards[i];
      _creditCards[i] = card.copyWith(isPrimary: card == selectedCard);
    }
    notifyListeners();
  }

  // === CARTÃO SELECIONADO PARA USO NA COMPRA ATUAL ===
  CreditCard? _selectedCard;
  CreditCard? get selectedCard => _selectedCard;

  void setSelectedCard(CreditCard? card) {
    _selectedCard = card;
    notifyListeners();
  }
}

