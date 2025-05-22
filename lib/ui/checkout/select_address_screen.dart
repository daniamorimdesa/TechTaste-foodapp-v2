import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/account/edit_address_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/app_colors.dart'; // se estiver usando AppColors

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressList = context.watch<UserDataProvider>().addresses;

    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar Endereço')),
      body: Column(
        children: [
          Expanded(
            child:
                addressList.isEmpty
                    ? const Center(child: Text('Nenhum endereço cadastrado.'))
                    : ListView.builder(
                      itemCount: addressList.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final address = addressList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              '${address.street}, ${address.number}',
                              style: AppTextStyles.body,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${address.neighborhood}, ${address.city} - ${address.state}',
                                ),
                                Text('${address.cep} — ${address.label}'),
                                if (address.description.isNotEmpty)
                                  Text(address.description),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(context, address);
                            },
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EditAddressScreen(
                          onSave: (newAddress) {
                            context.read<UserDataProvider>().addAddress(
                              newAddress,
                            );
                          },
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar novo endereço'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonsColor,
                foregroundColor: AppColors.backgroundColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
