import 'package:flutter/material.dart';
import 'package:myapp/model/payment.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';

class PaymentSelectionScreen extends StatelessWidget {
  const PaymentSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    Widget buildPaymentCard({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppColors.lightBackgroundColor,
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: AppColors.pressedColor.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
            child: Row(
              children: [
                Icon(icon, size: 30, color: AppColors.mainColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.cardTextColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.buttonsColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Forma de Pagamento'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.highlightTextColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          buildPaymentCard(
            icon: Icons.credit_card,
            title: 'Cartão de Crédito',
            onTap: () {
              userData.setSelectedPaymentMethod(PaymentMethodType.card);
              userData.setSelectedCard(userData.primaryCreditCard);
              Navigator.pushNamed(context, '/selecionar-cartao');
            },
          ),
          buildPaymentCard(
            icon: Icons.pix,
            title: 'Pix',
            onTap: () {
              userData.setSelectedPaymentMethod(PaymentMethodType.pix);
              Navigator.pop(context);
            },
          ),
          buildPaymentCard(
            icon: Icons.money,
            title: 'Dinheiro',
            onTap: () {
              userData.setSelectedPaymentMethod(PaymentMethodType.cash);
              Navigator.pushNamed(context, '/troco');
            },
          ),
        ],
      ),
    );
  }
}
