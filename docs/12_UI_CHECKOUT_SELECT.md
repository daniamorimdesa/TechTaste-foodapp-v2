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
```
---
## `select_credit_card_screen.dart`

### Funcionalidade
A `CreditCardSelectionScreen` é responsável por exibir ao usuário os cartões de crédito cadastrados e permitir que ele selecione um deles como método de pagamento. Além disso, a tela oferece um botão para adicionar um novo cartão, redirecionando para o formulário correspondente. 
Ao tocar em um cartão existente:
- Ele é definido como o cartão selecionado no `UserDataProvider`.
- A navegação é encerrada com dois pop() para retornar à tela de checkout.

Essa tela garante que o usuário possa alterar rapidamente o cartão utilizado sem sair do fluxo principal do pedido.

---
### Decisão Técnica
- **Gerenciamento de Estado com `Provider`**: A tela utiliza o `UserDataProvider` via `Provider.of` para acessar a lista de cartões e definir qual está selecionado. Esse padrão centraliza o estado do usuário e facilita a consistência entre telas.
- **`ListView` Dinâmico com `Builder`**: A estrutura de lista é feita com `ListView.builder` para escalar bem com múltiplos cartões e incluir, ao final da lista, um botão para adicionar um novo cartão.
- **Duplo `Navigator.pop`**: O fechamento da tela ocorre com dois `Navigator.pop()` consecutivos, garantindo o retorno à tela de checkout imediatamente após a escolha do cartão.

---
### Código comentado
```dart
// Tela para seleção de cartão de crédito
class CreditCardSelectionScreen extends StatelessWidget {
  const CreditCardSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa os dados do usuário via Provider
    final userData = Provider.of<UserDataProvider>(context);
    final cards = userData.creditCards;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Selecionar Cartão'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.highlightTextColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cards.length + 1, // +1 para incluir o botão de adicionar cartão
        itemBuilder: (context, index) {
          if (index < cards.length) {
            final card = cards[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.lightBackgroundColor,
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Define o cartão como selecionado no provider
                  userData.setSelectedCard(card);

                  // Fecha esta tela e a anterior (provavelmente tela de método de pagamento)
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card, color: AppColors.mainColor),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '**** **** **** ${card.last4Digits}',
                          style: const TextStyle(
                            color: AppColors.cardTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Ícone de confirmação para o cartão atualmente selecionado
                      if (userData.selectedCard == card)
                        const Icon(Icons.check, color: AppColors.mainColor),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Botão para adicionar um novo cartão
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navega para a tela de formulário de novo cartão
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddCreditCardScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar novo cartão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonsColor,
                  foregroundColor: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
```
---
## `select_address_screen.dart`

### Funcionalidade
A tela `SelectAddressScreen` permite ao usuário visualizar os endereços previamente cadastrados e selecionar um deles como endereço de entrega. Caso não haja endereços salvos, a tela exibe uma mensagem indicativa. Também é possível adicionar um novo endereço, que será salvo e incluído na lista. Ao tocar em um endereço:
- Ele é retornado diretamente pela função `Navigator.pop(context, address);`, permitindo à tela anterior (geralmente o checkout) utilizar esse endereço como o selecionado.

---
### Decisão Técnica
- **Gerenciamento de Estado com `Provider`**: A tela usa `context.watch<UserDataProvider>()` para obter a lista reativa de endereços, permitindo que a interface se atualize automaticamente ao adicionar novos.
- **Passagem de Dados com `Navigator.pop`**: A seleção de um endereço utiliza o `Navigator.pop(context, address)` para retornar o endereço selecionado à tela anterior, uma prática comum em formulários e seleções em cascata.
- **Callback Personalizado via `EditAddressScreen`**: O botão de adicionar endereço redireciona para a tela de edição e utiliza o parâmetro `onSave` como função de callback, atualizando o estado do provider ao salvar um novo endereço.

---
### Código comentado
```dart
// Tela responsável por permitir a seleção de um endereço
class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém a lista de endereços cadastrados do usuário
    final addressList = context.watch<UserDataProvider>().addresses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Endereço'),
      ),
      body: Column(
        children: [
          Expanded(
            child: addressList.isEmpty
                // Caso não haja endereços, mostra mensagem
                ? const Center(child: Text('Nenhum endereço cadastrado.'))
                // Caso haja endereços, exibe em formato de lista
                : ListView.builder(
                    itemCount: addressList.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final address = addressList[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            '${address.street}, ${address.number}',
                            style: AppTextStyles.body,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${address.neighborhood}, ${address.city} - ${address.state}'),
                              Text('${address.cep} — ${address.label}'),
                              if (address.description.isNotEmpty)
                                Text(address.description),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          // Retorna o endereço selecionado ao fechar a tela
                          onTap: () {
                            Navigator.pop(context, address);
                          },
                        ),
                      );
                    },
                  ),
          ),
          // Botão para adicionar um novo endereço
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAddressScreen(
                      // Callback chamado ao salvar novo endereço
                      onSave: (newAddress) {
                        context.read<UserDataProvider>().addAddress(newAddress);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar novo endereço'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonsColor,
                foregroundColor: AppColors.backgroundColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

