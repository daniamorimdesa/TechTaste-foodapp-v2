import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/model/address.dart';

class AddressCard extends StatelessWidget {
  final VoidCallback onTap;
  final Address address;

  const AddressCard({super.key, required this.onTap, required this.address});

  bool get isAddressEmpty {
    return address.street.isEmpty && address.number.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
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
              const Icon(
                Icons.location_on,
                color: AppColors.cardTextColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child:
                    isAddressEmpty
                        ? Text(
                          'Selecionar endereço',
                          style: const TextStyle(
                            color: AppColors.cardTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${address.street}, ${address.number}',
                              style: const TextStyle(
                                color: AppColors.cardTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${address.neighborhood}, ${address.city} - ${address.state}',
                              style: const TextStyle(
                                color: AppColors.cardTextColor,
                                fontSize: 16,
                              ),
                            ),
                            if (address.description.isNotEmpty)
                              Text(
                                address.description,
                                style: const TextStyle(
                                  color: AppColors.cardTextColor,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
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
