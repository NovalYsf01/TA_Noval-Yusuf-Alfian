import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../screens/home/home_screen.dart';
import '../screens/pelayanan/pelayanan_screen.dart';
import '../screens/emergency/emergency_screen.dart';
import '../screens/profile/profile_screen.dart';

/// Main Navigation – Bottom Navigation Bar 4 tab
///
/// Tab: Beranda | Pelayanan | Darurat | Profil
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    PelayananScreen(),
    EmergencyScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          _navItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: AppStrings.navBeranda,
          ),
          _navItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment_rounded,
            label: AppStrings.navPelayanan,
          ),
          _navItem(
            icon: Icons.emergency_outlined,
            activeIcon: Icons.emergency_rounded,
            label: AppStrings.navDarurat,
            activeColor: AppColors.danger,
          ),
          _navItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: AppStrings.navProfil,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    Color? activeColor,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: (activeColor ?? AppColors.primary).withAlpha(20),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(activeIcon, color: activeColor ?? AppColors.primary),
      ),
      label: label,
      tooltip: label,
    );
  }
}
