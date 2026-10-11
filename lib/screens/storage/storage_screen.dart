import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../alerts/smart_alert_screen.dart';

/// Storage Recommendation Screen for Pune Cold Chain with conditional availability check & alerts
class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  bool _isFarmStorageAvailable = false; // YES / NO toggle
  final TextEditingController _selfStorageCostController = TextEditingController(text: '5.0');

  String _selectedStorageId = 'STR-SAHYADRI-PUNE';
  bool _storageConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final options = MockData.storageOptions;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Storage AI & Pune Cold Chain')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CONDITIONAL STORAGE AVAILABILITY CHECK AT HARVEST TIME
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.store_rounded, color: AppColors.primary, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(AppLocalizations.tr('Is Storage Available on Farm?'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                          Switch(
                            value: _isFarmStorageAvailable,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                _isFarmStorageAvailable = val;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isFarmStorageAvailable
                            ? AppLocalizations.tr('YES: Storage is available on your farm in Haveli. Enter your daily maintenance cost below.')
                            : AppLocalizations.tr('NO: Storage is NOT available on farm. AI will suggest the best nearby cold storage facilities in Pune.'),
                        style: TextStyle(
                          fontSize: 12,
                          color: _isFarmStorageAvailable ? AppColors.positive : AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_isFarmStorageAvailable) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _selfStorageCostController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.tr('Your Daily Storage Cost (₹ / kg / day)'),
                            prefixIcon: const Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // AI SUGGESTED COLD STORAGE UNITS (If no farm storage or comparing alternatives)
              Text(AppLocalizations.tr('AI Suggested Pune Cold Storage Facilities'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(AppLocalizations.tr('AI compares rent rates, distance from farm, and government subsidies:'), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 14),

              ...options.map((option) {
                final isSelected = _selectedStorageId == option.id;
                final isRec = option.isAiRecommended;

                return InkWell(
                  onTap: () => setState(() => _selectedStorageId = option.id),
                  child: Card(
                    elevation: isSelected ? 3 : 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: isSelected ? 2 : 1),
                    ),
                    color: isSelected ? AppColors.primaryContainer.withOpacity(0.4) : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.primary : Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(AppLocalizations.tr(option.name), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                              ),
                              if (isRec)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                  child: Text(AppLocalizations.tr('BEST VALUE'), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.tr('Daily Rent:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  Text('₹${option.ratePerKgPerDay} / kg / day', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.tr('Distance:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  Text('${option.distanceKm.toInt()} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(AppLocalizations.tr('Available:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  Text(AppLocalizations.tr(option.capacityText), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.positive)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _storageConfirmed = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.tr('Storage Reserved! View Smart Telemetry'))),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SmartAlertScreen()),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                  label: Text(
                    AppLocalizations.tr(_storageConfirmed ? 'Storage Reserved! View Smart Telemetry' : 'Reserve Cold Storage Unit'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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
      ),
    );
  }
}
