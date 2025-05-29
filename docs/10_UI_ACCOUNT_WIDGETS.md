# pasta `account/widgets/`

## `user_section_card.dart`

### Funcionalidade
O componente `UserSectionCard` é um widget reutilizável responsável por estruturar visualmente as seções da conta do usuário, como "Meus Dados", "Endereços" ou "Cartões de Crédito". Ele serve como um cartão visual com título, conteúdo customizável e um botão de edição.

É projetado para ser altamente reutilizável dentro de `account_screen.dart` e outras telas relacionadas à conta do usuário, mantendo consistência visual e promovendo o uso de boas práticas de composição de widgets.

---

### Decisão Técnica
- Utilização de `StatelessWidget` por não haver estado interno necessário.
- Estilo consistente com o design do app: utiliza `AppColors` e `AppTextStyles` para manter a identidade visual.
- Parâmetros genéricos: `title`, `child` e `onEdit`, permitindo ampla reutilização do widget com diferentes conteúdos e ações.
- A estrutura `Container > Column > Row + child` foi escolhida para manter flexibilidade e clareza na organização dos elementos visuais.

---

### Código comentado

```dart
// Widget reutilizável para exibir seções da conta do usuário com título, conteúdo e botão de edição
class UserSectionCard extends StatelessWidget {
  final String title;        // Título da seção 
  final Widget child;        // Conteúdo interno customizável (ex: informações do usuário)
  final VoidCallback onEdit; // Função executada ao pressionar o botão de edição

  const UserSectionCard({
    super.key,
    required this.title,
    required this.child,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Caixa visual com cantos arredondados e cor de fundo customizada
      decoration: BoxDecoration(
        color: AppColors.backgroundCardTextColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha superior com título e botão de edição
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.highlightTextColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.buttonsColor),
                onPressed: onEdit,
              ),
            ],
          ),
          const SizedBox(height: 8), // Espaço entre o cabeçalho e o conteúdo
          child, // Widget personalizado com o conteúdo da seção
        ],
      ),
    );
  }
}
