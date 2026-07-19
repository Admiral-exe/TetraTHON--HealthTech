import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/triage_screen.dart';
import 'screens/records_screen.dart';
import 'screens/family_screen.dart';

void main() {
  runApp(const HealthTechApp());
}

class HealthTechApp extends StatelessWidget {
  const HealthTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.background,
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  void _navigate(int tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _body(),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F4EE),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: "Home", idx: 0, current: _tab, onTap: _navigate),
                _NavItem(icon: Icons.mic_outlined, activeIcon: Icons.mic_rounded, label: "Check-in", idx: 1, current: _tab, onTap: _navigate),
                _NavItem(icon: Icons.medical_services_outlined, activeIcon: Icons.medical_services_rounded, label: "Symptoms", idx: 2, current: _tab, onTap: _navigate),
                _NavItem(icon: Icons.people_outline_rounded, activeIcon: Icons.people_rounded, label: "Family", idx: 3, current: _tab, onTap: _navigate),
                _NavItem(icon: Icons.insert_drive_file_outlined, activeIcon: Icons.insert_drive_file_rounded, label: "Records", idx: 4, current: _tab, onTap: _navigate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return switch (_tab) {
      0 => SingleChildScrollView(physics: const BouncingScrollPhysics(), child: HomeScreen(onNavigate: _navigate)),
      1 => const CheckInScreen(),
      2 => SingleChildScrollView(physics: const BouncingScrollPhysics(), child: const TriageScreen()),
      3 => SingleChildScrollView(physics: const BouncingScrollPhysics(), child: const FamilyScreen()),
      4 => SingleChildScrollView(physics: const BouncingScrollPhysics(), child: const RecordsScreen()),
      _ => SingleChildScrollView(physics: const BouncingScrollPhysics(), child: HomeScreen(onNavigate: _navigate)),
    };
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int idx;
  final int current;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = idx == current;
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: active ? AppColors.secondary : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(
                active ? activeIcon : icon,
                size: 22,
                color: active ? AppColors.primary : AppColors.mutedFg,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: body(
                size: 11,
                weight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.primary : AppColors.mutedFg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
