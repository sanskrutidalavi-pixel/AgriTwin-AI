/// Classification of verified agricultural buyers
enum BuyerType {
  hotel,
  restaurant,
  foodProcessor,
  caterer,
  fpo,
  wholesaler,
  retailChain,
  exporter;

  String get displayName {
    switch (this) {
      case BuyerType.hotel:
        return 'Hotel / Hospitality';
      case BuyerType.restaurant:
        return 'Commercial Restaurant';
      case BuyerType.foodProcessor:
        return 'Food Processor';
      case BuyerType.caterer:
        return 'Sujata / Commercial Caterer';
      case BuyerType.fpo:
        return 'FPO Collective';
      case BuyerType.wholesaler:
        return 'Licensed Wholesaler';
      case BuyerType.retailChain:
        return 'Agri-Retail Chain';
      case BuyerType.exporter:
        return 'Global Exporter';
    }
  }
}

/// Represents an institutional or verified buyer
class Buyer {
  final String id;
  final String companyName;
  final BuyerType buyerType;
  final String location;
  final double trustScore; // 0.0 - 5.0
  final String paymentTerms; // e.g., "Immediate via Escrow", "T+1 Settlement"
  final String activeDemandCrop;
  final double demandQuantityQuintals;
  final double offeredPricePerQuintal;
  final bool escrowProtected;
  final int completedDeals;
  final double pricePerKg;
  final double requiredKg;
  final double distanceKm;
  final double estimatedRevenue;
  final bool isAiRecommended;

  const Buyer({
    required this.id,
    required this.companyName,
    required this.buyerType,
    required this.location,
    required this.trustScore,
    required this.paymentTerms,
    required this.activeDemandCrop,
    required this.demandQuantityQuintals,
    required this.offeredPricePerQuintal,
    required this.escrowProtected,
    required this.completedDeals,
    this.pricePerKg = 0.0,
    this.requiredKg = 0.0,
    this.distanceKm = 0.0,
    this.estimatedRevenue = 0.0,
    this.isAiRecommended = false,
  });

  double get displayPricePerKg => pricePerKg > 0 ? pricePerKg : (offeredPricePerQuintal / 100);
  double get displayRequiredKg => requiredKg > 0 ? requiredKg : (demandQuantityQuintals * 100);
  double get displayRevenue => estimatedRevenue > 0 ? estimatedRevenue : (displayPricePerKg * displayRequiredKg);
}
