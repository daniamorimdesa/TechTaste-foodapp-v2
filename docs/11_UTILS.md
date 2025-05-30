# Pasta `utils/`

A pasta `utils` centraliza funções utilitárias reutilizáveis que abstraem lógicas específicas do domínio da aplicação. Essas funções promovem:
- Reuso de código
- Clareza e organização
- Manutenção simplificada

Atualmente, a pasta contém:

## `frete_utils.dart`
Este arquivo implementa a lógica de cálculo de frete para os pedidos realizados no app **TechTaste**. 
O valor do frete é dinâmico e depende da distância (em quilômetros) entre o restaurante e o endereço de entrega do usuário.

### Função: `calcularFrete`
```dart

double calcularFrete(
  int distanciaKm, {
  double taxaBase = 3.0,
  double valorPorKm = 2.0,
}) {
  return taxaBase + (valorPorKm * distanciaKm);
}

```
---
### Parâmetros:
- `distanciaKm` (**int**): Distância entre o restaurante e o usuário, em quilômetros
- `taxaBase` (**double**, opcional): Valor fixo aplicado a todos os pedidos (`default: 3.0`)
- `valorPorKm` (**double**, opcional): Custo adicional por quilômetro percorrido (`default: 2.0`)
---  
### Retorno: 
Retorna o valor total do frete como double.

---
### Exemplo de uso:
```dart

final frete = calcularFrete(5); // Resultado: 13.0
// 3.0 (taxa base) + 2.0 * 5 km = 13.0

```
---
### Justificativa Técnica
- A função é **pura**, ou seja, não depende de variáveis externas, o que a torna **testável e confiável**
- Os parâmetros default permitem reutilização com flexibilidade, mantendo lógica padrão centralizada
- Isolar essa lógica em `utils` favorece a consistência ao longo do app e permite fácil atualização caso a política de frete mude no futuro

Este utilitário será utilizado no **Checkout**, para compor o valor final do pedido, juntamente com os itens escolhidos pelo usuário.
