/// Price trend direction for APMC Mandis
enum PriceTrend {
  up,
  down,
  stable;

  String get label {
    switch (this) {
      case PriceTrend.up:
        return 'Rising';
      case PriceTrend.down:
        return 'Falling';
      case PriceTrend.stable:
        return 'Stable';
    }
  }
}

/// Represents an APMC Mandi or benchmark trading center
class MarketMandi {
  final String id;
  final String mandiName;
  final String district;
  final String state;
  final double distanceKm;
  final String cropName;
  final double modalPricePerQuintal;
  final double minPricePerQuintal;
  final double maxPricePerQuintal;
  final PriceTrend trend;
  final double dailyArrivalsQuintals;
  final DateTime lastUpdated;

  const MarketMandi({
    required this.id,
    required this.mandiName,
    required this.district,
    required this.state,
    required this.distanceKm,
    required this.cropName,
    required this.modalPricePerQuintal,
    required this.minPricePerQuintal,
    required this.maxPricePerQuintal,
    required this.trend,
    required this.dailyArrivalsQuintals,
    required this.lastUpdated,
  });

  String get locationString => '$district, $state (${distanceKm.toStringAsFixed(0)} km)';
}
