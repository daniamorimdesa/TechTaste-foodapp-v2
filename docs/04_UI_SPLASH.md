# Pasta `splash/`

A splash screen é a tela de boas-vindas do aplicativo **TechTaste**, apresentada ao usuário logo após o carregamento inicial. Ela tem como função transmitir os valores da marca, criar um impacto visual inicial positivo e encaminhar o usuário para a tela principal (`HomeScreen`).

---

## `splash_screen.dart`

Este arquivo define o layout visual da splash screen, composto por:

- **Banner superior** com imagem.
- **Logo central** do aplicativo.
- **Frases de impacto** com diferentes estilos.
- **Botão "Bora!"**, que leva o usuário à tela inicial (`HomeScreen`) ao ser pressionado.

### Navegação
O botão utiliza `Navigator.pushReplacement` para substituir a splash pela Home, impedindo que o usuário volte para a splash ao pressionar "voltar".

### Estilo
Cores e tipografias são definidos por constantes em `app_colors.dart` e `app_text_styles.dart`, garantindo consistência visual.

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

Este componente representa o botão customizado utilizado na splash screen:
- GestureDetector para detectar toques
- AnimatedContainer para animar a troca de cor ao pressionar
- Recebe o texto e a ação (onPressed) como parâmetros

Esse botão foi separado como componente para **possível reutilização futura** em outras telas com o mesmo estilo.

---

## Comportamento esperado

- O botão **muda de cor rapidamente** ao toque, criando uma resposta visual agradável.
- A navegação para a Home ocorre **sem histórico**, respeitando o fluxo comum de apps com splash screen.

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

- `app_colors.dart` para cores do fundo, botão e textos.
- `app_text_styles.dart` para estilos tipográficos.
- `Image.asset()` para imagens locais (`logo.png` e `banner_splash.png`).

---
