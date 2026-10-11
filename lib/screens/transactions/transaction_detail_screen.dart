import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import 'payment_success_screen.dart';

/// Screen allowing the farmer to confirm delivery and trigger escrow settlement
class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  bool _isProcessing = false;
  Timer? _processingTimer;

  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    _processingTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const PaymentSuccessScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _isProcessing
                ? _buildProcessingView()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 84.0),
                    children: [
                      // Header Order Card
                      AppCard(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.receipt_long_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Trade Invoice Summary',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Transaction ID: TRX-7025',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _buildInfoRow('Buyer', MockData.activeBuyerName),
                            const Divider(height: 16),
                            _buildInfoRow('Produce', MockData.activeProduceCrop),
                            const Divider(height: 16),
                            _buildInfoRow('Quantity', '${MockData.activeQuantityKg.toInt()} kg'),
                            const Divider(height: 16),
                            _buildInfoRow('Price', '₹${MockData.activePricePerKg.toInt()}/kg'),
                            const Divider(height: 16),
                            _buildInfoRow(
                              'Delivery',
                              'Confirmed',
                              valueColor: AppColors.positive,
                              isBold: true,
                            ),
                            const Divider(height: 16),
                            _buildInfoRow(
                              'Payment',
                              'Pending',
                              valueColor: AppColors.warning,
                              isBold: true,
                            ),
                            const Divider(height: 16),
                            _buildInfoRow(
                              'Subtotal',
                              '₹${MockData.activeTotalAmount.toInt()}',
                              valueColor: AppColors.primary,
                              isBold: true,
                              isHighlight: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Clear Equation Card
                      AppCard(
                        padding: const EdgeInsets.all(16.0),
                        backgroundColor: AppColors.primaryContainer.withOpacity(0.45),
                        borderColor: AppColors.primary.withOpacity(0.25),
                        child: Row(
                          children: const [
                            Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '300 kg × ₹31/kg = ₹9,300',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Primary Action Button
                      PrimaryButton(
                        label: 'Confirm Delivery & Payment',
                        icon: Icons.lock_open_rounded,
                        onPressed: _processPayment,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Processing transaction...',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Releasing escrow funds from ABC Hotel to Rajesh Patil bank account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isHighlight ? 17 : (isBold ? 14 : 13),
              fontWeight: (isHighlight || isBold) ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
