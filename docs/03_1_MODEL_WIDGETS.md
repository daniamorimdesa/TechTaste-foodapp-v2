# Pasta `model/widgets/`

Esta pasta contém widgets reutilizáveis diretamente relacionados aos modelos de dados do app. Esses widgets são funções utilitárias que retornam componentes UI personalizados com comportamentos específicos.

---

## `appbar.dart`

### Funcionalidade

Este arquivo define uma função que retorna uma `AppBar` personalizada com várias opções configuráveis:
- Ícone de voltar (quando `showBackButton = true`);
- Ícone de sacola de compras com badge de quantidade (quando `showBagIcon = true`);
- Lista de ações adicionais (`actions`).

### Decisão técnica

- Utiliza o pacote [`badges`](https://pub.dev/packages/badges) para exibir o número de itens na sacola.
- Integra-se ao `BagProvider` usando o `Provider` para obter informações sobre o estado atual da sacola.
- A navegação para a tela de checkout é condicionada à existência de um restaurante selecionado.

### Código comentado

```dart
// appbar.dart

import 'package:flutter/material.dart'; 
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

// Retorna uma AppBar customizada com título, botão de voltar e ícone da sacola
AppBar getAppBar({
  required BuildContext context,
  String? title,
  bool showBackButton = false,
  bool showBagIcon = true,
  List<Widget>? actions,
}) {
  // Obtém o estado da sacola via Provider
  BagProvider bagProvider = Provider.of<BagProvider>(context);

  // Lista de ações da AppBar
  final List<Widget> finalActions = [];

  // Adiciona ações extras, se houver
  if (actions != null) {
    finalActions.addAll(actions);
  }

  // Adiciona o ícone da sacola com badge, se habilitado
  if (showBagIcon) {
    finalActions.add(
      badges.Badge(
        showBadge: bagProvider.dishesOnBag.isNotEmpty,
        position: badges.BadgePosition.bottomStart(start: 0, bottom: 0),
        badgeContent: Text(
          bagProvider.dishesOnBag.length.toString(),
          style: const TextStyle(fontSize: 10),
        ),
        child: IconButton(
          icon: const Icon(Icons.shopping_basket),
          onPressed: () {
            final restaurant = bagProvider.selectedRestaurant;
            if (restaurant == null) {
              // Caso nenhum restaurante esteja selecionado
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sua sacola está vazia')),
              );
              return;
            }
            // Navega para a tela de checkout com o restaurante selecionado
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(restaurant: restaurant),
              ),
            );
          },
        ),
      ),
    );
  }

  return AppBar(
    leading: showBackButton
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )
        : null,
    title: title != null ? Text(title) : null,
    centerTitle: true,
    actions: finalActions,
  );
}

```

## Conclusão
O widget `getAppBar` oferece uma forma reutilizável e flexível de gerar `AppBars` dentro do aplicativo, respeitando o estado atual da sacola de compras e promovendo uma navegação contextual inteligente.
