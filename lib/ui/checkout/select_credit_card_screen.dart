import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/account/credit_card_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';

class CreditCardSelectionScreen extends StatelessWidget {
  const CreditCardSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final cards = userData.creditCards;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Selecionar Cartão'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.highlightTextColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cards.length + 1, // +1 para o botão de adicionar
        itemBuilder: (context, index) {
          if (index < cards.length) {
            final card = cards[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.lightBackgroundColor,
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  userData.setSelectedCard(card);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card, color: AppColors.mainColor),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '**** **** **** ${card.last4Digits}',
                          style: const TextStyle(
                            color: AppColors.cardTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (userData.selectedCard == card)
                        const Icon(Icons.check, color: AppColors.mainColor),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Botão "Adicionar novo cartão"
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddCreditCardScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar novo cartão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonsColor,
                  foregroundColor: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
