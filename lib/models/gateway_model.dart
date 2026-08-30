class PaymentGateway {
  final String id;
  String name;
  String url;
  bool isActive;

  PaymentGateway({
    required this.id,
    required this.name,
    required this.url,
    this.isActive = true,
  });
}
