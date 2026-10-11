import 'risk_level.dart';

/// Represents a scenario in the profit simulation
class ProfitScenario {
  final String title;
  final String timeFrame;
  final double expectedProfit;
  final RiskLevel risk;
  final bool isAiRecommended;
  final String description;

  const ProfitScenario({
    required this.title,
    required this.timeFrame,
    required this.expectedProfit,
    required this.risk,
    this.isAiRecommended = false,
    this.description = '',
  });
}
