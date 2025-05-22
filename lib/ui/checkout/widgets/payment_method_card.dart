import 'package:flutter/material.dart';
import 'package:myapp/model/credit_card.dart';
import 'package:myapp/model/payment.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';

class PaymentMethodCard extends StatelessWidget {
  final VoidCallback onTap;

  const PaymentMethodCard({super.key, required this.onTap});

  String _getLabel(PaymentMethodType? method, CreditCard? selectedCard) {
    switch (method) {
      case PaymentMethodType.card:
        if (selectedCard != null) {
          return '${selectedCard.brand} - **** ${selectedCard.last4Digits}';
        } else {
          return 'Adicionar forma de pagamento';
        }
      case PaymentMethodType.pix:
        return 'Pix';
      case PaymentMethodType.cash:
        return 'Dinheiro';
      default:
        return 'Escolher método de pagamento';
    }
  }

  IconData _getIcon(PaymentMethodType? method) {
    switch (method) {
      case PaymentMethodType.card:
        return Icons.credit_card;
      case PaymentMethodType.pix:
        return Icons.pix;
      case PaymentMethodType.cash:
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserDataProvider>();
    final selectedMethod = userProvider.selectedPaymentMethod;
    final selectedCard = userProvider.selectedCard;
    return Card(
      color: AppColors.backgroundCardTextColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                _getIcon(selectedMethod),
                color: AppColors.cardTextColor,
                size: 32,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  _getLabel(selectedMethod, selectedCard),
                  style: const TextStyle(
                    color: AppColors.cardTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const CircleAvatar(
                backgroundColor: AppColors.mainColor,
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
