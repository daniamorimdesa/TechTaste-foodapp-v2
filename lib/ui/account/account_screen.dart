import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/account/credit_card_list_screen.dart';
import 'package:myapp/ui/account/address_list_screen.dart';
import 'package:myapp/ui/account/edit_user_data_screen.dart';
import 'package:myapp/ui/account/widgets/user_section_card.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackgroundColor,
        title: const Text('Minha Conta', style: AppTextStyles.titleLargeWhite),
        iconTheme: const IconThemeData(color: AppColors.mainColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          //  Dados do usuário
          UserSectionCard(
            title: 'Dados do usuário',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userData.fullName.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome: ${userData.fullName}',
                        style: AppTextStyles.body,
                      ),
                      Text('CPF: ${userData.cpf}', style: AppTextStyles.body),
                      Text(
                        'Telefone: ${userData.phone}',
                        style: AppTextStyles.body,
                      ),
                    ],
                  )
                else
                  const Text(
                    'Toque em editar para adicionar seus dados.',
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditUserDataScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Endereços de entrega
          UserSectionCard(
            title: 'Endereços de entrega',
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Principal',
                    style: AppTextStyles.dishTitle,
                  ),
                  subtitle: Text(
                    userData.addresses.any((a) => a.isPrimary)
                        ? userData.addresses
                            .firstWhere((a) => a.isPrimary)
                            .fullAddress
                        : 'Nenhum endereço cadastrado',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddressListScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          //  Métodos de pagamento
          UserSectionCard(
            title: 'Métodos de pagamento',
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.credit_card,
                    color: AppColors.mainColor,
                  ),
                  title: const Text(
                    'Principal',
                    style: AppTextStyles.dishTitle,
                  ),
                  subtitle: Text(
                    userData.creditCards.any((a) => a.isPrimary)
                        ? '${userData.creditCards.firstWhere((a) => a.isPrimary).brand} - '
                            '${userData.creditCards.firstWhere((a) => a.isPrimary).maskedNumber}'
                        : 'Nenhum cartão cadastrado',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreditCardListScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
