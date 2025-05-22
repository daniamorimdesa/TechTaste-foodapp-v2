import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/model/address.dart';
import 'package:myapp/ui/account/edit_address_screen.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  void _addOrEditAddress(BuildContext context, [Address? existingAddress]) {
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => EditAddressScreen(
              address: existingAddress,
              onSave: (newAddress) {
                if (existingAddress != null) {
                  userProvider.updateAddress(existingAddress, newAddress);
                } else {
                  userProvider.addAddress(newAddress);
                }
                if (newAddress.isPrimary) {
                  userProvider.setPrimaryAddress(newAddress);
                }
              },
            ),
      ),
    );
  }

  void _removeAddress(BuildContext context, Address address) {
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.backgroundColor,
            title: const Text(
              'Remover endereço',
              style: TextStyle(color: AppColors.highlightTextColor),
            ),
            content: const Text(
              'Tem certeza que deseja remover este endereço?',
              style: TextStyle(color: AppColors.cardTextColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: AppColors.buttonsColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  userProvider.removeAddress(address);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Remover',
                  style: TextStyle(color: AppColors.highlightTextColor),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address, int index) {
    return Card(
      color: AppColors.backgroundCardTextColor,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          '${address.label} - ${address.street}, ${address.number}',
          style: const TextStyle(
            color: AppColors.highlightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${address.neighborhood}, ${address.city} - ${address.state}\nCEP: ${address.cep}',
          style: const TextStyle(
            color: AppColors.cardTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (address.isPrimary)
              const Icon(Icons.star, color: AppColors.highlightTextColor),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.buttonsColor),
              onPressed: () => _addOrEditAddress(context, address),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.cardTextColor),
              onPressed: () => _removeAddress(context, address),
            ),
          ],
        ),
        onTap: () => _addOrEditAddress(context, address),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userProvider, child) {
        final addresses = userProvider.addresses;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            title: const Text('Meus Endereços'),
            backgroundColor: AppColors.lightBackgroundColor,
            foregroundColor: AppColors.cardTextColor,
          ),
          body: Column(
            children: [
              Expanded(
                child:
                    addresses.isEmpty
                        ? const Center(
                          child: Text(
                            'Nenhum endereço cadastrado.',
                            style: TextStyle(color: AppColors.cardTextColor),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: addresses.length,
                          itemBuilder:
                              (context, index) => _buildAddressCard(
                                context,
                                addresses[index],
                                index,
                              ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ElevatedButton.icon(
                  onPressed: () => _addOrEditAddress(context),
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
      },
    );
  }
}
