import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/api_service.dart';
import '../../features/add_expense/add_expense_sheet.dart';
import '../../features/approval/approval_queue_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/expense_detail/expense_detail_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/main_scaffold.dart';
import '../../features/my_expenses/my_expenses_screen.dart';
import '../../features/receipt_scan/receipt_scan_screen.dart';
import '../../features/profile/profile_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) async {
      final isAuth = await ApiService.instance.isAuthenticated();
      final user = await ApiService.instance.getCurrentUser();
      final role = user?.role ?? 'employee';
      final path = state.matchedLocation;
      final isLogin = path == '/login';

      if (!isAuth && !isLogin) return '/login';
      if (isAuth && isLogin) {
        return role == 'manager' ? '/approval' : '/home';
      }

      if (isAuth && path == '/') {
        return role == 'manager' ? '/approval' : '/home';
      }

      if (isAuth &&
          path == '/approval' &&
          role != 'manager' &&
          role != 'admin') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/approval',
                builder: (_, __) => const ApprovalQueueScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-expenses',
                builder: (_, __) => const MyExpensesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add-expense',
        builder: (_, __) => const AddExpenseSheet(),
      ),
      GoRoute(
        path: '/receipt-scan',
        builder: (_, __) => const ReceiptScanScreen(),
      ),
      GoRoute(
        path: '/expense/:id',
        builder: (_, state) =>
            ExpenseDetailScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
}
