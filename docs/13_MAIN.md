# main.dart

## Funcionalidade
Este arquivo define o ponto de entrada do aplicativo **TechTaste**. Nele são configurados os principais providers para gerenciamento de estado global (`RestaurantData`, `BagProvider`, `UserDataProvider`), o tema visual da aplicação, as rotas nomeadas e o observador de navegação (`RouteObserver`), além da chamada inicial da tela de splash.

 ![Splash](assets/screenshots/demo.gif)
 
---
## Decisão Técnica
- **MultiProvider** foi utilizado para injetar os dados compartilhados globalmente, como os dados dos restaurantes, os itens no carrinho e informações do usuário.
- A arquitetura com **rotas nomeadas** permite navegação clara e organizada entre telas.
- O uso do `RouteObserver` viabiliza funcionalidades como rastreamento de navegação e controle de estado entre rotas.
- O `RestaurantData` é carregado de forma assíncrona antes da execução do `runApp`, garantindo que os dados estejam prontos para uso.

---
## Código comentado

```dart
import 'package:flutter/material.dart';

// Dados dos restaurantes (mockados/local)
import 'package:myapp/data/restaurant_data.dart';

// Tema visual do app
import 'package:myapp/ui/_core/app_theme.dart';

// Providers (gerenciamento de estado)
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';

// Telas do app
import 'package:myapp/ui/checkout/order_confirmation_screen.dart';
import 'package:myapp/ui/checkout/payment_selection_screen.dart';
import 'package:myapp/ui/checkout/select_address_screen.dart';
import 'package:myapp/ui/checkout/select_cash_change_screen.dart';
import 'package:myapp/ui/checkout/select_credit_card_screen.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/ui/home/search_results_screen.dart';
import 'package:myapp/ui/splash/splash_screen.dart';

// Observador de rotas para monitorar transições de tela
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  // Garante que os plugins Flutter estejam inicializados antes de async code
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa os dados dos restaurantes antes de iniciar o app
  RestaurantData restaurantData = RestaurantData();
  await restaurantData.getRestaurants();

  runApp(
    MultiProvider(
      providers: [
        // Dados dos restaurantes (lista, categorias etc.)
        ChangeNotifierProvider(create: (context) => restaurantData),

        // Carrinho de compras
        ChangeNotifierProvider(create: (context) => BagProvider()),

        // Dados do usuário (endereços, cartões etc.)
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove banner de debug
      theme: AppTheme.appTheme, // Define tema global da aplicação
      initialRoute: '/', // Tela inicial
      navigatorObservers: [routeObserver], // Observador de navegação
      routes: {
        '/': (context) => SplashScreen(), // Tela de splash (carregamento inicial)
        '/home': (context) => HomeScreen(), // Tela principal com os restaurantes
        '/select-payment': (context) => const PaymentSelectionScreen(), // Seleção de método de pagamento
        '/selecionar-cartao': (_) => const CreditCardSelectionScreen(), // Seleção de cartão de crédito
        '/troco': (_) => const CashChangeScreen(), // Informar valor para troco
        '/select-address': (context) => const SelectAddressScreen(), // Seleção de endereço de entrega
        '/order-confirmation': (context) => const OrderConfirmationScreen(), // Confirmação do pedido
        '/search': (context) {
          // Tela de resultados da busca, recebe uma string como argumento
          final query = ModalRoute.of(context)!.settings.arguments as String;
          return SearchResultsScreen(query: query);
        },
      },
    );
  }
}
