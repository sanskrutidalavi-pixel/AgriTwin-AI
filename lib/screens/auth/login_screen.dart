import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';
import 'registration_screen.dart';
import '../main_navigation_screen.dart';

/// Multi-role Login screen for AgriTwin AI Pune Prototype
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9822012345');
  final TextEditingController _passwordController = TextEditingController(text: '123456');

  String _selectedRole = 'Farmer'; // 'Farmer', 'Buyer', 'Transportation Agency', 'Admin'
  String _selectedLanguage = MockData.activeLanguage.contains('Marathi') || MockData.activeLanguage.contains('मराठी')
      ? 'मराठी (Marathi)'
      : MockData.activeLanguage.contains('Hindi') || MockData.activeLanguage.contains('हिंदी')
          ? 'हिंदी (Hindi)'
          : 'English';

  final List<String> _roles = ['Farmer', 'Buyer', 'Transportation Agency', 'Admin'];
  final List<String> _languages = ['English', 'हिंदी (Hindi)', 'मराठी (Marathi)'];

  void _handleLogin() {
    MockData.activeUserRole = _selectedRole;
    AppLocalizations.setLanguage(_selectedLanguage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.tr("Logged in successfully as")} ${AppLocalizations.tr(_selectedRole)}!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Prototype Static Banner - EXCLUSIVELY SHOWN ON LOGIN PAGE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: AppColors.infoLight,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '📌 ${AppLocalizations.tr('Static Prototype | Pune Region Demonstration')}',
                        style: const TextStyle(color: AppColors.info, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // App Logo / Title Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.tr('AgriTwin AI Pune'),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.tr('Digital Twin & AI Decision Support System for Pune Farmers'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Main Login Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.tr('Account Login'),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 16),

                        // Language Selection Dropdown
                        Text(
                          AppLocalizations.tr('Select Language'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedLanguage,
                          items: _languages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedLanguage = val);
                              AppLocalizations.setLanguage(val);
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.translate_rounded, color: AppColors.primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Mobile Number
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.tr('Registered Phone'),
                            prefixIcon: const Icon(Icons.phone_android_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.tr('Password'),
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Role Selection Dropdown
                        Text(AppLocalizations.tr('Select Role:'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(AppLocalizations.tr(role)))).toList(),
                          onChanged: (val) => setState(() => _selectedRole = val!),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              '${AppLocalizations.tr("Login as")} ${AppLocalizations.tr(_selectedRole)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Don't have an account -> Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.tr("Don't have an account? "), style: const TextStyle(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                    child: Text(
                      AppLocalizations.tr('Register'),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
