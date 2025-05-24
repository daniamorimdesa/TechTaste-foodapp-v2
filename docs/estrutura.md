# Estrutura e Organização do Projeto

Este documento tem como objetivo descrever as decisões de arquitetura, estrutura de pastas, organização do código e raciocínios por trás do desenvolvimento da versão 2.0 do aplicativo **TechTaste – Food Delivery App**.

---

##  Objetivo do Projeto

Criar uma experiência realista de um aplicativo de delivery de alimentos, com interface amigável, fluxo completo de pedido e estrutura modular para facilitar a manutenção e expansão futura.
Esse projeto surgiu a partir dos estudos da Imersão Mobile da Alura, realizada em abril de 2025. Durante o mês de maio eu continuei expandindo até o presente resultado.

---

##  Estrutura de Pastas

Este projeto segue uma arquitetura modular, com foco em separação de responsabilidades. Abaixo está uma visão geral da estrutura da pasta `lib/`, destacando a finalidade de cada área principal:

```txt
lib/
├── data/             # Dados simulados (mock) para testes e desenvolvimento
│   ├── categories_data.dart
│   └── restaurant_data.dart
│
├── model/            # Modelos de dados principais
│   ├── address.dart
│   ├── credit_card.dart
│   ├── dish.dart
│   ├── payment.dart
│   ├── restaurant.dart
│   └── widgets/
│       └── appbar.dart
│
├── ui/               # Interface e telas da aplicação
│   ├── _core/        # Tema, estilos e gerenciamento de estado global
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_theme.dart
│   │   ├── primary_button.dart
│   │   └── providers/
│   │       ├── bag_provider.dart
│   │       └── user_data_provider.dart
│   │
│   ├── account/      # Telas e widgets da conta do usuário
│   │   ├── account_screen.dart
│   │   ├── address_list_screen.dart
│   │   ├── credit_card_form_screen.dart
│   │   ├── credit_card_list_screen.dart
│   │   ├── edit_address_screen.dart
│   │   ├── edit_user_data_screen.dart
│   │   └── widgets/
│   │       └── user_section_card.dart
│   │
│   ├── checkout/     # Fluxo de finalização de pedidos
│   │   ├── checkout_screen.dart
│   │   ├── order_confirmation_screen.dart
│   │   ├── payment_selection_screen.dart
│   │   ├── select_address_screen.dart
│   │   ├── select_cash_change_screen.dart
│   │   ├── select_credit_card_screen.dart
│   │   └── widgets/
│   │       ├── address_card.dart
│   │       ├── bag_items_list.dart
│   │       ├── clean_button_bag.dart
│   │       ├── order_summary_card.dart
│   │       └── payment_method_card.dart
│   │
│   ├── dish/         # Telas e componentes relacionados a pratos
│   │   ├── all_dishes_screen.dart
│   │   ├── dish_details_screen.dart
│   │   └── widgets/
│   │       ├── dish_card.dart
│   │       └── most_ordered_dishes.dart
│   │
│   ├── home/         # Tela principal do app
│   │   ├── home_screen.dart
│   │   ├── search_results_screen.dart
│   │   └── widgets/
│   │       ├── category_widget.dart
│   │       ├── home_drawer.dart
│   │       ├── home_drawer_button.dart
│   │       ├── restaurant_widget.dart
│   │       └── search_bar_widget.dart
│   │
│   ├── restaurant/   # Visualização de restaurante
│   │   ├── restaurant_screen.dart
│   │   └── widgets/
│   │       └── see_more_button.dart
│   │
│   └── splash/       # Tela de boas-vindas
│       ├── splash_screen.dart
│       └── splash_screen_button.dart
│
├── utils/            # Funções auxiliares
│   └── frete_utils.dart
│
└── main.dart         # Ponto de entrada da aplicação
