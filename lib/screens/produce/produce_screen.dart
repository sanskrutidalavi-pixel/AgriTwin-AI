import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/risk_level.dart';
import '../../widgets/app_card.dart';
import '../../widgets/risk_badge.dart';
import '../../widgets/section_header.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';
import 'add_produce_screen.dart';
import '../ai_analysis/ai_analysis_screen.dart';

/// My Produce screen showcasing tracked harvest batches and dynamic lot registration with visual crop photos
class ProduceScreen extends StatefulWidget {
  final bool showBackButton;

  const ProduceScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<ProduceScreen> createState() => _ProduceScreenState();
}

class _ProduceScreenState extends State<ProduceScreen> {
  String _getCropEmoji(String cropName) {
    final name = cropName.toLowerCase();
    if (name.contains('onion')) return '🧅';
    if (name.contains('potato')) return '🥔';
    if (name.contains('wheat')) return '🌾';
    if (name.contains('soybean') || name.contains('soy')) return '🫘';
    if (name.contains('cotton')) return '☁️';
    if (name.contains('capsicum') || name.contains('chilli')) return '🫑';
    if (name.contains('corn') || name.contains('maize')) return '🌽';
    if (name.contains('rice') || name.contains('paddy')) return '🌾';
    return '🍅';
  }

  @override
  Widget build(BuildContext context) {
    final batches = MockData.registeredHarvestBatches;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Produce')),
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProduceScreen()),
              );
              setState(() {});
            },
            tooltip: AppLocalizations.tr('Register New Harvest'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 84.0),
              children: [
                SectionHeader(
                  title: AppLocalizations.tr('Active Monitored Batches'),
                  subtitle: AppLocalizations.tr('Digital Twin & AI Decision Support System for Pune Farmers'),
                ),
                const SizedBox(height: 10),

                // Register New Harvest Batch Prominent Action Card
                SecondaryButton(
                  label: '${AppLocalizations.tr("Register New Harvest")} (+)',
                  icon: Icons.add_circle_outline_rounded,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddProduceScreen()),
                    );
                    setState(() {});
                  },
                  height: 48,
                ),

                const SizedBox(height: 16),

                // DYNAMIC LIST OF REGISTERED HARVEST BATCHES WITH VISUAL CROP PHOTOS
                ...batches.map((batch) {
                  final cropName = batch['cropName'] ?? 'Tomato';
                  final isGovtCert = (batch['govtCert'] ?? '').contains('AGMARK');
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: AppCard(
                      elevation: 2,
                      padding: const EdgeInsets.all(18.0),
                      borderColor: AppColors.primary.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row with Crop Photo Visual Box
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Visual Crop Photo Thumbnail Box
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF4D4D), Color(0xFFCC0000)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Center(
                                  child: Text(_getCropEmoji(cropName), style: const TextStyle(fontSize: 28)),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.tr(cropName),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textPrimary,
                                              letterSpacing: -0.3,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        RiskBadge(
                                          riskLevel: RiskLevel.medium,
                                          customLabel: AppLocalizations.tr('Active Lot'),
                                          isCompact: true,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      AppLocalizations.tr(batch['status'] ?? 'Monitored Lot #AT-TOM-2026'),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 12),

                          // Government Certificate Badge & Photo Verification Tag
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isGovtCert ? AppColors.positiveLight : AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(isGovtCert ? Icons.verified_user : Icons.workspace_premium, size: 14, color: isGovtCert ? AppColors.positive : AppColors.primary),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.tr(batch['govtCert'] ?? 'AGMARK Certified'),
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isGovtCert ? AppColors.positive : AppColors.primary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.positiveLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.camera_alt_rounded, size: 14, color: AppColors.positive),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.tr(batch['photoAttached'] ?? 'Crop Photo Verified'),
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.positive),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Grid of Produce Attributes
                          Row(
                            children: [
                              Expanded(
                                child: _ProduceField(
                                  label: AppLocalizations.tr('Harvest Quantity'),
                                  value: AppLocalizations.tr(batch['quantity'] ?? '1000 kg'),
                                  icon: Icons.scale_rounded,
                                  isPrimary: true,
                                ),
                              ),
                              Expanded(
                                child: _ProduceField(
                                  label: AppLocalizations.tr('Quality Grade'),
                                  value: AppLocalizations.tr(batch['grade'] ?? 'Grade A'),
                                  icon: Icons.verified_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _ProduceField(
                                  label: AppLocalizations.tr('Harvest Date'),
                                  value: batch['harvestDate'] ?? '01-Sep-2026',
                                  icon: Icons.calendar_today_rounded,
                                ),
                              ),
                              Expanded(
                                child: _ProduceField(
                                  label: AppLocalizations.tr('Place of Harvest'),
                                  value: batch['location'] ?? 'Haveli Farm Plot #4, Pune',
                                  icon: Icons.location_on_rounded,
                                  valueColor: AppColors.primary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 12),

                          // Storage Telemetry Row
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.store_rounded, color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.tr(batch['storageStatus'] ?? 'Sahyadri Cold Storage Hadapsar (₹2.5/kg/day)'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Main Call to Action: Analyze with AI
                          PrimaryButton(
                            label: AppLocalizations.tr('Analyze Batch with AI'),
                            icon: Icons.auto_awesome_rounded,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AiAnalysisScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Standing Batches
                SectionHeader(
                  title: AppLocalizations.tr('Upcoming Harvest Batches'),
                  subtitle: AppLocalizations.tr('Scheduled for upcoming field harvest'),
                ),
                const SizedBox(height: 6),

                AppCard(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(child: Text('🫘', style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.tr('Soybean (JS 335)'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${AppLocalizations.tr("Estimated 600 kg")} • ${AppLocalizations.tr("Harvesting in 18 days")} (Haveli Plot #2)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      RiskBadge(
                        riskLevel: RiskLevel.low,
                        customLabel: AppLocalizations.tr('Low Risk'),
                        isCompact: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProduceField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isPrimary;
  final Color? valueColor;

  const _ProduceField({
    required this.label,
    required this.value,
    required this.icon,
    this.isPrimary = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isPrimary ? 14 : 12,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
