class Address {
  String street;
  String number;
  String neighborhood;
  String city;
  String state;
  String cep;
  String label;
  String description;
  bool isPrimary;

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

  String get fullAddress {
    final desc = description.isNotEmpty ? ', $description' : '';
    return '$street, $number - $neighborhood, $city - $state, $cep ($label)$desc';
  }

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
