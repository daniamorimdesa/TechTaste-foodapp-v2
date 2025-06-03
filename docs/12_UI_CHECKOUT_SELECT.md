# Telas de Seleção do Checkout

Durante o fluxo de checkout no app **TechTaste**, o usuário passa por uma série de etapas decisivas que garantem que o pedido seja finalizado corretamente, com **endereço, forma de pagamento e troco (quando necessário)**.

Essas telas foram projetadas para serem **claras, objetivas e responsivas**, respeitando as boas práticas de UX/UI e facilitando a tomada de decisão por parte do usuário. Todas são implementadas como **screens modulares** que podem ser reutilizadas ou adaptadas com facilidade.

As telas documentadas aqui são:

| Arquivo Dart                   | Responsabilidade                                                                 |
|-------------------------------|----------------------------------------------------------------------------------|
| `payment_selection_screen.dart`       | Permite ao usuário escolher a forma de pagamento.               |
| `select_address_screen.dart`          | Tela onde o usuário seleciona o endereço de entrega.            |
| `select_cash_change_screen.dart`      | Aparece se o pagamento for em dinheiro, permitindo informar valor para troco. |
| `select_credit_card_screen.dart`      | Aparece se o pagamento for com cartão, simulando seleção do cartão cadastrado.|

Cada uma dessas telas contribui para garantir que as **informações do pedido estejam completas e corretas antes da finalização**.

---
---

## `payment_selection_screen.dart`

### Funcionalidade
Esta tela permite que o usuário escolha a **forma de pagamento** para finalizar o pedido. As opções apresentadas são:

- **Cartão de Crédito**
- **Pix**
- **Dinheiro**

Cada opção atualiza o estado global da aplicação através do `UserDataProvider` e redireciona o usuário para a próxima etapa, conforme o método escolhido.

---
### Decisão Técnica
- Utiliza o **Provider** para acessar e atualizar o estado do usuário (`selectedPaymentMethod`, `selectedCard`, etc.).
- Utiliza `Navigator.pushNamed` ou `Navigator.pop` para navegar de acordo com o tipo de pagamento.
- Os cards de seleção são implementados com `InkWell` dentro de `Card`, garantindo bom feedback visual ao toque.
- Toda a tela é construída com `StatelessWidget`, já que não há necessidade de estado local.

---
### Código comentado
```dart
// Tela de seleção de pagamento (cartão, dinheiro ou Pix)
class PaymentSelectionScreen extends StatelessWidget {
  const PaymentSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context); // Acessa o estado global do usuário

    // Widget reutilizável para exibir as opções de pagamento
    Widget buildPaymentCard({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppColors.lightBackgroundColor,
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: AppColors.pressedColor.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
            child: Row(
              children: [
                Icon(icon, size: 30, color: AppColors.mainColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.cardTextColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.buttonsColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Tela principal com os cards das opções de pagamento
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Forma de Pagamento'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.highlightTextColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Cartão de Crédito: navega para seleção de cartão
          buildPaymentCard(
            icon: Icons.credit_card,
            title: 'Cartão de Crédito',
            onTap: () {
              userData.setSelectedPaymentMethod(PaymentMethodType.card);
              userData.setSelectedCard(userData.primaryCreditCard);
              Navigator.pushNamed(context, '/selecionar-cartao');
            },
          ),
          // Pix: define método e volta ao checkout
          buildPaymentCard(
            icon: Icons.pix,
            title: 'Pix',
            onTap: () {
              userData.setSelectedPaymentMethod(PaymentMethodType.pix);
              Navigator.pop(context);
            },
          ),
          // Dinheiro: navega para informar valor para troco
          buildPaymentCard(
            icon: Icons.money,
            title: 'Dinheiro',
            onTap: () {
              userData.setSelectedPaymentMethod(PaymentMethodType.cash);
              Navigator.pushNamed(context, '/troco');
            },
          ),
        ],
      ),
    );
  }
}
```
---
## `select_cash_change_screen.dart`

### Funcionalidade

Esta tela permite que o usuário informe com quanto em dinheiro ele pagará, para que o sistema calcule automaticamente o valor do troco necessário. Ela é exibida somente se o usuário escolheu pagar em dinheiro na tela anterior.

---
### Decisão Técnica

- Utiliza `TextEditingController` para capturar a entrada do usuário.
- Garante que o valor informado seja válido e suficiente para cobrir o valor total da compra, incluindo a taxa de entrega.
- Informa erros ao usuário com `SnackBar` caso o valor seja inválido ou insuficiente.
- Ao confirmar, o valor de troco é salvo no `UserDataProvider` e a navegação retorna duas telas para trás (para concluir o checkout).

---
### Código comentado
```dart
// Tela de seleção de troco em caso de pagamento em dinheiro 
class CashChangeScreen extends StatefulWidget {
  const CashChangeScreen({super.key});

  @override
  State<CashChangeScreen> createState() => _CashChangeScreenState();
}

class _CashChangeScreenState extends State<CashChangeScreen> {
  final TextEditingController _controller = TextEditingController(); // Controlador do campo de texto

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context); // Acesso ao estado global

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Troco para quanto?'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.highlightTextColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Campo de entrada do valor
            TextField(
              controller: _controller,
              style: const TextStyle(color: AppColors.cardTextColor),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor em reais',
                labelStyle: const TextStyle(color: AppColors.cardTextColor),
                filled: true,
                fillColor: AppColors.lightBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão de confirmação
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonsColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Converte o valor informado pelo usuário
                final value = double.tryParse(
                  _controller.text.replaceAll(',', '.'),
                );

                if (value == null) {
                  // Valor inválido
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite um valor válido')),
                  );
                  return;
                }

                // Calcula total com taxa de entrega
                final total =
                    Provider.of<BagProvider>(
                      context,
                      listen: false,
                    ).getSubtotal() +
                   userData.deliveryFee;

                if (value < total) {
                  // Valor insuficiente
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'O valor informado é menor que o total de R\$ ${total.toStringAsFixed(2)}.',
                      ),
                    ),
                  );
                  return;
                }

                // Tudo certo: armazena valor e volta para o fluxo de checkout
                userData.setCashChangeValue(value);
                Navigator.pop(context); // volta para seleção de pagamento
                Navigator.pop(context); // volta para tela de checkout
              },
              child: const Text('Confirmar Troco'),
            ),
          ],
        ),
      ),
    );
  }
}
