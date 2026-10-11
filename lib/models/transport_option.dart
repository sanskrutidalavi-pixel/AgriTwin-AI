/// Represents a logistics dispatch option for farm produce
class TransportOption {
  final String id;
  final String title;
  final double cost;
  final String durationText;
  final String statusText;
  final bool isAiRecommended;
  final String? comparisonNote;
  final String description;

  const TransportOption({
    required this.id,
    required this.title,
    required this.cost,
    required this.durationText,
    required this.statusText,
    this.isAiRecommended = false,
    this.comparisonNote,
    required this.description,
  });
}
