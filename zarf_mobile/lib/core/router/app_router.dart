import 'package:go_router/go_router.dart';

import '../../data/services/api_service.dart';
import '../../features/add_expense/add_expense_sheet.dart';
import '../../features/approval/approval_queue_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/expense_detail/expense_detail_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/my_expenses/my_expenses_screen.dart';
import '../../features/receipt_scan/receipt_scan_screen.dart';

class AppRouter {
  static final router = GoRouter(
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
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(
          path: '/add-expense', builder: (_, __) => const AddExpenseSheet()),
      GoRoute(
          path: '/my-expenses', builder: (_, __) => const MyExpensesScreen()),
      GoRoute(
          path: '/approval', builder: (_, __) => const ApprovalQueueScreen()),
      GoRoute(
          path: '/receipt-scan', builder: (_, __) => const ReceiptScanScreen()),
      GoRoute(
        path: '/expense/:id',
        builder: (_, state) =>
            ExpenseDetailScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
}
