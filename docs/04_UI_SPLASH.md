# Pasta `splash/`

Define a tela inicial do aplicativo, exibindo o logotipo, mensagens de boas-vindas e um botão para navegar para a tela principal (`HomeScreen`).

---

## `splash_screen.dart`

### Funcionalidade
Define a tela inicial do aplicativo, exibindo o logotipo, mensagens de boas-vindas e um botão para navegar para a tela principal.

### Decisão Técnica
- Utiliza `Stack` para sobrepor o banner no topo da tela
- Centraliza o conteúdo principal com `Column` e `Spacer`
- Implementa navegação para `HomeScreen` ao pressionar o botão

### Código comentado

```dart
// Tela de abertura do app
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Cor de fundo
      body: Stack(
        children: [
          // Banner no topo da tela
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
                Image.asset('assets/logo.png', width: 215), // Logo central
                const SizedBox(height: 30),
                Column(
                  children: const [
                    Text(
                      "Um parceiro inovador para a sua", // Frase 1
                      style: AppTextStyles.titleLargeWhite,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "melhor experiência culinária!", // Frase 2
                      style: AppTextStyles.titleLargeMainColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  // Botão que leva para a Home
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


```
---

## `splash_screen_button.dart`

### Funcionalidade
Componente reutilizável de botão estilizado para a tela de splash, com feedback visual ao ser pressionado.

### Decisão Técnica
- Utiliza `GestureDetector` para detectar interações do usuário
- Anima a mudança de cor ao pressionar o botão com `AnimatedContainer`
- Aplica estilos personalizados definidos em `AppTextStyles` e `AppColors`
  
### Código comentado

```dart
// Botão customizado da Splash Screen
class SplashScreenButton extends StatefulWidget {
  final String text; // Texto exibido no botão
  final VoidCallback onPressed; // Ação ao clicar

  const SplashScreenButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<SplashScreenButton> createState() => _SplashScreenButtonState();
}

class _SplashScreenButtonState extends State<SplashScreenButton> {
  bool _isPressed = false; // Estado do toque

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed, // Executa ação ao tocar
      onTapDown: (_) => setState(() => _isPressed = true), // Pressionado
      onTapUp: (_) => setState(() => _isPressed = false),  // Soltou
      onTapCancel: () => setState(() => _isPressed = false), // Cancelou
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.pressedColor : AppColors.buttonsColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(widget.text, style: AppTextStyles.titleButtonSplash),
        ),
      ),
    );
  }
}

```
---

## Dependências utilizadas

Ambos os arquivos utilizam:

- `app_colors.dart` para cores do fundo, botão e textos
- `app_text_styles.dart` para estilos tipográficos
