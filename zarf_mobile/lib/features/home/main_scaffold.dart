import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/user.dart';
import '../../data/services/api_service.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await ApiService.instance.getCurrentUser();
    if (mounted) setState(() => _user = user);
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

  @override
  Widget build(BuildContext context) {
    final isManager = _user?.role == 'manager' || _user?.role == 'admin';

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(),
        onDestinationSelected: _onItemTapped,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          if (isManager)
            const NavigationDestination(
              icon: Icon(Icons.fact_check_outlined),
              selectedIcon: Icon(Icons.fact_check),
              label: 'Approvals',
            ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
