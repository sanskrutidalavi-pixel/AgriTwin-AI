import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../storage/storage_screen.dart';
import '../auth/login_screen.dart';

/// Role-aware Logistics Screen: Dedicated Transporter Fleet Portal vs Farmer Transport Fleet Booking
class LogisticsScreen extends StatefulWidget {
  const LogisticsScreen({super.key});

  @override
  State<LogisticsScreen> createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen> {
  String _selectedTransportId = 'TRANS-PUNE-FPO-LOGISTICS';
  bool _transportConfirmed = false;

  final List<Map<String, dynamic>> _vehiclesList = [
    {'name': 'Eicher Pro 2.5T (Refrigerated)', 'regNo': 'MH-12-PQ-4821', 'capacity': '25 Quintals (2,500 kg)', 'status': 'Available in Haveli', 'isAvailable': true},
    {'name': 'Mahindra Bolero Pickup 1.2T', 'regNo': 'MH-12-KN-9022', 'capacity': '12 Quintals (1,200 kg)', 'status': 'On Route to Hadapsar', 'isAvailable': false},
    {'name': 'Tata Ace Super 750kg', 'regNo': 'MH-12-TR-3310', 'capacity': '7.5 Quintals (750 kg)', 'status': 'Available in Kothrud', 'isAvailable': true},
  ];

  @override
  Widget build(BuildContext context) {
    final isTransporterRole = MockData.activeUserRole == 'Transportation Agency';
    final options = MockData.transportOptions;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr(isTransporterRole ? 'Transportation Agency Fleet Portal' : 'Select Transport Fleet')),
        elevation: 0,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========================= DEDICATED TRANSPORTER AGENCY VIEW =========================
              if (isTransporterRole) ...[
                // Transporter Agency Header Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.amber.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.amber.shade900, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.tr('Pune Express Agri-Logistics Co-Op'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                  Text(AppLocalizations.tr('Registered Fleet Operator • Haveli & Gultekdi Hubs'), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Active Vehicles List
                Text(AppLocalizations.tr('Active Agency Vehicles & Fleet Status'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),

                ..._vehiclesList.map((v) {
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          Icon(Icons.local_shipping_rounded, color: v['isAvailable'] ? AppColors.primary : Colors.grey, size: 26),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.tr(v['name']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                                Text('${v['regNo']} • ${AppLocalizations.tr(v['capacity'])}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: v['isAvailable'] ? AppColors.positiveLight : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.tr(v['status']),
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: v['isAvailable'] ? AppColors.positive : Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Incoming Farmer Transport Booking Requests
                Text(AppLocalizations.tr('Incoming Farmer Booking Requests'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
                          children: [
                            const Icon(Icons.person, color: AppColors.primary),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Ramesh Patil (Haveli Pune)',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(8)),
                              child: Text(AppLocalizations.tr('1,000 kg Tomato'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(AppLocalizations.tr('Route: Haveli Farm ➔ Deccan Gymkhana (Shree Gurukrupa Restaurant) & Hadapsar Cold Storage'), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(AppLocalizations.tr('Estimated Distance: 14 km'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text('${AppLocalizations.tr('Freight Fee:')} ₹1,200', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.positive)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.tr('Booking Request Accepted! Driver assigned to Ramesh Patil.'))),
                              );
                            },
                            icon: const Icon(Icons.check_circle, color: Colors.white, size: 18),
                            label: Text(AppLocalizations.tr('Accept Booking & Assign Vehicle'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // ========================= FARMER VIEW FOR LOGISTICS FLEETS =========================
              if (!isTransporterRole) ...[
                Text(AppLocalizations.tr('Available Dispatch Fleets in Pune'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(AppLocalizations.tr('AI compares freight rates, pickup speed, and collective route savings:'), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),

                const SizedBox(height: 14),

                ...options.map((option) {
                  final isSelected = _selectedTransportId == option.id;
                  final isRec = option.isAiRecommended;

                  return InkWell(
                    onTap: () {
                      setState(() => _selectedTransportId = option.id);
                    },
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
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSelected ? AppColors.primary : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.tr(option.title),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (isRec)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                    child: Text(AppLocalizations.tr('RECOMMENDED'), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppLocalizations.tr('Estimated Cost:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                      Text('₹${option.cost.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(AppLocalizations.tr('Duration / Time:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                      Text(AppLocalizations.tr(option.durationText), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(AppLocalizations.tr('Status:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                      Text(
                                        AppLocalizations.tr(option.statusText),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.positive),
                                        textAlign: TextAlign.end,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (option.comparisonNote != null && option.comparisonNote!.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: AppColors.positiveLight, borderRadius: BorderRadius.circular(8)),
                                child: Text(AppLocalizations.tr(option.comparisonNote!), style: const TextStyle(color: AppColors.positive, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
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
                      setState(() => _transportConfirmed = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.tr('Transport Fleet Booked! Proceed to Storage'))),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StorageScreen()),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                    label: Text(
                      AppLocalizations.tr(_transportConfirmed ? 'Transport Fleet Booked! Proceed to Storage' : 'Book Selected Transport Fleet'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
