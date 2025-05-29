# Pasta `account/`

## Funcionalidade

A pasta `ui/account` contém todas as telas e componentes relacionados à conta do usuário. Isso inclui:

- A tela principal da conta (`account_screen.dart`)
- Listagem e edição de endereços e cartões de crédito
- Atualização dos dados pessoais
- Componentes reutilizáveis para navegação entre seções

O objetivo principal é proporcionar ao usuário um acesso rápido e organizado às informações sensíveis da sua conta, com foco em usabilidade e segurança.

---

## Decisão Técnica

- Utilização de `Navigator.pushNamed()` para navegação entre telas
- Organização das telas por responsabilidade única: edição de dados, endereços e cartões possuem suas próprias screens
- Criação do widget `UserSectionCard` para reutilização dos blocos de acesso às seções da conta
- Uso de `Form` e `TextFormField` com validação local nos formulários de edição
- Todas as telas são compatíveis com a arquitetura atual do projeto, podendo ser integradas facilmente com os `providers` de autenticação e dados

---

## Estrutura de Arquivos

| Arquivo                          | Descrição                                                                 |
|----------------------------------|---------------------------------------------------------------------------|
| `account_screen.dart`            | Tela principal da conta com atalhos para dados, endereços e cartões       |
| `address_list_screen.dart`       | Lista os endereços cadastrados com opção de editar e adicionar            |
| `credit_card_form_screen.dart`   | Tela para cadastrar ou editar cartões de crédito                          |
| `credit_card_list_screen.dart`   | Lista de cartões cadastrados com botões de ação                           |
| `edit_address_screen.dart`       | Formulário de edição de endereço com validações básicas                   |
| `edit_user_data_screen.dart`     | Permite edição dos dados pessoais do usuário                              |
| `widgets/user_section_card.dart` | Componente visual de atalho reutilizável entre seções                     |

---
## Observações Finais
- A modularização favorece testes unitários e manutenção futura
- Os componentes podem ser facilmente reaproveitados em futuras funcionalidades como "preferências do usuário" ou "segurança da conta"
- Todas as telas estão prontas para integração com o backend de autenticação e banco de dados do Firebase

