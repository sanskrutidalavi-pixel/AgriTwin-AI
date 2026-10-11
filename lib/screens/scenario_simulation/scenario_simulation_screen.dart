import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../buyers/buyers_screen.dart';

/// Screen presenting the profit simulation scenarios and explicit "Why AI Recommended" explanation
class ScenarioSimulationScreen extends StatelessWidget {
  const ScenarioSimulationScreen({super.key});

  void _showWhyAiModal(BuildContext context) {
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
                  const Icon(Icons.psychology_rounded, color: AppColors.primary, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocalizations.tr('Why AI Recommended This Scenario?'),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.tr('1. Risk-Balanced Dual Strategy'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.tr('Selling 60% today locks in ₹18,000 cash flow to meet urgent farming expenses in Haveli, Pune without waiting.'),
                      style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Text(AppLocalizations.tr('2. Capturing Pune Demand Spike'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.tr('Holding 40% in Sahyadri Cold Storage Hadapsar allows you to capture the projected +18% weekend price surge at Gultekdi APMC Mandi.'),
                      style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Text(AppLocalizations.tr('3. Spoilage Protection Guarantee'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.tr('Cold storage cost is only ₹2.5/kg/day, which is easily offset by the ₹4.5/kg price increase over 7 days.'),
                      style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(modalContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppLocalizations.tr('Got it! Close Breakdown'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Scenario Simulation')),
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
                  Text(
                    AppLocalizations.tr('Multi-Scenario Comparison (1,000 kg Tomatoes)'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.tr('Simulating price, demand, weather risk, storage cost, and net profit in Pune'),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 20),

                  // SCENARIO 1: SELL TODAY
                  _scenarioCard(
                    context,
                    title: AppLocalizations.tr('SCENARIO 1: SELL TODAY'),
                    timeframe: AppLocalizations.tr('Immediate Dispatch (Haveli Farm Direct)'),
                    expectedProfit: '₹43,500',
                    price: '₹29.0 / kg',
                    range: '₹28 - ₹30 / kg',
                    demand: AppLocalizations.tr('Stable'),
                    storageCost: AppLocalizations.tr('₹0 (Zero storage used)'),
                    spoilage: AppLocalizations.tr('0% Risk'),
                    weather: AppLocalizations.tr('Sunny / Safe'),
                    transport: AppLocalizations.tr('₹1,500 (FPO Shared)'),
                    netProfit: '₹43,500 Net',
                    isRecommended: false,
                  ),

                  const SizedBox(height: 16),

                  // SCENARIO 2: WAIT 3 DAYS
                  _scenarioCard(
                    context,
                    title: AppLocalizations.tr('SCENARIO 2: WAIT 3 DAYS'),
                    timeframe: AppLocalizations.tr('Short Holding at Sahyadri Cold Storage'),
                    expectedProfit: '₹48,000',
                    price: '₹32.0 / kg',
                    range: '₹31 - ₹33 / kg',
                    demand: AppLocalizations.tr('Increasing'),
                    storageCost: AppLocalizations.tr('₹3,000 (₹2.5/kg x 3 days)'),
                    spoilage: AppLocalizations.tr('2% Weight Loss'),
                    weather: AppLocalizations.tr('Humid Alert'),
                    transport: '₹1,500',
                    netProfit: '₹48,000 Net',
                    isRecommended: false,
                  ),

                  const SizedBox(height: 16),

                  // SCENARIO 3: WAIT 7 DAYS (AI RECOMMENDED)
                  _scenarioCard(
                    context,
                    title: AppLocalizations.tr('SCENARIO 3: PARTIAL SELL TODAY + WAIT 7 DAYS'),
                    timeframe: AppLocalizations.tr('Optimal AI Peak Strategy'),
                    expectedProfit: '₹53,500',
                    price: '₹34.5 / kg (Expected Peak)',
                    range: '₹33 - ₹36 / kg',
                    demand: AppLocalizations.tr('⚡ High Weekend Demand Spike'),
                    storageCost: AppLocalizations.tr('₹3,000 (Sahyadri Cold Storage Hadapsar)'),
                    spoilage: AppLocalizations.tr('Mitigated by Cold Storage'),
                    weather: AppLocalizations.tr('Controlled Temp'),
                    transport: AppLocalizations.tr('₹1,200 (FPO Collective Fleet)'),
                    netProfit: '₹53,500 Net',
                    isRecommended: true,
                    onWhyTap: () => _showWhyAiModal(context),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.tr('AI Recommended Scenario Applied! Proceeding to Buyers.')),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BuyersScreen()),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: Flexible(
                        child: Text(
                          AppLocalizations.tr('Apply AI Recommended Scenario & Connect Buyer'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

  Widget _scenarioCard(
    BuildContext context, {
    required String title,
    required String timeframe,
    required String expectedProfit,
    required String price,
    required String range,
    required String demand,
    required String storageCost,
    required String spoilage,
    required String weather,
    required String transport,
    required String netProfit,
    required bool isRecommended,
    VoidCallback? onWhyTap,
  }) {
    return Card(
      elevation: isRecommended ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isRecommended ? AppColors.primary : Colors.grey.shade300, width: isRecommended ? 2 : 1),
      ),
      color: isRecommended ? AppColors.primaryContainer.withOpacity(0.5) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isRecommended ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                    child: Text(AppLocalizations.tr('⭐ AI RECOMMENDED'), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            Text(timeframe, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.tr('Expected Net Profit:'), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(expectedProfit, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isRecommended ? AppColors.positive : AppColors.primary)),
              ],
            ),

            const Divider(),
            const SizedBox(height: 6),

            // Inline Parameter Grid
            _paramRow(AppLocalizations.tr('Expected Price:'), price),
            _paramRow(AppLocalizations.tr('Price Range:'), range),
            _paramRow(AppLocalizations.tr('Demand Status:'), demand),
            _paramRow(AppLocalizations.tr('Storage Cost:'), storageCost),
            _paramRow(AppLocalizations.tr('Spoilage Risk:'), spoilage),
            _paramRow(AppLocalizations.tr('Weather Risk:'), weather),
            _paramRow(AppLocalizations.tr('Transport Fee:'), transport),

            if (isRecommended && onWhyTap != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onWhyTap,
                  icon: const Icon(Icons.help_outline, color: AppColors.primary, size: 18),
                  label: Flexible(
                    child: Text(
                      AppLocalizations.tr('Why AI Recommended This Scenario?'),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _paramRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
