/// Represents a farmer's individual batch contribution to an FPO pool
class FpoFarmerContribution {
  final String farmerName;
  final String crop;
  final double quantityKg;
  final String location;
  final bool isCurrentFarmer;

  const FpoFarmerContribution({
    required this.farmerName,
    required this.crop,
    required this.quantityKg,
    required this.location,
    this.isCurrentFarmer = false,
  });
}
