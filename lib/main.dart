import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AgriTwinApp());
}

/// Root Application Widget for AgriTwin AI Pune Prototype
class AgriTwinApp extends StatelessWidget {
  const AgriTwinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocalizations.languageNotifier,
      builder: (context, activeLang, child) {
        return MaterialApp(
          title: 'AgriTwin AI Pune',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
          builder: (context, child) {
            // Constrain width to a phone‑size on larger displays
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
