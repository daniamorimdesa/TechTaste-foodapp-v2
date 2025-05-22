import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';

class CashChangeScreen extends StatefulWidget {
  const CashChangeScreen({super.key});

  @override
  State<CashChangeScreen> createState() => _CashChangeScreenState();
}

class _CashChangeScreenState extends State<CashChangeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Troco para quanto?'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.highlightTextColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: AppColors.cardTextColor),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor em reais',
                labelStyle: const TextStyle(color: AppColors.cardTextColor),
                filled: true,
                fillColor: AppColors.lightBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonsColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final value = double.tryParse(
                  _controller.text.replaceAll(',', '.'),
                );

                if (value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite um valor válido')),
                  );
                  return;
                }

                final total =
                    Provider.of<BagProvider>(
                      context,
                      listen: false,
                    ).getSubtotal() +
                    5.0; // Adiciona taxa de entrega

                if (value < total) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'O valor informado é menor que o total de R\$ ${total.toStringAsFixed(2)}.',
                      ),
                    ),
                  );
                  return;
                }

                userData.setCashChangeValue(value);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Confirmar Troco'),
            ),
          ],
        ),
      ),
    );
  }
}
