/// Lifecycle state of an agricultural trade transaction
enum TransactionStatus {
  inEscrow,
  dispatched,
  delivered,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case TransactionStatus.inEscrow:
        return 'In Escrow';
      case TransactionStatus.dispatched:
        return 'Dispatched';
      case TransactionStatus.delivered:
        return 'Delivered / Inspected';
      case TransactionStatus.completed:
        return 'Settled & Paid';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Trade transaction with smart contract/escrow tracking
class TransactionRecord {
  final String id;
  final String transactionId;
  final DateTime date;
  final String produceCrop;
  final String buyerName;
  final double quantityQuintals;
  final double ratePerQuintal;
  final double totalAmount;
  final TransactionStatus status;
  final String escrowReferenceId;

  const TransactionRecord({
    required this.id,
    required this.transactionId,
    required this.date,
    required this.produceCrop,
    required this.buyerName,
    required this.quantityQuintals,
    required this.ratePerQuintal,
    required this.totalAmount,
    required this.status,
    required this.escrowReferenceId,
  });
}
