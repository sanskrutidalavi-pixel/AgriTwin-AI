import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';
import '../main_navigation_screen.dart';

/// Multi-role Registration screen with Password & Role Dropdown
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: 'Ramesh Patil');
  final TextEditingController _phoneController = TextEditingController(text: '9822012345');
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  final TextEditingController _businessNameController = TextEditingController();

  String _selectedRole = 'Farmer'; // 'Farmer', 'Buyer', 'Transportation Agency', 'Admin'
  String _selectedLocation = 'Pune (Haveli)';
  String _selectedBuyerType = 'Restaurant';

  final List<String> _roles = ['Farmer', 'Buyer', 'Transportation Agency', 'Admin'];
  final List<String> _locations = [
    'Pune (Haveli)',
    'Pune (Deccan/FC Road)',
    'Pune (Kothrud)',
    'Pune (Hadapsar)',
    'Pune (Bhosari/Pimpri)',
    'Pune (Shirur)',
    'Pune (Khed)',
    'Solapur',
    'Dharashiv',
  ];
  final List<String> _buyerTypes = ['Restaurant', 'Hotel', 'Fresh Food Processor', 'Caterer'];

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      MockData.activeUserRole = _selectedRole;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.tr("Account Registered as")} ${AppLocalizations.tr(_selectedRole)}!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Account Registration')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Card(
                  elevation: 0,
                  color: AppColors.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.tr('Register New Account'),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppLocalizations.tr('Farmer-Friendly Direct Market Platform'),
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Full Name
                Text(AppLocalizations.tr('Full Name'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: AppLocalizations.tr('Enter your full name (e.g. Ramesh Patil)'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null || value.isEmpty ? AppLocalizations.tr('Please enter name') : null,
                ),

                const SizedBox(height: 14),

                // Mobile Number
                Text(AppLocalizations.tr('Mobile Number'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_android_outlined),
                    hintText: AppLocalizations.tr('Enter 10-digit mobile number'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null || value.length < 10 ? AppLocalizations.tr('Enter valid phone number') : null,
                ),

                const SizedBox(height: 14),

                // Password
                Text(AppLocalizations.tr('Password'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: AppLocalizations.tr('Create a secure password'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null || value.length < 4 ? AppLocalizations.tr('Password must be at least 4 chars') : null,
                ),

                const SizedBox(height: 14),

                // Role Dropdown
                Text(AppLocalizations.tr('Select Role:'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(AppLocalizations.tr(role)))).toList(),
                  onChanged: (val) => setState(() => _selectedRole = val!),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 14),

                // Location Dropdown
                Text(AppLocalizations.tr('Location / District (Pune Region)'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  items: _locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                  onChanged: (val) => setState(() => _selectedLocation = val!),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 14),

                // Dynamic Role Sub-Forms
                if (_selectedRole == 'Buyer') ...[
                  const SizedBox(height: 16),
                  Text(AppLocalizations.tr('Restaurant / Business Name'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _businessNameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Shree Gurukrupa Restaurant',
                      prefixIcon: const Icon(Icons.storefront),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(AppLocalizations.tr('Buyer Type'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedBuyerType,
                    items: _buyerTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) => setState(() => _selectedBuyerType = val!),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],

                if (_selectedRole == 'Transportation Agency') ...[
                  const SizedBox(height: 16),
                  Text(AppLocalizations.tr('Transport Agency Name'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _businessNameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Pune Express Agri-Transporters',
                      prefixIcon: const Icon(Icons.local_shipping_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      AppLocalizations.tr('Create Account'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
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
