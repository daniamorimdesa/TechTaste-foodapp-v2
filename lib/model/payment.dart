enum PaymentMethodType { card, pix, cash }

class CashPaymentInfo {
  final double? changeFor;

  CashPaymentInfo({this.changeFor});
}
