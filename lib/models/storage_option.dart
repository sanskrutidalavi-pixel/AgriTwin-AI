/// Represents a warehousing or cold storage facility option
class StorageOption {
  final String id;
  final String name;
  final double ratePerKgPerDay;
  final double distanceKm;
  final String capacityText;
  final bool isAiRecommended;
  final double dailyCostFor400Kg;
  final double potentialSavingPerDay;

  const StorageOption({
    required this.id,
    required this.name,
    required this.ratePerKgPerDay,
    required this.distanceKm,
    required this.capacityText,
    this.isAiRecommended = false,
    required this.dailyCostFor400Kg,
    this.potentialSavingPerDay = 0.0,
  });
}
