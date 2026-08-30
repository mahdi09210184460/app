class SocialService {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final double pricePer1000;
  final int minQuantity;
  final int maxQuantity;

  SocialService({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.pricePer1000,
    required this.minQuantity,
    required this.maxQuantity,
  });
}
