double calcularFrete(
  int distanciaKm, {
  double taxaBase = 3.0,
  double valorPorKm = 2.0,
}) {
  return taxaBase + (valorPorKm * distanciaKm);
}
