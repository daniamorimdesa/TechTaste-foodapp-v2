class CreditCard {
  final String cardName; // Nome impresso no cartão
  final String last4Digits; // Últimos 4 dígitos (ex: "1234")
  final String expiryDate; // MM/AA
  final String brand; // Visa, Mastercard, etc.
  final bool isPrimary;

  CreditCard({
    required this.cardName,
    required this.last4Digits,
    required this.expiryDate,
    required this.brand,
    this.isPrimary = false,
  });

  String get maskedNumber => '•••• •••• •••• $last4Digits';

  // Facilita criar uma cópia com alguma modificação
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

  // Permite comparar objetos corretamente em listas e condições
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

  @override
  int get hashCode =>
      cardName.hashCode ^
      last4Digits.hashCode ^
      expiryDate.hashCode ^
      brand.hashCode ^
      isPrimary.hashCode;
}
