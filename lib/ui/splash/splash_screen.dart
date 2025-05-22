import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/ui/splash/splash_screen_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Banner no topo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset('assets/banners/banner_splash.png'),
          ),
          // Conteúdo centralizado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 6),
                Image.asset('assets/logo.png', width: 215),
                const SizedBox(height: 30),
                Column(
                  children: const [
                    Text(
                      "Um parceiro inovador para a sua",
                      style: AppTextStyles.titleLargeWhite,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "melhor experiência culinária!",
                      style: AppTextStyles.titleLargeMainColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: SplashScreenButton(
                    text: "Bora!",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
