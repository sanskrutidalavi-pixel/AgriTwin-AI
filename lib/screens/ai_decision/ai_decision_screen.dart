import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../market_analysis/market_analysis_screen.dart';
import '../scenario_simulation/scenario_simulation_screen.dart';
import '../buyers/buyers_screen.dart';

/// Comprehensive AI Decision Screen for AgriTwin AI Pune Prototype
class AiDecisionScreen extends StatefulWidget {
  const AiDecisionScreen({super.key});

  @override
  State<AiDecisionScreen> createState() => _AiDecisionScreenState();
}

class _AiDecisionScreenState extends State<AiDecisionScreen> {
  String _selectedCrop = 'Tomato (Abhinav)';
  bool _isAnalyzing = false;
  int _analysisStep = 6; // Fully analyzed

  final List<String> _crops = ['Tomato (Abhinav)', 'Onion (Bhima Super)', 'Capsicum'];

  final List<Map<String, dynamic>> _factors = [
    {'name': 'Market Prices', 'status': 'Analyzed (₹33/kg at Gultekdi)', 'icon': Icons.trending_up, 'color': AppColors.primary},
    {'name': 'Future Demand', 'status': 'High (+22% Pune Cluster)', 'icon': Icons.show_chart, 'color': AppColors.positive},
    {'name': 'Weather Risk', 'status': 'Moderate Humidity (Pune)', 'icon': Icons.wb_sunny_outlined, 'color': AppColors.warning},
    {'name': 'Transport Cost', 'status': '₹1.5/kg (FPO Shared Fleet)', 'icon': Icons.local_shipping_outlined, 'color': AppColors.primary},
    {'name': 'Storage Rent', 'status': '₹2.5/kg/day (Hadapsar Cold Storage)', 'icon': Icons.store_outlined, 'color': AppColors.tertiary},
    {'name': 'Spoilage Risk', 'status': 'Medium (3 Days Ambient Life)', 'icon': Icons.warning_amber_rounded, 'color': AppColors.urgent},
  ];

  void _triggerReAnalysis() {
    setState(() {
      _isAnalyzing = true;
      _analysisStep = 0;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      if (_analysisStep < 6) {
        setState(() {
          _analysisStep++;
        });
        return true;
      } else {
        setState(() {
          _isAnalyzing = false;
        });
        return false;
      }
    });
  }

  void _showPriceDemandModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                  const Icon(Icons.show_chart_rounded, color: AppColors.primary, size: 28),
                  const SizedBox(width: 10),
                  Text(AppLocalizations.tr('Price Forecast + Demand Status'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Price Forecast Table
              Text(AppLocalizations.tr('Pune Tomato Price Forecast (per kg):'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    _priceRow(AppLocalizations.tr('Today Rate'), '₹29.0 / kg', AppLocalizations.tr('Stable')),
                    const Divider(),
                    _priceRow(AppLocalizations.tr('After 3 Days'), '₹32.0 / kg', AppLocalizations.tr('⚡ Increasing (+10%)')),
                    const Divider(),
                    _priceRow(AppLocalizations.tr('After 7 Days'), '₹34.5 / kg', AppLocalizations.tr('⚡ Peak Demand (+18%)')),
                    const Divider(),
                    _priceRow(AppLocalizations.tr('After 15 Days'), '₹36.0 / kg', AppLocalizations.tr('High Variance')),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Demand status box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.positiveLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.positive.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.positive),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalizations.tr('Demand Status: High Demand in Pune Restaurants & Hotels (+22% weekend demand spike expected)'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.positive),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _priceRow(String period, String price, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(period, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(status, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr('AI Decision Engine')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Crop Dropdown
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.tr('Select Crop for AI Analysis:'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedCrop,
                            items: _crops.map((c) => DropdownMenuItem(value: c, child: Text(AppLocalizations.tr(c)))).toList(),
                            onChanged: (val) {
                              setState(() => _selectedCrop = val!);
                              _triggerReAnalysis();
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.eco_rounded, color: AppColors.primary),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: AppColors.primaryContainer.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 6-Factor AI Analysis Status Box
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.memory_rounded, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.tr('AI Real-Time Factor Telemetry'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                              if (_isAnalyzing)
                                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(AppLocalizations.tr('Analyzing parameters for optimal net profit:'), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 12),

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.8,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _factors.length,
                            itemBuilder: (context, index) {
                              final f = _factors[index];
                              final isDone = index < _analysisStep;
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDone ? AppColors.surfaceVariant : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: isDone ? f['color'].withOpacity(0.5) : Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Icon(f['icon'], color: f['color'], size: 20),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(AppLocalizations.tr(f['name']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                          Text(isDone ? AppLocalizations.tr(f['status']) : AppLocalizations.tr('Evaluating...'), style: TextStyle(fontSize: 9, color: isDone ? AppColors.textPrimary : Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TWO PRIMARY ACTION BUTTONS: Price+Demand & Compare Market
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => _showPriceDemandModal(context),
                            icon: const Icon(Icons.show_chart, color: Colors.white, size: 20),
                            label: Text(AppLocalizations.tr('Price + Demand'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MarketAnalysisScreen()),
                              );
                            },
                            icon: const Icon(Icons.compare_arrows, color: AppColors.primary, size: 20),
                            label: Text(AppLocalizations.tr('Compare Markets'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // RUN SCENARIO SIMULATION BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScenarioSimulationScreen()),
                        );
                      },
                      icon: const Icon(Icons.psychology_alt_rounded, color: Colors.white),
                      label: Text(AppLocalizations.tr('Run Scenario Simulation'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tertiary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // AI Strategy Summary Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: AppColors.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  AppLocalizations.tr('AI Recommendation Summary for Pune:'),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.tr(
                              '• Sell 60% (600 kg) immediately to Shree Gurukrupa Restaurant Deccan Pune @ ₹30/kg.\n'
                              '• Hold 40% (400 kg) for 3 days at Sahyadri Cold Storage Hadapsar Pune @ ₹2.5/kg/day.\n'
                              '• Expected Total Profit: ₹53,500 (Risk: Medium, Confidence: 92%).',
                            ),
                            style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const BuyersScreen()),
                                );
                              },
                              icon: const Icon(Icons.storefront_rounded),
                              label: Text(AppLocalizations.tr('Connect with Buyer (Shree Gurukrupa)')),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
