import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import '../profit/profit_result_screen.dart';

/// Screen celebrating successful escrow payment settlement
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Payment Received')),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 84.0),
              children: [
                // Success Badge & Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.positiveLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.positive, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.positive,
                        size: 52,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    AppLocalizations.tr('Payment Received'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    '₹9,300',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.positive,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.positive,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppLocalizations.tr('Successful'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Transaction Details Card
                AppCard(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.tr('Settlement Details'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildDetailRow(AppLocalizations.tr('Buyer'), MockData.activeBuyerName),
                      const Divider(height: 16),
                      _buildDetailRow(AppLocalizations.tr('Transaction ID'), MockData.activeTransactionId),
                      const Divider(height: 16),
                      _buildDetailRow(AppLocalizations.tr('Produce'), '300 kg ${AppLocalizations.tr("Tomato")}'),
                      const Divider(height: 16),
                      _buildDetailRow(AppLocalizations.tr('Settlement Mode'), AppLocalizations.tr('Instant Escrow Bank Transfer')),
                      const Divider(height: 16),
                      _buildDetailRow(
                        AppLocalizations.tr('Status'),
                        AppLocalizations.tr('Payment Received'),
                        valueColor: AppColors.positive,
                        isBold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Confirmation Note Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.positiveLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.positive.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, color: AppColors.positive, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.tr('Your payment has been successfully received.'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.positive,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Primary CTA: View Profit Result
                PrimaryButton(
                  label: AppLocalizations.tr('View Profit Result'),
                  icon: Icons.trending_up_rounded,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfitResultScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
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
