/// Types of agricultural storage infrastructure
enum StorageType {
  coldStorage,
  dryWarehouse,
  hermeticSilo;

  String get displayName {
    switch (this) {
      case StorageType.coldStorage:
        return 'Cold Storage';
      case StorageType.dryWarehouse:
        return 'Standard Warehouse';
      case StorageType.hermeticSilo:
        return 'Hermetic Grain Silo';
    }
  }
}

/// Storage & Warehousing facility with real-time digital twin monitoring
class StorageFacility {
  final String id;
  final String facilityName;
  final StorageType storageType;
  final String location;
  final double distanceKm;
  final double capacityQuintals;
  final double availableCapacityQuintals;
  final double monthlyRentPerQuintal;
  final double currentTempCelsius;
  final double humidityPercentage;
  final bool governmentSubsidized;
  final bool wdraRegistered; // Warehousing Development and Regulatory Authority

  const StorageFacility({
    required this.id,
    required this.facilityName,
    required this.storageType,
    required this.location,
    required this.distanceKm,
    required this.capacityQuintals,
    required this.availableCapacityQuintals,
    required this.monthlyRentPerQuintal,
    required this.currentTempCelsius,
    required this.humidityPercentage,
    required this.governmentSubsidized,
    required this.wdraRegistered,
  });

  double get utilizationPercentage =>
      ((capacityQuintals - availableCapacityQuintals) / capacityQuintals) * 100;
}
