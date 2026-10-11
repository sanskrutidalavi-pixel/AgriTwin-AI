import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';

/// Screen for adding a new harvest batch with strict field ordering:
/// 1. Crop Details (Crop Name, Harvest Quantity, Unit)
/// 2. Quality Information (Quality Grade, Upload Quality Grade Proof via device file picker)
/// 3. Harvest Information (Harvest Date, Place of Harvest)
/// 4. Storage Section (Storage Available on Farm? Yes/No, Storage Capacity, Available Storage)
/// 5. Responsive Form Action Buttons (Register Harvest & Cancel)
class AddProduceScreen extends StatefulWidget {
  const AddProduceScreen({super.key});

  @override
  State<AddProduceScreen> createState() => _AddProduceScreenState();
}

class _AddProduceScreenState extends State<AddProduceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _cropNameController;
  late TextEditingController _quantityController;
  late TextEditingController _harvestPlaceController;
  late TextEditingController _storageCapacityController;
  late TextEditingController _availableCapacityController;

  final ImagePicker _picker = ImagePicker();

  String _selectedUnit = 'kg';
  String _selectedGrade = 'Grade A';
  DateTime _harvestDate = DateTime(2026, 9, 10);
  bool _isStorageAvailable = false;

  String? _uploadedFileName;
  String? _uploadedFilePath;
  String? _uploadedFileType;

  final List<String> _unitOptions = ['kg', 'quintal', 'tonne'];

  final List<String> _gradeOptions = [
    'Grade A',
    'Grade B',
    'Grade C',
    'Premium',
    'Standard',
    'Basic',
  ];

  final List<String> _quickCropSuggestions = [
    'Tomato',
    'Onion',
    'Potato',
    'Soybean',
    'Wheat',
  ];

  @override
  void initState() {
    super.initState();
    _cropNameController = TextEditingController(text: 'Onion');
    _quantityController = TextEditingController(text: '300');
    _harvestPlaceController = TextEditingController(text: 'Pune, Maharashtra');
    _storageCapacityController = TextEditingController(text: '1500');
    _availableCapacityController = TextEditingController(text: '1000');
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _quantityController.dispose();
    _harvestPlaceController.dispose();
    _storageCapacityController.dispose();
    _availableCapacityController.dispose();
    super.dispose();
  }

  Future<void> _selectHarvestDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _harvestDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _harvestDate) {
      setState(() {
        _harvestDate = picked;
      });
    }
  }

  Future<void> _pickDeviceFile() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (pickedFile != null) {
        final name = pickedFile.name.isNotEmpty ? pickedFile.name : 'quality_certificate_${_cropNameController.text.trim()}.jpg';
        setState(() {
          _uploadedFileName = name;
          _uploadedFilePath = pickedFile.path;
          _uploadedFileType = 'jpg';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: $name'),
            backgroundColor: AppColors.positive,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
    } catch (e) {
      debugPrint('Device file picker error: $e');
    }

    final cropClean = _cropNameController.text.trim().replaceAll(' ', '_');
    setState(() {
      _uploadedFileName = 'quality_certificate_${cropClean.isNotEmpty ? cropClean : "harvest"}.pdf';
      _uploadedFileType = 'pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: $_uploadedFileName'),
        backgroundColor: AppColors.positive,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _saveProduce() {
    if (_formKey.currentState!.validate()) {
      final cropName = _cropNameController.text.trim();
      final quantity = _quantityController.text.trim();
      final unit = _selectedUnit;
      final place = _harvestPlaceController.text.trim();
      final formattedDate = '${_harvestDate.day.toString().padLeft(2, '0')}-${_getMonthAbbr(_harvestDate.month)}-${_harvestDate.year}';

      final storageStatusStr = _isStorageAvailable
          ? 'Self Farm Storage (Cap: ${_storageCapacityController.text} $unit, Avail: ${_availableCapacityController.text} $unit)'
          : 'Sahyadri Cold Storage Hadapsar (₹2.5/kg/day)';

      final newBatch = {
        'cropName': cropName,
        'quantity': '$quantity $unit',
        'grade': _selectedGrade,
        'harvestDate': formattedDate,
        'location': place.isNotEmpty ? place : 'Pune, Maharashtra',
        'storageStatus': storageStatusStr,
        'status': 'Active Monitored Lot #AT-${cropName.length >= 3 ? cropName.substring(0, 3).toUpperCase() : "LOT"}-2026',
        'govtCert': _uploadedFileName != null ? 'Certificate Attached (${_uploadedFileName!})' : 'Quality Grade Verified',
        'photoAttached': _uploadedFileName != null ? 'Proof Attached' : 'Crop Photo Verified',
        'proofFile': _uploadedFileName ?? 'quality_certificate.pdf',
      };

      // Add newly registered crop to persistent list
      MockData.registeredHarvestBatches.add(newBatch);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harvest registered successfully!'),
          backgroundColor: AppColors.positive,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields before registering.'),
          backgroundColor: AppColors.warning,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDateStr = '${_harvestDate.day.toString().padLeft(2, '0')}-${_getMonthAbbr(_harvestDate.month)}-${_harvestDate.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Add New Harvest')),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Header Card
                Card(
                  color: AppColors.primaryContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        const Text('🌾', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.tr('Register New Harvest'),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppLocalizations.tr('Digital Twin & AI Decision Support System for Pune Farmers'),
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================== 1. CROP DETAILS ====================
                Text(AppLocalizations.tr('Crop Details'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 10),

                // Crop Name
                Text(AppLocalizations.tr('Crop Name *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _cropNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.eco_outlined, color: AppColors.primary, size: 20),
                    hintText: 'e.g. Tomato, Onion, Potato',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? AppLocalizations.tr('Please enter crop name') : null,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _quickCropSuggestions.map((crop) {
                    return ChoiceChip(
                      label: Text(AppLocalizations.tr(crop), style: const TextStyle(fontSize: 11)),
                      selected: _cropNameController.text == crop,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _cropNameController.text = crop;
                          });
                        }
                      },
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        color: _cropNameController.text == crop ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: _cropNameController.text == crop ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),

                // Harvest Quantity & Unit (Responsive Responsive Flex Layout to fix 5.2px overflow)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 320;
                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.tr('Harvest Quantity *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.scale_outlined, color: AppColors.primary, size: 20),
                              hintText: 'e.g. 300',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? AppLocalizations.tr('Enter quantity') : null,
                          ),
                          const SizedBox(height: 10),
                          Text(AppLocalizations.tr('Unit *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedUnit,
                            items: _unitOptions.map((u) => DropdownMenuItem(value: u, child: Text(AppLocalizations.tr(u)))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedUnit = val);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.tr('Harvest Quantity *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.scale_outlined, color: AppColors.primary, size: 20),
                                  hintText: 'e.g. 300',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                validator: (val) => val == null || val.trim().isEmpty ? AppLocalizations.tr('Enter quantity') : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.tr('Unit *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _selectedUnit,
                                items: _unitOptions.map((u) => DropdownMenuItem(value: u, child: Text(AppLocalizations.tr(u)))).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedUnit = val);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // ==================== 2. QUALITY INFORMATION ====================
                Text(AppLocalizations.tr('Quality Information'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 10),

                // Quality Grade Dropdown
                Text(AppLocalizations.tr('Quality Grade *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedGrade,
                  items: _gradeOptions.map((g) => DropdownMenuItem(value: g, child: Text(AppLocalizations.tr(g)))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGrade = val);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.workspace_premium_outlined, color: AppColors.primary, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),

                const SizedBox(height: 14),

                // Upload Quality Grade Proof (Immediately Below Quality Grade)
                Text(AppLocalizations.tr('Upload Quality Grade Proof *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.upload_file_rounded, color: AppColors.primary, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.tr('Upload Certificate / Proof (PDF, JPG, PNG)'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _pickDeviceFile,
                            icon: const Icon(Icons.folder_open_rounded, color: Colors.white, size: 18),
                            label: Text(
                              AppLocalizations.tr('Upload Certificate / Proof'),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),

                        // Selected File Name / Preview Display
                        if (_uploadedFileName != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.positiveLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.positive, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                if (_uploadedFileType == 'jpg' || _uploadedFileType == 'jpeg' || _uploadedFileType == 'png') ...[
                                  if (_uploadedFilePath != null && File(_uploadedFilePath!).existsSync())
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(File(_uploadedFilePath!), width: 36, height: 36, fit: BoxFit.cover),
                                    )
                                  else
                                    const Icon(Icons.image_rounded, color: AppColors.positive, size: 28),
                                ] else ...[
                                  const Icon(Icons.picture_as_pdf_rounded, color: AppColors.positive, size: 28),
                                ],
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected: $_uploadedFileName',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.positive),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '✅ ${AppLocalizations.tr("Document Verified & Attached")}',
                                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _uploadedFileName = null;
                                      _uploadedFilePath = null;
                                      _uploadedFileType = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // ==================== 3. HARVEST INFORMATION ====================
                Text(AppLocalizations.tr('Harvest Information'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 10),

                // Harvest Date Picker
                Text(AppLocalizations.tr('Harvest Date *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => _selectHarvestDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              formattedDateStr,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                        Text(AppLocalizations.tr('Change Date 📅'), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Place of Harvest
                Text(AppLocalizations.tr('Place of Harvest *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _harvestPlaceController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                    hintText: 'e.g. Pune, Maharashtra',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? AppLocalizations.tr('Please enter place of harvest') : null,
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // ==================== 4. STORAGE SECTION ====================
                Text(AppLocalizations.tr('Storage Section'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 10),

                // Storage Available Card (Fully Responsive, fixes 36px and 22px overflow)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Responsive Header Row for Yes/No Selection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.store_rounded, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.tr('Storage Available on Farm?'),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Yes / No Toggle Segment Buttons
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => _isStorageAvailable = true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _isStorageAvailable ? AppColors.primary : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: _isStorageAvailable ? Colors.white : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => _isStorageAvailable = false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: !_isStorageAvailable ? AppColors.warning : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: !_isStorageAvailable ? Colors.white : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          _isStorageAvailable
                              ? AppLocalizations.tr('YES: Storage is available on farm in Pune.')
                              : AppLocalizations.tr('NO: Farm storage unavailable. AI recommends cold storage.'),
                          style: TextStyle(
                            fontSize: 11,
                            color: _isStorageAvailable ? AppColors.positive : AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // IF YES -> DISPLAY STORAGE CAPACITY & AVAILABLE STORAGE
                        if (_isStorageAvailable) ...[
                          const SizedBox(height: 14),
                          const Divider(),
                          const SizedBox(height: 10),
                          Text(AppLocalizations.tr('Storage Capacity *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _storageCapacityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.inventory_2_outlined, size: 18),
                              suffixText: AppLocalizations.tr(_selectedUnit),
                              hintText: 'e.g. 1500',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            validator: (val) => _isStorageAvailable && (val == null || val.trim().isEmpty) ? 'Enter capacity' : null,
                          ),
                          const SizedBox(height: 10),
                          Text(AppLocalizations.tr('Available Storage *'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _availableCapacityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.tune_outlined, size: 18),
                              suffixText: AppLocalizations.tr(_selectedUnit),
                              hintText: 'e.g. 1000',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            validator: (val) => _isStorageAvailable && (val == null || val.trim().isEmpty) ? 'Enter available storage' : null,
                          ),
                        ],

                        // IF NO -> DISPLAY AI RECOMMENDATION (CLEANLY WRAPPED)
                        if (!_isStorageAvailable) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.tr('AI Recommended Storage Facility:'),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '• Sahyadri Cold Storage (Hadapsar, Pune)\n'
                                  '• Rate: ₹2.5 / kg / day (Subsidized)\n'
                                  '• Capacity: 15 Tonnes Available',
                                  style: TextStyle(fontSize: 11, height: 1.3, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================== 5. RESPONSIVE ACTION BUTTONS ====================
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(AppLocalizations.tr('Cancel'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _saveProduce,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(AppLocalizations.tr('Register Harvest'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
