import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/user.dart';
import '../../data/services/api_service.dart';
import '../../data/services/update_service.dart';
import '../../l10n/app_localizations.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  User? _user;
  UpdateInfo? _updateInfo;
  bool _checkingUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _checkForUpdate();
  }

  Future<void> _loadUser() async {
    final user = await ApiService.instance.getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _checkForUpdate() async {
    if (_checkingUpdate) return;
    _checkingUpdate = true;
    final info = await UpdateService.instance.checkForUpdate();
    if (mounted && info != null) {
      setState(() => _updateInfo = info);
    }
    _checkingUpdate = false;
  }

  int _calculateSelectedIndex() {
    final currentIndex = widget.navigationShell.currentIndex;
    final isManager = _user?.role == 'manager' || _user?.role == 'admin';

    if (isManager) {
      return currentIndex;
    } else {
      if (currentIndex == 0) return 0;
      if (currentIndex == 2) return 1; // My Expenses (Branch 2)
      if (currentIndex == 3) return 2; // Profile (Branch 3)
      return 0;
    }
  }

  void _onItemTapped(int index) {
    final isManager = _user?.role == 'manager' || _user?.role == 'admin';

    if (isManager) {
      widget.navigationShell.goBranch(index);
    } else {
      switch (index) {
        case 0:
          widget.navigationShell.goBranch(0);
          break;
        case 1:
          widget.navigationShell.goBranch(2);
          break;
        case 2:
          widget.navigationShell.goBranch(3);
          break;
      }
    }
  }

  Widget _buildUpdateBanner() {
    final info = _updateInfo;
    if (info == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: const Color(0xFFE0F2FE),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.system_update_alt, color: Color(0xFF0369A1)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.updateAvailable(info.latestVersion),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.currentVersionUpdate(info.currentVersion),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => UpdateService.instance.openDownload(info),
                child: Text(l10n.update),
              ),
              IconButton(
                onPressed: () => setState(() => _updateInfo = null),
                icon: const Icon(Icons.close, size: 18),
                tooltip: l10n.dismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isManager = _user?.role == 'manager' || _user?.role == 'admin';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          _buildUpdateBanner(),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(),
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.home,
          ),
          if (isManager)
            NavigationDestination(
              icon: const Icon(Icons.fact_check_outlined),
              selectedIcon: const Icon(Icons.fact_check),
              label: l10n.approvals,
            ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.expenses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
