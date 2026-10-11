import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_header.dart';
import '../../l10n/app_localizations.dart';
import '../logistics/logistics_screen.dart';

/// Screen illustrating collective farmer aggregation to fulfill bulk buyer requirements
class FpoAggregationScreen extends StatelessWidget {
  const FpoAggregationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contributions = MockData.fpoFarmerContributions;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.tr('FPO Aggregation')),
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
                // Top Collective Selling Opportunity Card
                AppCard(
                  padding: const EdgeInsets.all(18.0),
                  backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.4),
                  borderColor: AppColors.primary.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.hub_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.tr('Collective Selling Opportunity'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  AppLocalizations.tr('Solapur & Dharashiv Tomato FPO Cluster'),
                                  style: const TextStyle(
                                    fontSize: 12,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.tr('Buyer Requirement'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const Text(
                              '1200 kg',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Farmer Contributions Header
                SectionHeader(
                  title: AppLocalizations.tr('Farmer Contributions'),
                  subtitle: AppLocalizations.tr('Pooled batches for collective shipment'),
                ),
                const SizedBox(height: 6),

                // Contribution Cards
                ...contributions.map((contribution) {
                  final isYou = contribution.isCurrentFarmer;

                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(14.0),
                    borderColor: isYou
                        ? AppColors.primary
                        : AppColors.border,
                    backgroundColor: isYou
                        ? AppColors.primaryContainer.withValues(alpha: 0.3)
                        : Colors.white,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isYou
                              ? AppColors.primary
                              : AppColors.surfaceVariant,
                          child: Icon(
                            isYou ? Icons.person_rounded : Icons.person_outline_rounded,
                            color: isYou ? Colors.white : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      isYou
                                          ? '${contribution.farmerName} (${AppLocalizations.tr('You')})'
                                          : contribution.farmerName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isYou ? FontWeight.w800 : FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isYou) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        AppLocalizations.tr('Your Lot'),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${AppLocalizations.tr(contribution.crop)} • ${contribution.location}',
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
                        const SizedBox(width: 10),
                        Text(
                          '${contribution.quantityKg.toInt()} kg',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isYou ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // Aggregation Visualization Equation Card
                AppCard(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.tune_rounded,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.tr('Aggregation Formula'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Step by step formula
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: const [
                            _FormulaChip(value: '300 kg', label: 'Rajesh'),
                            Text('+', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                            _FormulaChip(value: '400 kg', label: 'Farmer A'),
                            Text('+', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                            _FormulaChip(value: '500 kg', label: 'Farmer B'),
                            Text('=', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            _FormulaChip(value: '1200 kg', label: 'Total', isHighlight: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.positiveLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.positive.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.positive, size: 18),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                AppLocalizations.tr('Buyer requirement fulfilled'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.positive,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // AI Benefits Card
                AppCard(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.tr('AI Benefit'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildBenefitBullet(AppLocalizations.tr('Lower transportation cost via shared freight')),
                      _buildBenefitBullet(AppLocalizations.tr('Better bargaining power against large institutions')),
                      _buildBenefitBullet(AppLocalizations.tr('Full buyer requirement fulfilled in a single dispatch')),
                      _buildBenefitBullet(AppLocalizations.tr('Reduced wastage through pre-scheduled collection')),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // CTA Button: Optimize Logistics
                PrimaryButton(
                  label: AppLocalizations.tr('Optimize Logistics'),
                  icon: Icons.local_shipping_rounded,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LogisticsScreen(),
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

  static Widget _buildBenefitBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_rounded,
            size: 16,
            color: AppColors.positive,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormulaChip extends StatelessWidget {
  final String value;
  final String label;
  final bool isHighlight;

  const _FormulaChip({
    required this.value,
    required this.label,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 12 : 11,
              fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w700,
              color: isHighlight ? AppColors.primary : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isHighlight ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
