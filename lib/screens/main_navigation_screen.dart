import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/voice_assistant_modal.dart';
import 'home/home_screen.dart';
import 'produce/produce_screen.dart';
import 'buyers/buyers_screen.dart';
import 'transactions/transactions_screen.dart';
import 'profile/profile_screen.dart';
import 'logistics/logistics_screen.dart';
import 'admin/admin_screen.dart';

/// Role-aware navigation shell hosting role-specific dashboards
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = MockData.activeUserRole;

    // 1. ADMIN ROLE DEDICATED SCREEN
    if (role == 'Admin') {
      return const AdminScreen();
    }

    // 2. BUYER ROLE DEDICATED SCREEN & NAVIGATION
    if (role == 'Buyer') {
      final buyerScreens = [
        const BuyersScreen(),
        const TransactionsScreen(),
        const ProfileScreen(),
      ];

      return Scaffold(
        body: IndexedStack(
          index: _currentIndex >= buyerScreens.length ? 0 : _currentIndex,
          children: buyerScreens,
        ),
          // Voice Assistant hidden for Buyer role
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex >= buyerScreens.length ? 0 : _currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon: const Icon(Icons.storefront_rounded),
              label: AppLocalizations.tr('Buyers'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: AppLocalizations.tr('Transactions'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: AppLocalizations.tr('Profile'),
            ),
          ],
        ),
      );
    }

    // 3. TRANSPORTATION AGENCY DEDICATED SCREEN & NAVIGATION
    if (role == 'Transportation Agency') {
      final transporterScreens = [
        const LogisticsScreen(),
        const TransactionsScreen(),
        const ProfileScreen(),
      ];

      return Scaffold(
        body: IndexedStack(
          index: _currentIndex >= transporterScreens.length ? 0 : _currentIndex,
          children: transporterScreens,
        ),
// Voice Assistant hidden for Transportation Agency role
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex >= transporterScreens.length ? 0 : _currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.local_shipping_outlined),
              selectedIcon: const Icon(Icons.local_shipping_rounded),
              label: AppLocalizations.tr('Logistics & Transport'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: AppLocalizations.tr('Transactions'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: AppLocalizations.tr('Profile'),
            ),
          ],
        ),
      );
    }

    // 4. FARMER ROLE DEFAULT 5-TAB SUITE
    final farmerScreens = [
      HomeScreen(onNavigateTab: _onDestinationSelected),
      const ProduceScreen(),
      const BuyersScreen(),
      const TransactionsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex >= farmerScreens.length ? 0 : _currentIndex,
        children: farmerScreens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => VoiceAssistantModal.show(context),
        backgroundColor: AppColors.primary,
        tooltip: AppLocalizations.tr('AgriTwin AI Voice Assistant'),
        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex >= farmerScreens.length ? 0 : _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: AppLocalizations.tr('Home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2_rounded),
            label: AppLocalizations.tr('Produce'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront_rounded),
            label: AppLocalizations.tr('Buyers'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: AppLocalizations.tr('Transactions'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: AppLocalizations.tr('Profile'),
          ),
        ],
      ),
    );
  }
}
