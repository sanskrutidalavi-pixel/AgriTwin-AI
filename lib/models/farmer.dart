/// Represents a verified farmer in the AgriTwin digital twin network
class Farmer {
  final String id;
  final String name;
  final String district;
  final String state;
  final double landSizeAcres;
  final List<String> primaryCrops;
  final int creditScore;
  final bool kycVerified;
  final String phoneNumber;
  final String digitalTwinId;
  final double totalYieldEstimatedQuintals;

  const Farmer({
    required this.id,
    required this.name,
    required this.district,
    required this.state,
    required this.landSizeAcres,
    required this.primaryCrops,
    required this.creditScore,
    required this.kycVerified,
    required this.phoneNumber,
    required this.digitalTwinId,
    required this.totalYieldEstimatedQuintals,
  });

  String get locationString => '$district, $state';
}
