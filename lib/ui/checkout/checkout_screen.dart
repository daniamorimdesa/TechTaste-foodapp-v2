import 'package:flutter/material.dart';
import 'package:myapp/model/payment.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/model/widgets/appbar.dart';
import 'package:myapp/model/address.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';
import 'package:myapp/ui/checkout/widgets/address_card.dart';
import 'package:myapp/ui/checkout/widgets/bag_items_list.dart';
import 'package:myapp/ui/checkout/widgets/clean_button_bag.dart';
import 'package:myapp/ui/checkout/widgets/order_summary_card.dart';
import 'package:myapp/ui/checkout/widgets/payment_method_card.dart';
import 'package:myapp/utils/frete_utils.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final Restaurant restaurant;

  const CheckoutScreen({super.key, required this.restaurant});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context);
    final userData = Provider.of<UserDataProvider>(context);
    final subtotal = bagProvider.getSubtotal();
    //final deliveryFee = 5.0; // frete padrão para versão inicial do app
    final distance = widget.restaurant.distance;
    final deliveryFee = calcularFrete(
      distance,
    ); // Calcula o frete com base na distância
    final total = subtotal + deliveryFee;
    final addressList = userData.addresses;
    final hasPrimary = addressList.any((a) => a.isPrimary);
    final primaryAddress =
        hasPrimary ? addressList.firstWhere((a) => a.isPrimary) : null;

    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: 'Sacola',
        showBackButton: true,
        showBagIcon: false,
        actions: [
          CleanButton(
            onPressed: () {
              Provider.of<BagProvider>(context, listen: false).clearBag();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Pedido', style: AppTextStyles.dishTitle),
          ),
          const SizedBox(height: 8),
          const BagItemsList(),
          const SizedBox(height: 24),

          // Pagamento
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Pagamento', style: AppTextStyles.dishTitle),
          ),
          const SizedBox(height: 8),
          PaymentMethodCard(
            onTap: () async {
              await Navigator.pushNamed(context, '/select-payment');
              setState(() {}); // para forçar rebuild se necessário
            },
          ),

          const SizedBox(height: 24),

          // Endereço de entrega
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Entregar no endereço:',
              style: AppTextStyles.dishTitle,
            ),
          ),
          const SizedBox(height: 8),

          AddressCard(
            address: primaryAddress ?? Address.empty(),
            onTap: () async {
              if (!hasPrimary) {
                // Se não houver endereço, vai direto para cadastro
                final selected =
                    await Navigator.pushNamed(context, '/select-address')
                        as Address?;
                if (selected != null) {
                  userData.setPrimaryAddress(selected);
                }
              } else {
                // Se já houver, abre a tela normalmente para alterar
                final selected =
                    await Navigator.pushNamed(context, '/select-address')
                        as Address?;
                if (selected != null) {
                  userData.setPrimaryAddress(selected);
                }
              }
            },
          ),

          const SizedBox(height: 24),

          // Resumo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Confirmar', style: AppTextStyles.dishTitle),
          ),
          const SizedBox(height: 8),
          OrderSummaryCard(
            subtotal: subtotal,
            deliveryFee: deliveryFee,
            total: total,
            cashChangeValue:
                userData.selectedPaymentMethod == PaymentMethodType.cash
                    ? userData.cashChangeValue
                    : null,
            onOrder: () {
              final userData = context.read<UserDataProvider>();
              final bagProvider = context.read<BagProvider>();

              final isBagEmpty = bagProvider.items.isEmpty;
              final noAddress = userData.addresses.isEmpty;
              final noPayment = !userData.userHasSelectedPayment;
              final needsCashChange =
                  userData.selectedPaymentMethod == PaymentMethodType.cash &&
                  userData.cashChangeValue == 0;

              if (isBagEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sua sacola está vazia.')),
                );
                return;
              }

              if (noAddress) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Escolha um endereço de entrega.'),
                  ),
                );
                return;
              }

              if (noPayment) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Escolha um método de pagamento.'),
                  ),
                );
                return;
              }

              if (needsCashChange) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Informe o troco para pagamento em dinheiro.',
                    ),
                  ),
                );
                return;
              }

              // Aqui vai a lógica final para registrar o pedido

              // Limpa dados
              userData.resetPaymentSelection();
              bagProvider.clearBag();

              // Navega para a tela de confirmação
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/order-confirmation',
                ModalRoute.withName('/'),
              );
            },
          ),
        ],
      ),
    );
  }
}
