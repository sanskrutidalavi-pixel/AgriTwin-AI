import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../l10n/app_localizations.dart';
import '../transactions/transaction_detail_screen.dart';

/// Screen presenting actionable real-time digital twin urgency alerts
class SmartAlertScreen extends StatelessWidget {
  const SmartAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Smart Alert')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 84.0),
              children: [
                // Urgent Alert Banner Card
                AppCard(
                  padding: const EdgeInsets.all(18.0),
                  backgroundColor: AppColors.urgentLight,
                  borderColor: AppColors.urgent.withValues(alpha: 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.urgent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.tr(MockData.smartAlertTitle),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.urgent,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  AppLocalizations.tr('Digital Twin Telemetry Alert • Lot #AT-TOM-1000'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Key Information Table
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.urgent.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              AppLocalizations.tr('Safe storage remaining'),
                              AppLocalizations.tr(MockData.smartAlertSafeStorageRemaining),
                              valueColor: AppColors.urgent,
                              isBold: true,
                            ),
                            const Divider(height: 14),
                            _buildInfoRow(AppLocalizations.tr('Current demand'), '${MockData.smartAlertDemandKg.toInt()} kg'),
                            const Divider(height: 14),
                            _buildInfoRow(AppLocalizations.tr('Available offer'), '₹${MockData.smartAlertOfferPricePerKg.toInt()}/kg'),
                            const Divider(height: 14),
                            _buildInfoRow(
                              AppLocalizations.tr('Potential revenue'),
                              '₹${MockData.smartAlertPotentialRevenue.toInt()}',
                              valueColor: AppColors.positive,
                              isBold: true,
                            ),
                            const Divider(height: 14),
                            _buildInfoRow(
                              AppLocalizations.tr('AI Recommendation'),
                              AppLocalizations.tr(MockData.smartAlertRecommendation),
                              valueColor: AppColors.primary,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Brief explanation text
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.tr(MockData.smartAlertExplanation),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showWhatsappAlertModal(context),
                          icon: const Icon(Icons.mark_chat_unread_rounded, color: Colors.green),
                          label: Text(
                            AppLocalizations.tr('Preview WhatsApp / Push Alert'),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons: "Sell Now" & "Later"
                PrimaryButton(
                  label: AppLocalizations.tr('Sell Now'),
                  icon: Icons.flash_on_rounded,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TransactionDetailScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: AppLocalizations.tr('Later'),
                  icon: Icons.schedule_rounded,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.tr('Alert saved. You can return later.')),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
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

  void _showWhatsappAlertModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.mark_chat_unread_rounded, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.tr('WhatsApp Spoilage Alert'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCF8C6), // WhatsApp chat green
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🟢 AgriTwin AI Pune WhatsApp Bot:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                    const SizedBox(height: 6),
                    Text(
                      AppLocalizations.tr(
                        '⚠️ CRITICAL SPOILAGE NOTIFICATION!\n\n'
                        'Farmer Ramesh Patil, your Tomato harvest lot (1,000 kg) has 24 HOURS remaining ambient shelf life.\n\n'
                        '💡 Recommended Action:\n'
                        '1. Sell 600 kg to Shree Gurukrupa Restaurant Deccan Pune @ ₹30/kg.\n'
                        '2. Transfer 400 kg to Sahyadri Cold Storage Hadapsar Pune @ ₹2.5/kg/day.\n\n'
                        'Avoid ₹12,000 potential decay loss! Reply YES to confirm booking.',
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(AppLocalizations.tr('Acknowledge Alert'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
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
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isBold ? 13 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
