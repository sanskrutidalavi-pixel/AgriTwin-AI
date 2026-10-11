/// Vehicle and fleet classification for agricultural transport
enum VehicleType {
  miniTruck,
  standardTruck,
  heavyTruck,
  reeferRefrigerated;

  String get displayName {
    switch (this) {
      case VehicleType.miniTruck:
        return 'Tata Ace / 1.5T';
      case VehicleType.standardTruck:
        return 'Open Truck / 5T';
      case VehicleType.heavyTruck:
        return 'Multi-Axle / 16T';
      case VehicleType.reeferRefrigerated:
        return 'Cold Reefer / 8T';
    }
  }
}

/// Logistics & Transportation partner
class LogisticsProvider {
  final String id;
  final String providerName;
  final VehicleType vehicleType;
  final double capacityQuintals;
  final double baseRatePerKm;
  final int estimatedPickupHours;
  final double rating;
  final bool coldChainCapable;
  final bool gpsLiveTracking;
  final String contactNumber;

  const LogisticsProvider({
    required this.id,
    required this.providerName,
    required this.vehicleType,
    required this.capacityQuintals,
    required this.baseRatePerKm,
    required this.estimatedPickupHours,
    required this.rating,
    required this.coldChainCapable,
    required this.gpsLiveTracking,
    required this.contactNumber,
  });

  double estimateTripCost(double distanceKm) {
    return 500 + (distanceKm * baseRatePerKm);
  }
}
