import 'package:flutter/material.dart';
import 'package:myapp/data/restaurant_data.dart';
import 'package:myapp/ui/_core/app_theme.dart';
import 'package:myapp/ui/_core/providers/bag_provider.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';
import 'package:myapp/ui/checkout/order_confirmation_screen.dart';
import 'package:myapp/ui/checkout/payment_selection_screen.dart';
import 'package:myapp/ui/checkout/select_address_screen.dart';
import 'package:myapp/ui/checkout/select_cash_change_screen.dart';
import 'package:myapp/ui/checkout/select_credit_card_screen.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/ui/home/search_results_screen.dart';
import 'package:myapp/ui/splash/splash_screen.dart';
import 'package:provider/provider.dart';

// RouteObserver global
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RestaurantData restaurantData = RestaurantData();
  await restaurantData.getRestaurants();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return restaurantData;
          },
        ),
        ChangeNotifierProvider(create: (context) => BagProvider()),
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      initialRoute: '/',
      navigatorObservers: [routeObserver],
      routes: {
        '/': (context) => SplashScreen(), // rota inicial
        '/home': (context) => HomeScreen(),
        '/select-payment': (context) => const PaymentSelectionScreen(),
        '/selecionar-cartao': (_) => const CreditCardSelectionScreen(),
        '/troco': (_) => const CashChangeScreen(),
        '/select-address': (context) => const SelectAddressScreen(),
        '/order-confirmation': (context) => const OrderConfirmationScreen(),
        '/search': (context) {
          final query = ModalRoute.of(context)!.settings.arguments as String;
          return SearchResultsScreen(query: query);
        },
      },
    );
  }
}
