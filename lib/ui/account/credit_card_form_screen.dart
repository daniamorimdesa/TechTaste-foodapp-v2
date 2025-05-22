import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/model/credit_card.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class AddCreditCardScreen extends StatefulWidget {
  final CreditCard? existingCard;

  const AddCreditCardScreen({super.key, this.existingCard});

  @override
  State<AddCreditCardScreen> createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cardExpiryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingCard != null) {
      final card = widget.existingCard!;
      cardNameController.text = card.cardName;
      cardExpiryController.text = card.expiryDate;
      cardNumberController.text = '•••• •••• •••• ${card.last4Digits}';
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardNameController.dispose();
    cardExpiryController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.cardTextColor),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: AppColors.backgroundCardTextColor,
        ),
        style: const TextStyle(color: AppColors.cardTextColor),
      ),
    );
  }

  void _saveCard() {
    final fullNumber = toNumericString(cardNumberController.text.trim());
    final expiry = cardExpiryController.text.trim();
    final name = cardNameController.text.trim();

    if (fullNumber.length < 16) {
      _showError('Número do cartão inválido');
      return;
    }

    if (!RegExp(r'^[0-9]{2}/[0-9]{2}$').hasMatch(expiry)) {
      _showError('Validade inválida. Use MM/AA.');
      return;
    }

    final parts = expiry.split('/');
    final int expMonth = int.tryParse(parts[0]) ?? 0;
    final int expYear = int.tryParse(parts[1]) ?? 0;
    final DateTime now = DateTime.now();
    final int currentYear = now.year % 100;
    final int currentMonth = now.month;

    if (expMonth < 1 || expMonth > 12) {
      _showError('Mês de validade inválido.');
      return;
    }

    if (expYear < currentYear ||
        (expYear == currentYear && expMonth < currentMonth)) {
      _showError('Cartão expirado.');
      return;
    }

    if (name.isEmpty) {
      _showError('Digite o nome no cartão.');
      return;
    }

    final last4 = fullNumber.substring(fullNumber.length - 4);
    final newCard = CreditCard(
      cardName: name,
      expiryDate: expiry,
      last4Digits: last4,
      brand: _detectCardBrand(fullNumber),
      isPrimary: false, // Sempre false ao adicionar
    );

    final userDataProvider = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
    userDataProvider.addCreditCard(newCard);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cartão salvo com sucesso!')));
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _detectCardBrand(String number) {
    if (number.startsWith('4')) return 'Visa';
    if (number.startsWith('5')) return 'Mastercard';
    if (number.startsWith('3')) return 'Amex';
    return 'Desconhecida';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Adicionar cartão'),
        backgroundColor: AppColors.lightBackgroundColor,
        iconTheme: const IconThemeData(color: AppColors.highlightTextColor),
        titleTextStyle: AppTextStyles.titleLargeWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(
              controller: cardNumberController,
              label: 'Número do cartão',
              keyboardType: TextInputType.number,
              inputFormatters: [CreditCardNumberInputFormatter()],
            ),
            _buildField(
              controller: cardNameController,
              label: 'Nome impresso no cartão',
            ),
            _buildField(
              controller: cardExpiryController,
              label: 'Validade (MM/AA)',
              keyboardType: TextInputType.datetime,
              inputFormatters: [CreditCardExpirationDateFormatter()],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonsColor,
                foregroundColor: AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveCard,
              child: Text(widget.existingCard == null ? 'Salvar' : 'Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
