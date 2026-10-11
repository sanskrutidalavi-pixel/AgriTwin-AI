import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../logistics/logistics_screen.dart';
import '../auth/login_screen.dart';

/// Screen for Buyers & Farmers with Real Camera Capture,
/// Mandatory Per-Buyer Quality Photo Verification, AI Pricing Suggestions, FPO Pooling, and Escrow Payment.
class BuyersScreen extends StatefulWidget {
  const BuyersScreen({super.key});

  @override
  State<BuyersScreen> createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  final TextEditingController _postOfferPriceController = TextEditingController(text: '30.0');
  final TextEditingController _postQtyController = TextEditingController(text: '600');

  bool _isCameraActive = true;
  final Set<String> _verifiedBuyerIds = {};
  final Map<String, String> _capturedPhotosPerBuyer = {};

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickRealImage(ImageSource source, String buyerId, Function(void Function()) setModalState) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
      if (pickedFile != null) {
        setState(() {
          _verifiedBuyerIds.add(buyerId);
          _capturedPhotosPerBuyer[buyerId] = pickedFile.path;
        });
        setModalState(() {
          _isCameraActive = false;
        });
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _showQualityPhotoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(12),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text('📷 Verified Crop Photo', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              Icon(Icons.verified_rounded, color: AppColors.positive, size: 20),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('🍅', style: TextStyle(fontSize: 48)),
                            SizedBox(height: 4),
                            Text('Tomato Abhinav Hybrid', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('Grade A Fresh Harvest Verified', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '📅 Timestamp: 08-Sep-2026 05:45 PM\n📍 Haveli Farm Plot #4, Pune\n⚡ AI Freshness: 98% (Grade A Verified)',
                            style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, height: 1.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCameraModal(BuildContext context, String buyerId) {
    setState(() {
      _isCameraActive = true;
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stfContext, setModalState) {
            final hasPhoto = _capturedPhotosPerBuyer.containsKey(buyerId);
            final photoPath = _capturedPhotosPerBuyer[buyerId];

            return AlertDialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('📷 Quality Crop Photo', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.flash_on_rounded, color: Colors.amber, size: 20),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // REAL OR SIMULATED CAMERA VIEWPORT FRAME
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: Stack(
                        children: [
                          if (hasPhoto && photoPath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                File(photoPath),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          else if (_isCameraActive)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.center_focus_strong_rounded, color: Colors.amber, size: 64),
                                  SizedBox(height: 8),
                                  Text('Align Tomato Crop in Frame', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  Text('Click buttons below to capture real photo', style: TextStyle(color: Colors.white38, fontSize: 10)),
                                ],
                              ),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade900,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text('🍅', style: TextStyle(fontSize: 48)),
                                        SizedBox(height: 4),
                                        Text('Tomato Abhinav Hybrid', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                        Text('Grade A Fresh Harvest Verified', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Positioned(
                            bottom: 6,
                            left: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '📅 Timestamp: 08-Sep-2026 05:45 PM\n📍 Haveli Farm Plot #4, Pune\n⚡ AI Freshness: 98% (Grade A Verified)',
                                style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, height: 1.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // REAL CAMERA CAPTURE BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickRealImage(ImageSource.camera, buyerId, setModalState),
                            icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                            label: const Text('Device Camera', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickRealImage(ImageSource.gallery, buyerId, setModalState),
                            icon: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 16),
                            label: const Text('Gallery Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // SIMULATED / SHUTTER CONFIRMATION BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _verifiedBuyerIds.add(buyerId);
                          });
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Quality Photo Verified! "Send Offer" button unlocked for this buyer.'),
                              backgroundColor: AppColors.positive,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                        label: const Text('Confirm Photo Verification & Unlock Offer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  void _showPaymentModal(BuildContext context, String farmerName, double amount) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.payment_rounded, color: AppColors.primary, size: 28),
                  SizedBox(width: 10),
                  Text('Direct Farmer Payment Escrow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Text('Beneficiary Farmer: $farmerName', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('Amount: ₹${amount.toStringAsFixed(0)} (600 kg Tomato @ ₹30/kg)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.positive)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    Icon(Icons.security_rounded, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('AgriTwin Escrow guarantees instant payment release upon quality photo verification and delivery.', style: TextStyle(fontSize: 12, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      MockData.isPaymentCompleted = true;
                      MockData.buyerPaymentStatus = 'PAYMENT COMPLETED & RECEIVED IN FARMER BANK ACCOUNT (₹18,000 via UPI)';
                    });
                    Navigator.pop(modalContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment of ₹${amount.toStringAsFixed(0)} released to $farmerName! Farmer account credited.')),
                    );
                  },
                  icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
                  label: const Text('Pay Now via UPI / Net Banking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
    final isBuyerRole = MockData.activeUserRole == 'Buyer';
    final buyers = MockData.buyerList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr(isBuyerRole ? 'Buyer' : 'Buyers')),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========================= DEDICATED BUYER INTERFACE =========================
              if (isBuyerRole) ...[
                // Buyer Business Card
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Shree Gurukrupa Restaurant', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text('Deccan Gymkhana, FC Road, Pune • Verified Commercial Buyer', style: TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Post / Update Crop Demand Form
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Required Crops & Demand Specs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 2),
                        const Text('Set crop quantity and price offered to Pune farmers', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        const SizedBox(height: 12),

                        // Required Crop Dropdown
                        Text(AppLocalizations.tr('Required Crop / Vegetable:'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Text('🍅', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(AppLocalizations.tr('Tomato (Abhinav Hybrid)'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _postOfferPriceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.tr('Offered Price (₹/kg)'),
                                  prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _postQtyController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.tr('Demand Qty (kg)'),
                                  prefixIcon: const Icon(Icons.scale, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Demand Requirement Updated for Pune Farmers!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            child: Text(AppLocalizations.tr('Update Demand & Broadcast to Farmers'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Incoming Farmer Offer & Acceptance Card (Fixed 10px Overflow!)
                Text(AppLocalizations.tr('Received Offers from Local Farmers'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(radius: 18, backgroundColor: AppColors.primary, child: const Icon(Icons.person, color: Colors.white, size: 20)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Ramesh Patil (${AppLocalizations.tr("Farmer")})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const Text('Haveli, Pune', style: TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.positiveLight, borderRadius: BorderRadius.circular(8)),
                              child: const Text('8 km Away', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.positive, fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.tr('Crop Offered:'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            Expanded(
                              child: Text('${AppLocalizations.tr("Tomato")} (600 kg ${AppLocalizations.tr("Grade A")})', textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.tr('Offered Price:'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            const Text('₹30.0 / kg (Total ₹18,000)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.tr('Quality Proof:'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            Text('${AppLocalizations.tr("Grade A")} ${AppLocalizations.tr("Verified")} 📸', style: const TextStyle(color: AppColors.positive, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.tr('Payment Status:'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            Expanded(
                              child: Text(
                                MockData.isPaymentCompleted ? AppLocalizations.tr('PAYMENT COMPLETED') : MockData.buyerPaymentStatus,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: MockData.isPaymentCompleted ? AppColors.positive : AppColors.warning,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Action Buttons: Accept Offer & Payment AND View Quality Photo
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showPaymentModal(context, 'Ramesh Patil', 18000.0);
                                },
                                icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                                label: Text(AppLocalizations.tr('Accept & Pay'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showQualityPhotoModal(context);
                                },
                                icon: const Icon(Icons.photo_camera_rounded, color: AppColors.primary, size: 16),
                                label: Text(AppLocalizations.tr('View Quality Photo 📸'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // ========================= FARMER VIEW FOR BUYERS =========================
              if (!isBuyerRole) ...[
                // PAYMENT COMPLETED BANNER (Visible to farmer when buyer completes payment!)
                if (MockData.isPaymentCompleted) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.positiveLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.positive, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_rounded, color: AppColors.positive, size: 26),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '✅ ${AppLocalizations.tr("PAYMENT COMPLETED")}\n₹18,000 received in Ramesh Patil Bank Account via Escrow UPI.',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.positive, fontSize: 12, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // AI Best Match Suggestion Banner
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: AppColors.positiveLight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.positive, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.tr('AI Best Match Suggestion for Harvest Lot'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.positive)),
                              Text(AppLocalizations.tr('Sell to Shree Gurukrupa Restaurant Deccan Pune @ ₹30/kg'), style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Camera Quality Photo Status Bar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _verifiedBuyerIds.isNotEmpty ? AppColors.positiveLight : AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _verifiedBuyerIds.isNotEmpty ? AppColors.positive : AppColors.warning),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _verifiedBuyerIds.isNotEmpty ? Icons.verified : Icons.camera_enhance_rounded,
                        color: _verifiedBuyerIds.isNotEmpty ? AppColors.positive : AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _verifiedBuyerIds.isNotEmpty
                              ? AppLocalizations.tr('Mandatory Quality Photo Verified for selected buyers! Send Offer button unlocked.')
                              : AppLocalizations.tr('Mandatory Requirement: Click Camera Quality Photo for a buyer to capture photo & unlock offer for that buyer.'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _verifiedBuyerIds.isNotEmpty ? AppColors.positive : AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // BUYERS LIST FOR FARMERS
                Text(AppLocalizations.tr('Verified Commercial Buyers in Pune'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),

                ...buyers.map((buyer) {
                  final isRec = buyer.isAiRecommended;
                  final isVerifiedForBuyer = _verifiedBuyerIds.contains(buyer.id);

                  return Card(
                    elevation: isRec ? 2 : 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isRec ? AppColors.primary : Colors.grey.shade300, width: isRec ? 2 : 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(buyer.companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text('${buyer.location} • ${AppLocalizations.tr(buyer.buyerType.displayName)}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              if (isRec)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                                  child: Text(AppLocalizations.tr('BEST MATCH'), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.tr('Offered Price:'), style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                  Text('₹${buyer.pricePerKg.toInt()} / kg', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.positive)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.tr('Requirement'), style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                  Text('${buyer.requiredKg.toInt()} kg', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(AppLocalizations.tr('Distance:'), style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                  Text('${buyer.distanceKm.toInt()} km', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // CAMERA QUALITY PHOTO & MANDATORY SEND OFFER BUTTON
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showCameraModal(context, buyer.id),
                                      icon: Icon(
                                        isVerifiedForBuyer ? Icons.check_circle : Icons.camera_alt_outlined,
                                        color: isVerifiedForBuyer ? AppColors.positive : AppColors.primary,
                                        size: 16,
                                      ),
                                      label: Text(
                                        isVerifiedForBuyer ? AppLocalizations.tr('Photo Verified') : AppLocalizations.tr('Quality Photo (Camera)'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isVerifiedForBuyer ? AppColors.positive : AppColors.primary,
                                          fontSize: 11,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: isVerifiedForBuyer ? AppColors.positive : AppColors.primary),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),

                                  // SEND OFFER BUTTON IS ONLY DISPLAYED WHEN PHOTO IS VERIFIED FOR THIS BUYER!
                                  if (isVerifiedForBuyer)
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Offer Sent to ${buyer.companyName}! Verified photo attached.'),
                                              backgroundColor: AppColors.primary,
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                                        label: Text(AppLocalizations.tr('Send Offer'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                      ),
                                    ),
                                ],
                              ),
                              if (isVerifiedForBuyer) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade900,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.positive, width: 1.5),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: _capturedPhotosPerBuyer[buyer.id] != null
                                            ? Image.file(
                                                File(_capturedPhotosPerBuyer[buyer.id]!),
                                                width: 54,
                                                height: 54,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 54,
                                                height: 54,
                                                color: Colors.red.shade900,
                                                child: const Center(child: Text('🍅', style: TextStyle(fontSize: 26))),
                                              ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(AppLocalizations.tr('Grade A Verified Crop Photo'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                            const SizedBox(height: 2),
                                            const Text('📅 Timestamp: 08-Sep-2026 05:45 PM', style: TextStyle(color: Colors.amber, fontSize: 10)),
                                            const Text('📍 Location: Haveli Farm Plot #4, Pune', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                            Text('⚡ AI Freshness: 98% (${AppLocalizations.tr("Grade A Verified")})', style: const TextStyle(color: AppColors.positive, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              // TRANSPORT BOOKING BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 42,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LogisticsScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.local_shipping_rounded, color: AppColors.tertiary, size: 16),
                                  label: Text(AppLocalizations.tr('Book / Select Transportation Fleet'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.tertiary, fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.tertiary, width: 1.2),
                                    backgroundColor: Colors.amber.shade50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
