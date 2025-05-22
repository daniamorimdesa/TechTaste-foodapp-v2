import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:provider/provider.dart';

class BagItemsList extends StatelessWidget {
  const BagItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context);
    final items = bagProvider.items.entries.toList();

    if (items.isEmpty) {
      return const Text('Sua sacola está vazia');
    }

    return Column(
      children:
          items.map((entry) {
            final dish = entry.key;
            final quantity = entry.value;

            return ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120),
              child: Card(
                color: AppColors.backgroundCardTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                elevation: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagem
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/${dish.imagePath}',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nome e preço
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dish.name,
                              style: AppTextStyles.dishTitle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'R\$ ${dish.price.toStringAsFixed(2)}',
                              style: AppTextStyles.dishPrice.copyWith(
                                fontSize: 18,
                                color: AppColors.cardTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Controle de quantidade
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        height: 120,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => bagProvider.incrementDish(dish),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColors.mainColor,
                                  child: const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$quantity',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.highlightTextColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => bagProvider.decrementDish(dish),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColors.mainColor,
                                  child: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
