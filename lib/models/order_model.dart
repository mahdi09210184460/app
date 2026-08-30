enum OrderStatus { pending, processing, completed, canceled }

class AppOrder {
  final String id;
  final String serviceTitle;
  final String link;
  final int quantity;
  final double totalPrice;
  final DateTime date;
  OrderStatus status;

  AppOrder({
    required this.id,
    required this.serviceTitle,
    required this.link,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    this.status = OrderStatus.pending,
  });
}
