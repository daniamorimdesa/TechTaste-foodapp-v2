# Estrutura e Organização do Projeto

Este documento tem como objetivo descrever as decisões de arquitetura, estrutura de pastas, organização do código e raciocínios por trás do desenvolvimento da versão 2.0 do aplicativo **TechTaste – Food Delivery App**.

---

##  Objetivo do Projeto

Criar uma experiência realista de um aplicativo de delivery de alimentos, com interface amigável, fluxo completo de pedido e estrutura modular para facilitar a manutenção e expansão futura.
Esse projeto surgiu a partir dos estudos da Imersão Mobile da Alura, realizada em abril de 2025. Durante o mês de maio eu continuei expandindo até o presente resultado.

---

##  Estrutura de Pastas
Este projeto segue uma arquitetura modular, com foco em separação de responsabilidades. Abaixo está uma visão detalhada da estrutura da pasta lib/, com a função de cada arquivo/pasta:


```txt
lib/
├── models/         # Modelos de dados (ex: Restaurant, Dish)
├── providers/      # Gerenciamento de estado com Provider
├── screens/        # Telas principais do app
├── ui/
│   ├── _core/      # Cores, estilos e temas
│   └── widgets/    # Componentes reutilizáveis
├── main.dart       # Ponto de entrada da aplicação
└── routes.dart     # Definição centralizada de rotas
