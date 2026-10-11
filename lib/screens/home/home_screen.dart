import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/primary_button.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/voice_assistant_modal.dart';
import '../ai_decision/ai_decision_screen.dart';
import '../auth/login_screen.dart';
import '../produce/add_produce_screen.dart';

/// Farmer & Multi-Role Home Screen for AgriTwin AI Pune Prototype
class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _showAiRecommendationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.tr('AI Recommendation Summary'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          'Batch: 1,000 kg ${AppLocalizations.tr("Tomato")} • Harvested Sep 1',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(modalContext),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Split Recommendation Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.positiveLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.positive.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.positive, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.tr('Sell 60% today (600 kg)'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.positive),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 4),
                      child: Text(
                        AppLocalizations.tr('Sell to Shree Gurukrupa Restaurant Deccan Pune @ ₹30/kg'),
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.store_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.tr('Store 40% for 3 Days (400 kg)'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 4),
                      child: Text(
                        AppLocalizations.tr('Store at Sahyadri Cold Storage Hadapsar Pune @ ₹2.5/kg/day'),
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Expected Net Profit Card – visually dominant
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.show_chart, color: AppColors.positive, size: 20),
                          SizedBox(width: 6),
                          Text('AI Recommendation', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(AppLocalizations.tr('Expected Net Profit'), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      const Text('₹53,500', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.positive)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Risk Profile
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.tr('Risk Profile'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.tr('Medium (Optimized)'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.warning)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              PrimaryButton(
                label: AppLocalizations.tr('AI Decision Engine'),
                icon: Icons.analytics_rounded,
                onPressed: () {
                  Navigator.pop(modalContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiDecisionScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmer = MockData.sampleFarmer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.eco_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 6),
                const Text(
                  'AgriTwin AI',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    MockData.activeUserRole.toUpperCase(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            Text(
              'Location: ${farmer.district}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Switch Role / Back to Login',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Farmer Greeting Header & Add Produce Action
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: AppColors.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppColors.primary,
                                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${AppLocalizations.tr("Good Morning")}, ${farmer.name} 👋',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${AppLocalizations.tr("Pune Region")} • ${AppLocalizations.tr("Farmer Profile & Digital Twin")}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                             SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddProduceScreen()),
                                  );
                                  setState(() {});
                                  if (result == true && widget.onNavigateTab != null) {
                                    widget.onNavigateTab!(1); // Navigate directly to Produce tab (Index 1)
                                  }
                                },
                                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 18),
                                label: Text(
                                  '${AppLocalizations.tr('Register New Harvest')} (+)',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Current Active Harvest Lot
                    Text(AppLocalizations.tr('Current Active Harvest Lot'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      // Tomato Visual Crop Thumbnail Card
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFFF4D4D), Color(0xFFCC0000)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text('🍅', style: TextStyle(fontSize: 24)),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.tr('Tomato (Abhinav Hybrid)'),
                                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${AppLocalizations.tr("Grade A")} • Sep 1, 2026',
                                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '1000 kg',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),
                            const Divider(),
                            const SizedBox(height: 10),

                            // AI Recommendation Quick Button
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showAiRecommendationModal(context),
                                    icon: const Icon(Icons.auto_awesome, color: AppColors.primary),
                                    label: Text(AppLocalizations.tr('AI Recommendation Summary'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const AiDecisionScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                                    label: Text(AppLocalizations.tr('AI Decision Engine'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),


                    const SizedBox(height: 24),

                    // Expected Net Profit Card – visually dominant
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                                // Expected Net Profit heading and amount
                    Text(AppLocalizations.tr('Expected Net Profit'), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    const Text('₹53,500', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.positive)),
                    const SizedBox(height: 4),
                    const Text('↗ High Demand (Pune Urban Cluster)', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    const Text('Medium (Optimized)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Pune Region Card
                    MetricCard(
                      title: AppLocalizations.tr('Pune Region'),
                      value: '₹33/kg',
                      subtitle: AppLocalizations.tr('Pune Market Yard (Gultekdi APMC)'),
                      icon: Icons.trending_up,
                      trend: MetricTrend.positive,
                      trendText: '+₹4/kg',
                    ),
                    const SizedBox(height: 30),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
