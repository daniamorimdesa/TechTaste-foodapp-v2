import 'package:flutter/material.dart';
import 'package:myapp/main.dart'; // para acessar routeObserver
import 'package:myapp/model/dish.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/model/widgets/appbar.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';

class DishDetailsScreen extends StatefulWidget {
  final Dish dish;
  final Restaurant restaurant;

  const DishDetailsScreen({
    super.key,
    required this.dish,
    required this.restaurant,
  });

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> with RouteAware {
  int quantity = 1;
  bool hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasInitialized) {
      _updateQuantityFromBag();
      hasInitialized = true;
    }

    // Inscreve-se no observer de rotas
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  void _updateQuantityFromBag() {
    final bagProvider = Provider.of<BagProvider>(context, listen: false);
    final currentQty = bagProvider.getDishQuantity(widget.dish);
    if (currentQty > 0) {
      setState(() {
        quantity = currentQty;
      });
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Chamado quando volta de uma rota sobreposta (ex: sacola)
    _updateQuantityFromBag();
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context);

    return Scaffold(
      appBar: getAppBar(context: context, title: widget.restaurant.name),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/${widget.dish.imagePath}',
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            // Nome e preço
            Text(widget.dish.name, style: AppTextStyles.dishTitleBigger),
            const SizedBox(height: 2),
            Text(
              'R\$ ${widget.dish.price.toStringAsFixed(2)}',
              style: AppTextStyles.dishPriceBigger,
            ),
            const SizedBox(height: 2),
            Text(widget.dish.description, style: AppTextStyles.sectionTitle),
            const SizedBox(height: 10),

            // Seletor de quantidade
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: AppColors.mainColor),
                  onPressed: decreaseQuantity,
                ),
                Text(quantity.toString(), style: AppTextStyles.body),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.mainColor),
                  onPressed: increaseQuantity,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botão Adicionar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: () {
                  bagProvider.updateDishQuantity(widget.dish, quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Atualizado na sacola')),
                  );
                },
                child: Text('Adicionar', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
