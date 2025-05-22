import 'package:flutter/material.dart';
import 'package:myapp/model/credit_card.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/account/credit_card_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';

class CreditCardListScreen extends StatelessWidget {
  const CreditCardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final cards = userDataProvider.creditCards;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBackgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.highlightTextColor,
          size: 30,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Meus Cartões', style: AppTextStyles.titleLargeWhite),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: AppColors.buttonsColor,
                size: 36,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddCreditCardScreen()),
                );
              },
            ),
          ],
        ),
      ),

      backgroundColor: AppColors.backgroundColor,
      body:
          cards.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.credit_card_off,
                        size: 64,
                        color: AppColors.buttonsColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Você ainda não cadastrou nenhum cartão.',
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonsColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddCreditCardScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar novo cartão'),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            card.isPrimary
                                ? AppColors.mainColor
                                : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Card(
                          color: AppColors.backgroundCardTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  card.brand == 'Visa'
                                      ? Icons.credit_card
                                      : card.brand == 'Mastercard'
                                      ? Icons.credit_card
                                      : Icons.payment,
                                  color: AppColors.buttonsColor,
                                  size: 40,
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${card.brand} **** ${card.last4Digits}',
                                        style: AppTextStyles.body,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Expira em ${card.expiryDate}',
                                        style: AppTextStyles.body,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: AppColors.buttonsColor,
                                  ),
                                  color: Colors.black87,
                                  surfaceTintColor: Colors.black87,

                                  onSelected: (value) {
                                    if (value == 'primary') {
                                      userDataProvider.setPrimaryCard(card);
                                    } else if (value == 'delete') {
                                      _confirmDeleteCard(context, card);
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        PopupMenuItem(
                                          value: 'primary',
                                          child: Row(
                                            children: [
                                              Icon(
                                                card.isPrimary
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                card.isPrimary
                                                    ? 'Cartão principal'
                                                    : 'Definir como principal',
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Remover'),
                                            ],
                                          ),
                                        ),
                                      ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (card.isPrimary)
                          Positioned(
                            bottom: 33,
                            right: 68,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Principal',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  void _confirmDeleteCard(BuildContext context, CreditCard card) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Excluir cartão'),
            content: const Text('Tem certeza que deseja remover este cartão?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonsColor,
                ),
                child: const Text('Excluir'),
                onPressed: () {
                  Provider.of<UserDataProvider>(
                    context,
                    listen: false,
                  ).removeCreditCard(card);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cartão removido com sucesso!'),
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }
}
