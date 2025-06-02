# Pasta `checkout/`

| Checkout Screen top |  Checkout Screen bottom  |  Checkout Screen finalização  | 
|----------------|------------------------|------------------------|
| ![account screen](../assets/screenshots/account_screen.png) | ![account screen mockup](../assets/screenshots/edit_user_data.png) |![account screen mockup](../assets/screenshots/account_screen_mock.png) |

> ⚠️ **Observação**:  
> Os dados exibidos nas capturas de tela foram gerados automaticamente para fins de simulação, utilizando a ferramenta gratuita [4Devs - Gerador de Pessoas](https://www.4devs.com.br/computacao).  
> Nenhuma informação real de usuário foi utilizada.

## Funcionalidade
Este módulo é responsável por gerenciar o **fluxo de checkout**, permitindo que o usuário:

- Revise o pedido e os itens da sacola
- Escolha ou altere o endereço de entrega
- Selecione o método de pagamento (cartão, dinheiro ou pix)
- Informe o troco (caso escolha pagamento em dinheiro)
- Finalize e confirme o pedido

---
## Decisão Técnica

- A **taxa de entrega** (frete) é calculada utilizando a função `calcularFrete()` presente em `frete_utils.dart`, com base na distância (em km) mockada no json
- O método de pagamento em cartão de crédito está integrado aos dados salvos da conta do usuário
- O valor total do pedido mostrado em `order_summary_card.dart` inclui:
  - Subtotal (soma dos valores dos pratos)
  - Taxa de entrega (frete)
  - Valor do troco esperado para o usuário em caso de paagamento em dinheiro
    
---
## Estrutura de Arquivos

### Visão geral das telas

| Tela                             | Descrição                                                                                                                         |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `checkout_screen.dart`           | Tela principal de finalização do pedido, onde o usuário vê o resumo da compra, endereço de entrega e escolhe a forma de pagamento |
| `order_confirmation_screen.dart` | Exibe a confirmação do pedido após a finalização                                                                                  |
| `payment_selection_screen.dart`  | Permite ao usuário escolher entre pagamento com cartão, dinheiro ou pix                                                           |
| `select_address_screen.dart`     | Permite selecionar um endereço salvo ou adicionar um novo                                                                         |
| `select_cash_change_screen.dart` | Caso o pagamento seja em dinheiro, permite informar o valor para troco                                                            |
| `select_credit_card_screen.dart` | Permite escolher um cartão de crédito para o pagamento                                                                            |


### Visão geral dos widgets

| Widget                      | Descrição                                                               |
|-----------------------------|-------------------------------------------------------------------------|
| `address_card.dart`         | Exibe o endereço do usuário em formato de card, podendo ser selecionado |
| `bag_items_list.dart`       | Lista os itens presentes na sacola de compras                           |
| `clean_button_bag.dart`     | Botão para limpar a sacola de compras                                   |
| `order_summary_card.dart`   | Mostra os valores: subtotal, taxa de entrega (frete) e total            |
| `payment_method_card.dart`  | Widget visual para exibir opções de pagamento                           |

---


