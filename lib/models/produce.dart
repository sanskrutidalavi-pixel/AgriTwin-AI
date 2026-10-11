import 'risk_level.dart';

/// Represents a harvested or standing produce lot tracked by AgriTwin digital twin
class Produce {
  final String id;
  final String cropName;
  final String variety;
  final double quantityQuintals;
  final DateTime harvestDate;
  final int storageLifeDaysRemaining;
  final double expectedPricePerQuintal;
  final double currentMarketPricePerQuintal;
  final String qualityGrade; // Grade A, Grade B, Export Grade
  final RiskLevel spoilageRisk;
  final String imageUrl;

  const Produce({
    required this.id,
    required this.cropName,
    required this.variety,
    required this.quantityQuintals,
    required this.harvestDate,
    required this.storageLifeDaysRemaining,
    required this.expectedPricePerQuintal,
    required this.currentMarketPricePerQuintal,
    required this.qualityGrade,
    required this.spoilageRisk,
    this.imageUrl = '',
  });

  double get estimatedTotalValue =>
      quantityQuintals * currentMarketPricePerQuintal;

  double get potentialTotalValue =>
      quantityQuintals * expectedPricePerQuintal;
}
