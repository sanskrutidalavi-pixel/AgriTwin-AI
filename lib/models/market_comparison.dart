/// Model representing market net profit comparison after transport and spoilage costs
class MarketComparison {
  final String name;
  final double grossPricePerQuintal;
  final double transportCostPerQuintal;
  final double spoilageCostPerQuintal;
  final double netProfitPerQuintal;
  final bool isAiRecommended;
  final String distanceInfo;

  const MarketComparison({
    required this.name,
    required this.grossPricePerQuintal,
    required this.transportCostPerQuintal,
    required this.spoilageCostPerQuintal,
    required this.netProfitPerQuintal,
    this.isAiRecommended = false,
    this.distanceInfo = '',
  });
}
