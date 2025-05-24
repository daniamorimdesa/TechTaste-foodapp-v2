#  Estrutura de Pastas e Arquivos

Este projeto segue uma arquitetura modular, com foco em separação de responsabilidades. Abaixo está uma visão detalhada da estrutura da pasta `lib/`, com a função de cada arquivo e pasta:

---

## 📁 lib/data  
Contém os dados simulados (mock) utilizados para desenvolvimento e testes visuais.

- `categories_data.dart`: lista de categorias simuladas.
- `restaurant_data.dart`: lista de restaurantes com seus pratos e dados.

---

## 📁 lib/model  
Modelos de dados principais da aplicação, representando as entidades do sistema.

- `address.dart`: modelo de endereço.
- `credit_card.dart`: modelo de cartão de crédito.
- `dish.dart`: modelo de prato.
- `payment.dart`: modelo de forma de pagamento.
- `restaurant.dart`: modelo de restaurante.

### 📁 widgets  
Widgets relacionados a entidades de modelo (ex: AppBar genérica).

- `appbar.dart`: AppBar customizada reutilizável em várias telas.

---

## 📁 lib/ui/_core  
Recursos centrais do app, como tema, estilos e gerenciadores de estado globais.

- `app_colors.dart`: paleta de cores do app.
- `app_text_styles.dart`: estilos de texto.
- `app_theme.dart`: tema principal do app (`ThemeData`).
- `primary_button.dart`: botão padrão reutilizável.

### 📁 providers  
Gerencia o estado global da aplicação.

- `bag_provider.dart`: gerencia os itens no carrinho.
- `user_data_provider.dart`: gerencia dados do usuário (endereços, cartões etc).

---

## 📁 lib/ui/account  
Telas e widgets relacionados à conta do usuário.

- `account_screen.dart`: tela principal da conta.
- `address_list_screen.dart`: exibe todos os endereços cadastrados.
- `credit_card_form_screen.dart`: formulário para adicionar/editar cartão.
- `credit_card_list_screen.dart`: lista de cartões do usuário.
- `edit_address_screen.dart`: adição/edição de endereço existente.
- `edit_user_data_screen.dart`: adição/edição de dados do usuário.

### 📁 widgets  
- `user_section_card.dart`: componente para exibição dos dados do usuário.

---

## 📁 lib/ui/checkout  
Fluxo de finalização de compra.

- `checkout_screen.dart`: resumo e conclusão do pedido.
- `order_confirmation_screen.dart`: confirmação do pedido.
- `payment_selection_screen.dart`: seleção de forma de pagamento.
- `select_address_screen.dart`: seleção de endereço de entrega.
- `select_cash_change_screen.dart`: valor para troco (pagamento em dinheiro).
- `select_credit_card_screen.dart`: seleção de cartão de crédito.

### 📁 widgets  
- `address_card.dart`: exibe um cartão de endereço.
- `bag_items_list.dart`: lista de itens no carrinho.
- `clean_button_bag.dart`: botão para esvaziar carrinho.
- `order_summary_card.dart`: resumo dos valores.
- `payment_method_card.dart`: exibe o método de pagamento selecionado.

---

## 📁 lib/ui/dish  
Telas de visualização e detalhes dos pratos.

- `all_dishes_screen.dart`: tela com todos os pratos disponíveis.
- `dish_details_screen.dart`: detalhes de um prato específico.

### 📁 widgets  
- `dish_card.dart`: card visual de um prato.
- `most_ordered_dishes.dart`: seção com os pratos mais pedidos.

---

## 📁 lib/ui/home  
Tela inicial e seus componentes.

- `home_screen.dart`: tela principal com categorias e restaurantes.
- `search_results_screen.dart`: tela que exibe os resultados da busca.

### 📁 widgets  
- `category_widget.dart`: botão visual de categoria.
- `home_drawer_button.dart`: botão do menu lateral.
- `home_drawer.dart`: menu lateral personalizado.
- `restaurant_widget.dart`: card de restaurante.
- `search_bar_widget.dart`: barra de busca.

---

## 📁 lib/ui/restaurant  
Tela de visualização de um restaurante específico.

- `restaurant_screen.dart`: exibe os pratos e dados do restaurante.

### 📁 widgets  
- `see_more_button.dart`: botão "ver mais" para visualizar todos os pratos.

---

## 📁 lib/ui/splash  
Tela de boas-vindas.

- `splash_screen.dart`: tela de abertura do app.
- `splash_screen_button.dart`: botão de entrada na aplicação.

---

## 📁 lib/utils  
Funções utilitárias para lógica auxiliar.

- `frete_utils.dart`: cálculo do frete de acordo com a distância do restaurante mockada no json.

---

## 📄 lib/main.dart  
Ponto de entrada da aplicação. Define o tema, rotas e a tela inicial (`SplashScreen`).

---

## ✅ Boas práticas aplicadas

- **Modularização por tela**: cada área da interface possui seus próprios widgets e lógica encapsulados.
- **Gerenciamento de estado com Provider**: separação clara entre lógica de negócio e interface.
- **Uso de dados mockados**: facilita o desenvolvimento visual sem depender de back-end.
- **Design System próprio**: arquivos centrais de estilo garantem consistência visual.

---
