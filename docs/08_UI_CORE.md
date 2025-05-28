# Pasta `_core/`

Esta pasta centraliza os recursos reutilizáveis e padrões visuais do aplicativo, garantindo consistência de estilo e acoplamento visual mínimo nas telas. Inclui arquivos como definições de cores, estilos de texto, tema global da aplicação e os principais providers usados em diversas partes do app.

![padrão visual do app](https://github.com/daniamorimdesa/TechTaste-foodapp-v2/blob/main/assets/screenshots/padr%C3%A3o%20visual.JPG)

---
## `app_colors.dart`
Este arquivo define a paleta de cores principal do aplicativo, usada em botões, textos, planos de fundo e outros elementos da interface. Ele segue uma abordagem centralizada para facilitar a manutenção e ajustes no tema visual geral.

### Funcionalidade
- Define constantes estáticas com as cores utilizadas no app
- Torna o estilo visual mais coeso e fácil de modificar em um único local
- Evita a repetição de códigos de cor espalhados por múltiplos widgets
  
### Decisão Técnica
A definição das cores em uma classe abstrata (`AppColors`) com membros `static const` permite acesso direto e global às cores, sem a necessidade de instanciar objetos. Isso favorece a performance e a legibilidade, e é uma prática comum em apps Flutter com design personalizado.
### Código comentado

```dart
// Define a paleta de cores do app como constantes estáticas.
abstract class AppColors {
  // Cor de fundo principal do app.
  static const Color backgroundColor = Color(0xFF202123);

  // Cor principal usada para botões e destaques.
  static const Color mainColor = Color(0xFFffa559);

  // Cor de fundo mais clara, usada em containers secundários.
  static const Color lightBackgroundColor = Color(0xFF343541);

  // Cor de destaque para textos importantes.
  static const Color highlightTextColor = Color(0xFFFFE6C7);

  // Cor de fundo de cards que contêm texto.
  static const Color backgroundCardTextColor = Color(0xFF343541);

  // Cor padrão de texto dentro de cards.
  static const Color cardTextColor = Color(0xFFDBD7DF);

  // Cor usada para destacar botões pressionados.
  static const Color pressedColor = Color(0xFFFF6000);

  // Cor dos botões principais.
  static const Color buttonsColor = Color(0xFFFFA559);
}

```
---
## `app_text_styles.dart`
Este arquivo define os estilos de texto utilizados em todo o aplicativo, mantendo a consistência tipográfica entre títulos, botões, legendas, menus e valores. Ele faz uso das cores definidas em `AppColors` para alinhar a identidade visual entre fontes e elementos de interface.

### Funcionalidade
- Centraliza todos os estilos de texto do app
- Facilita a manutenção e o ajuste da hierarquia visual
- Melhora a legibilidade e consistência entre componentes

### Decisão Técnica
A escolha de encapsular os estilos em uma classe abstrata com membros `static const` permite fácil reutilização e evita repetição de código. Isso também facilita testes visuais, ajustes globais e escalabilidade da interface.

### Código comentado

```dart
import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';

abstract class AppTextStyles {
  // Títulos grandes (Splash, seções principais)
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

  // Títulos médios com destaque, como nomes de seção
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.cardTextColor,
  );

  // Texto base usado em menus, rótulos e descrições
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextColor,
  );

  // Títulos de pratos com variações de cor e tamanho
  static const TextStyle dishTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.highlightTextColor,
  );

  static const TextStyle dishTitleMainColor = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.mainColor,
  );

  static const TextStyle dishTitleBigger = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.highlightTextColor,
  );

  // Estilos para exibição de preços
  static const TextStyle dishPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.cardTextColor,
  );

  static const TextStyle dishPriceBigger = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.cardTextColor,
  );

  // Estilo de texto para botões escuros
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.backgroundColor,
  );

  // Estilo do botão da Splash Screen
  static const TextStyle titleButtonSplash = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.backgroundColor,
  );

  // Texto auxiliar pequeno (ex: legendas)
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextColor,
  );

  // Títulos de seções como “minha conta”, “sacola”, etc.
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

```
---
## `app_theme.dart`
Este arquivo define o tema global do aplicativo utilizando `ThemeData.dark()` como base, adaptado com cores e estilos próprios da identidade visual do app definidos anteriormente nos arquivos `app_colors.dart` e `app_text_styles.dart`.

### Funcionalidade
- Centraliza as configurações visuais do app (principalmente botões)
- Utiliza o tema escuro como base (`ThemeData.dark()`).
- Aplica estilos personalizados para `ElevatedButton` por meio de `ElevatedButtonThemeData`

### Decisão Técnica
A escolha de usar `.copyWith()` sobre `ThemeData.dark()` permite manter o tema escuro nativo do Flutter, substituindo apenas o necessário (no caso, o tema dos botões elevados). O uso do `WidgetStateProperty.resolveWith` permite adaptar dinamicamente a cor do botão de acordo com o estado (normal, pressionado ou desabilitado).

### Código comentado

```dart
abstract class AppTheme {
  static ThemeData appTheme = ThemeData.dark().copyWith(
    // Tema para ElevatedButton (botões elevados)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.black), // Cor do texto
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          // Define cor de fundo com base no estado do botão
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey; // Desabilitado
          } else if (states.contains(WidgetState.pressed)) {
            return const Color.fromARGB(171, 255, 164, 89); // Pressionado
          }
          return AppColors.mainColor; // Estado normal
        }),
      ),
    ),
  );
}
```
---
### Observações
- A estrutura está preparada para crescer. Caso o projeto demande temas personalizados para `TextButton`, `InputDecoration`, `AppBar`, entre outros, eles podem ser adicionados com `.copyWith()` neste mesmo `ThemeData`
- O uso de uma `class abstract` com membro `static` garante que o tema possa ser acessado facilmente na configuração principal do app:

  
```
MaterialApp(
  theme: AppTheme.appTheme,
  // ...
)
