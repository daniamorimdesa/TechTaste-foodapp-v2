import 'package:flutter/material.dart';
import 'package:myapp/model/address.dart';
import 'package:myapp/model/credit_card.dart';
import 'package:myapp/model/payment.dart';

class UserDataProvider with ChangeNotifier {
  String _fullName = '';
  String _cpf = '';
  String _phone = '';

  // Getters
  String get fullName => _fullName;
  String get cpf => _cpf;
  String get phone => _phone;

  // Setters
  void updateFullName(String name) {
    _fullName = name;
    notifyListeners();
  }

  void updateCPF(String newCPF) {
    _cpf = newCPF;
    notifyListeners();
  }

  void updatePhone(String newPhone) {
    _phone = newPhone;
    notifyListeners();
  }

  void clearUserData() {
    _fullName = '';
    _cpf = '';
    _phone = '';
    notifyListeners();
  }

  // gerenciamento de múltiplos endereços
  final List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  void addAddress(Address address) {
    if (_addresses.isEmpty) {
      address.isPrimary = true;
    }
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(Address address) {
    _addresses.remove(address);
    if (address.isPrimary && _addresses.isNotEmpty) {
      _addresses[0].isPrimary = true;
    }
    notifyListeners();
  }

  void updateAddress(Address oldAddress, Address newAddress) {
    final index = _addresses.indexOf(oldAddress);
    if (index != -1) {
      _addresses[index] = newAddress;
      notifyListeners();
    }
  }

  void setPrimaryAddress(Address address) {
    for (int i = 0; i < _addresses.length; i++) {
      final current = _addresses[i];
      final isSelected = current == address;
      _addresses[i] = current.copyWith(isPrimary: isSelected);
    }
    notifyListeners();
  }

  void clearAddresses() {
    _addresses.clear();
    notifyListeners();
  }

  // Método de pagamento atual
  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.card;
  PaymentMethodType get selectedPaymentMethod => _selectedPaymentMethod;

  // Flag para saber se o usuário escolheu ativamente um método de pagamento
  bool _userHasSelectedPayment = false;
  bool get userHasSelectedPayment => _userHasSelectedPayment;

  void setSelectedPaymentMethod(PaymentMethodType method) {
    _selectedPaymentMethod = method;
    _userHasSelectedPayment = true; // Marca que o usuário interagiu
    notifyListeners();
  }

  void resetPaymentSelection() {
    _userHasSelectedPayment = false;
    notifyListeners();
  }

  // Para pagamento em dinheiro
  CashPaymentInfo? _cashPaymentInfo;
  CashPaymentInfo? get cashPaymentInfo => _cashPaymentInfo;

  double _cashChangeValue = 0.0; // valor de troco
  double get cashChangeValue => _cashChangeValue;
  double _deliveryFee = 0.0;

  double get deliveryFee => _deliveryFee;

  void setCashChangeValue(double value) {
    _cashChangeValue = value;
    notifyListeners();
  }

  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    notifyListeners();
  }

  void setCashPaymentInfo(CashPaymentInfo info) {
    _cashPaymentInfo = info;
    notifyListeners();
  }

  void clearCashPaymentInfo() {
    _cashPaymentInfo = null;
    notifyListeners();
  }

  // Para pagamento via Pix
  String _pixKey = _generateRandomPixKey();
  String get pixKey => _pixKey;

  static String _generateRandomPixKey() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'pix-${now.toString().substring(5)}@techtaste.com';
  }

  //gerenciamento de cartões de crédito
  final List<CreditCard> _creditCards = [];

  List<CreditCard> get creditCards => _creditCards;

  CreditCard? get primaryCreditCard {
    try {
      return _creditCards.firstWhere((c) => c.isPrimary);
    } catch (_) {
      return null;
    }
  }

  void addCreditCard(CreditCard card) {
    if (_creditCards.any((c) => c.last4Digits == card.last4Digits)) return;
    _creditCards.add(card);
    notifyListeners();
  }

  void removeCreditCard(CreditCard card) {
    final wasPrimary = card.isPrimary;
    _creditCards.remove(card);
    if (wasPrimary && _creditCards.isNotEmpty) {
      final first = _creditCards.first;
      _creditCards[0] = first.copyWith(isPrimary: true);
    }
    notifyListeners();
  }

  void setPrimaryCard(CreditCard selectedCard) {
    for (int i = 0; i < _creditCards.length; i++) {
      final card = _creditCards[i];
      _creditCards[i] = card.copyWith(isPrimary: card == selectedCard);
    }
    notifyListeners();
  }

  void updateCreditCard(CreditCard oldCard, CreditCard newCard) {
    final index = _creditCards.indexOf(oldCard);
    if (index != -1) {
      final wasPrimary = oldCard.isPrimary;
      _creditCards[index] = newCard;

      if (newCard.isPrimary) {
        setPrimaryCard(newCard);
      } else if (wasPrimary) {
        setPrimaryCard(_creditCards.first); // força outro como principal
      }

      notifyListeners();
    }
  }

  // Cartão selecionado para pagamento
  CreditCard? _selectedCard;
  CreditCard? get selectedCard => _selectedCard;

  void setSelectedCard(CreditCard? card) {
    _selectedCard = card;
    notifyListeners();
  }
}
