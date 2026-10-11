import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/risk_level.dart';
import '../../widgets/app_card.dart';
import '../../widgets/risk_badge.dart';
import '../../widgets/section_header.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';

/// Dynamic Role-Aware Profile Screen (Farmer, Buyer, Transporter, Admin)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = MockData.activeUserRole;
    final farmer = MockData.sampleFarmer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.tr(
            role == 'Buyer'
                ? 'Buyer Commercial Profile'
                : role == 'Transportation Agency'
                    ? 'Transporter Agency Profile'
                    : role == 'Admin'
                        ? 'System Administrator Profile'
                        : 'Farmer Profile & Digital Twin',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.tr('$role settings & parameters loaded.')),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: AppLocalizations.tr('Settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              children: [
                // ================= BUYER PROFILE =================
                if (role == 'Buyer') ...[
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    borderColor: AppColors.primary.withValues(alpha: 0.3),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryContainer,
                          child: const Icon(
                            Icons.storefront_rounded,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Shree Gurukrupa Restaurant',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Deccan Gymkhana, FC Road, Pune',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'GSTIN: 27PUNER9910F1Z',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RiskBadge(
                          riskLevel: RiskLevel.low,
                          customLabel: AppLocalizations.tr('Verified Buyer'),
                          isCompact: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: AppLocalizations.tr('Buyer Commercial Details'),
                    subtitle: AppLocalizations.tr('Procurement credentials & escrow rating'),
                  ),
                  const SizedBox(height: 4),
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ProfileRow(
                          label: AppLocalizations.tr('Business Owner'),
                          value: 'Vijay Shetty (Proprietor)',
                          icon: Icons.person_outline_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Buyer Category'),
                          value: AppLocalizations.tr('Commercial Restaurant & Catering'),
                          icon: Icons.restaurant_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Contact Mobile'),
                          value: '+91 98220 99887',
                          icon: Icons.phone_android_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Preferred Crops'),
                          value: AppLocalizations.tr('Tomato (Abhinav), Onion, Capsicum'),
                          icon: Icons.shopping_bag_outlined,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Deals Completed'),
                          value: AppLocalizations.tr('412 Successful Deals (5.0 ★ Rating)'),
                          icon: Icons.star_rounded,
                        ),
                      ],
                    ),
                  ),
                ],

                // ================= TRANSPORTER PROFILE =================
                if (role == 'Transportation Agency') ...[
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    borderColor: Colors.amber.shade400,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.amber.shade100,
                          child: Icon(
                            Icons.local_shipping_rounded,
                            size: 32,
                            color: Colors.amber.shade900,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.tr('Pune Express Agri-Logistics'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppLocalizations.tr('Haveli & Gultekdi Hubs, Pune'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Permit: MH-PUNE-LOG-2026-88',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RiskBadge(
                          riskLevel: RiskLevel.low,
                          customLabel: AppLocalizations.tr('Verified Fleet'),
                          isCompact: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: AppLocalizations.tr('Fleet Operator Details'),
                    subtitle: AppLocalizations.tr('Vehicle credentials & route cost management'),
                  ),
                  const SizedBox(height: 4),
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ProfileRow(
                          label: AppLocalizations.tr('Fleet Manager'),
                          value: 'Santosh Shinde',
                          icon: Icons.badge_outlined,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Active Vehicles'),
                          value: AppLocalizations.tr('3 Vehicles (Eicher, Bolero, Tata Ace)'),
                          icon: Icons.directions_bus_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Contact Number'),
                          value: '+91 98220 55443',
                          icon: Icons.phone_android_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Freight Costing Rate'),
                          value: AppLocalizations.tr('₹85 / km (Distance-based costing)'),
                          icon: Icons.currency_rupee_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Total Completed Trips'),
                          value: AppLocalizations.tr('528 Trips (100% On-time Pune cluster)'),
                          icon: Icons.check_circle_rounded,
                        ),
                      ],
                    ),
                  ),
                ],

                // ================= ADMIN PROFILE =================
                if (role == 'Admin') ...[
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    borderColor: AppColors.primary,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.tr('AgriTwin System Admin'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppLocalizations.tr('Regional Administrator • Pune Cluster'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'ID: ADM-PUNE-001',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RiskBadge(
                          riskLevel: RiskLevel.low,
                          customLabel: AppLocalizations.tr('System Admin'),
                          isCompact: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: AppLocalizations.tr('System Governance Details'),
                    subtitle: AppLocalizations.tr('Platform analytics & cluster management'),
                  ),
                  const SizedBox(height: 4),
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ProfileRow(
                          label: AppLocalizations.tr('Managed Districts'),
                          value: AppLocalizations.tr('Pune (Haveli, Hadapsar, Kothrud, Khed)'),
                          icon: Icons.map_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Active System Nodes'),
                          value: AppLocalizations.tr('1,420 Farmers • 380 Buyers • 95 Logistics'),
                          icon: Icons.hub_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Support Desk Hotline'),
                          value: '1800-200-AGRI (24x7 Toll Free)',
                          icon: Icons.headset_mic_rounded,
                        ),
                      ],
                    ),
                  ),
                ],

                // ================= FARMER PROFILE =================
                if (role == 'Farmer') ...[
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryContainer,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                farmer.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                farmer.locationString,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Twin ID: ${farmer.digitalTwinId}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RiskBadge(
                          riskLevel: RiskLevel.low,
                          customLabel: AppLocalizations.tr('KYC Verified'),
                          isCompact: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: AppLocalizations.tr('Land & Credit Profile'),
                    subtitle: AppLocalizations.tr('Verified agronomic & financial credentials'),
                  ),
                  const SizedBox(height: 4),
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ProfileRow(
                          label: AppLocalizations.tr('Total Farm Holding'),
                          value: '${farmer.landSizeAcres} ${AppLocalizations.tr('Acres')}',
                          icon: Icons.landscape_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Agri Credit Score'),
                          value: '${farmer.creditScore} (${AppLocalizations.tr('Excellent')})',
                          icon: Icons.credit_score_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Registered Phone'),
                          value: farmer.phoneNumber,
                          icon: Icons.phone_android_rounded,
                        ),
                        const Divider(height: 20),
                        _ProfileRow(
                          label: AppLocalizations.tr('Monitored Crops'),
                          value: farmer.primaryCrops.map((c) => AppLocalizations.tr(c)).join(', '),
                          icon: Icons.agriculture_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SectionHeader(
                    title: AppLocalizations.tr('Language & Settings'),
                    subtitle: AppLocalizations.tr('Select Application Language'),
                  ),
                  const SizedBox(height: 4),
                  AppCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.translate_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.tr('Language'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: MockData.activeLanguage.contains('Marathi') || MockData.activeLanguage.contains('मराठी')
                              ? 'मराठी (Marathi)'
                              : MockData.activeLanguage.contains('Hindi') || MockData.activeLanguage.contains('हिंदी')
                                  ? 'हिंदी (Hindi)'
                                  : 'English',
                          items: const [
                            DropdownMenuItem(value: 'English', child: Text('English')),
                            DropdownMenuItem(value: 'मराठी (Marathi)', child: Text('मराठी (Marathi)')),
                            DropdownMenuItem(value: 'हिंदी (Hindi)', child: Text('हिंदी (Hindi)')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              AppLocalizations.setLanguage(val);
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
              ],
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
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
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
