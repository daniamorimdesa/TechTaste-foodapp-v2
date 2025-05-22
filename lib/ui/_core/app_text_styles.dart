import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';

abstract class AppTextStyles {
  // Títulos grandes (Splash, título de seções)
  static const TextStyle titleLargeWhite = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle titleLargeMainColor = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.mainColor,
  );

  // Título médio com destaque
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.cardTextColor,
  );

  // Texto padrão (menus, rótulos)
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextColor,
  );

  static const TextStyle dishTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.highlightTextColor, // laranja do tema
  );

  static const TextStyle dishTitleMainColor = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.mainColor,
  );

  static const TextStyle dishTitleBigger = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.highlightTextColor, // laranja do tema
  );

  static const TextStyle dishPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.cardTextColor, // texto padrão
  );

  static const TextStyle dishPriceBigger = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.cardTextColor, // texto padrão
  );

  // Texto claro para botões
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.backgroundColor,
  );

  // Texto do botão da Splash Screen
  static const TextStyle titleButtonSplash = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.backgroundColor,
  );

  // Texto pequeno auxiliar
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextColor,
  );

  // Texto de seção tipo "minha conta", "sacola"
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppColors.cardTextColor,
  );

  static const TextStyle sectionTitleDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.backgroundColor,
  );
}
