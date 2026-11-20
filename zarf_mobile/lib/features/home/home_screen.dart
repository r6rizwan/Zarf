import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations_extensions.dart';
import '../../data/models/expense.dart';
import '../../data/models/user.dart';
import '../../data/repositories/expense_repo.dart';
import '../../data/services/api_service.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = ExpenseRepo();
  User? _user;
  List<Expense> _recent = const [];
  int _myMonthCount = 0;
  int _pendingApprovals = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final userFuture = ApiService.instance.getCurrentUser();
      final myExpensesFuture = _repo.getExpenses(page: 1, limit: 5);

      final results = await Future.wait([userFuture, myExpensesFuture]);
      final user = results[0] as User?;
      final myExpensesRes = results[1] as Map<String, dynamic>;
      final myExpenses = (myExpensesRes['data'] as List<Expense>);

      var monthCount = 0;
      final now = DateTime.now();
      for (final expense in myExpenses) {
        if (expense.date.year == now.year && expense.date.month == now.month) {
          monthCount++;
        }
      }

      if (!mounted) return;
      setState(() {
        _user = user;
        _recent = myExpenses;
        _myMonthCount = monthCount;
        _pendingApprovals = 0;
        _loading = false;
      });

      if (user?.role == 'manager' || user?.role == 'admin') {
        final pendingRes =
            await _repo.getExpenses(status: 'pending', page: 1, limit: 20);
        if (!mounted) return;
        setState(() {
          _pendingApprovals = pendingRes['total'] as int;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToLoadData),
          ),
        );
      }
    } finally {
      if (mounted && _loading) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget _buildHomeSkeleton() {
    Widget block({double h = 16, double? w}) => Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            block(h: 28, w: 220),
            const SizedBox(height: 10),
            block(h: 14, w: 140),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            block(h: 14, w: 160),
            const SizedBox(height: 12),
            for (int i = 0; i < 3; i++) ...[
              Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = AppTheme.success;
        break;
      case 'rejected':
        color = AppTheme.error;
        break;
      case 'pending':
      default:
        color = AppTheme.warning;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        l10n.statusName(status).toUpperCase(),
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.success;
      case 'rejected':
        return AppTheme.error;
      case 'pending':
      default:
        return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return _buildHomeSkeleton();
    }

    final isManager = _user?.role == 'manager' || _user?.role == 'admin';
    final firstName = _user?.name.split(' ').first ?? l10n.user;
    final formattedDate =
        DateFormat.yMMMMd(l10n.localeName).format(DateTime.now());

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Header
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D9488),
                  Color(0xFF0F766E)
                ], // teal-600 to teal-700
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.goodMorning(firstName),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 80), // Push down to overlap

                // Stat Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.go('/my-expenses'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4)),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.myExpensesThisMonth,
                                    style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                                const SizedBox(height: 8),
                                Text(
                                  '$_myMonthCount',
                                  style: const TextStyle(
                                      color: AppTheme.primaryTeal,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(l10n.totalCount,
                                    style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 12)),
                                const SizedBox(height: 12),
                                Text(l10n.tapToViewDetails,
                                    style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isManager) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.go('/approval'),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.pendingApprovals,
                                      style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$_pendingApprovals',
                                    style: const TextStyle(
                                        color: AppTheme.warning,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(l10n.awaitingReview,
                                      style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 12)),
                                  const SizedBox(height: 12),
                                  Text(l10n.tapToReview,
                                      style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Recent Expenses Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.recentExpenses,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textSecondary,
                            letterSpacing: 1.2),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/my-expenses'),
                        child: Text(l10n.viewAll,
                            style: const TextStyle(
                                color: AppTheme.primaryTeal,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // List
                Expanded(
                  child: _recent.isEmpty
                      ? Center(
                          child: Text(l10n.noRecentExpenses,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary)))
                      : ListView.separated(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 24),
                          itemCount: _recent.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final expense = _recent[i];
                            return GestureDetector(
                              onTap: () async {
                                await context.push('/expense/${expense.id}');
                                _load();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: const BorderDirectional(
                                    top:
                                        BorderSide(color: AppTheme.borderColor),
                                    end:
                                        BorderSide(color: AppTheme.borderColor),
                                    bottom:
                                        BorderSide(color: AppTheme.borderColor),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.02),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2)),
                                  ],
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Colored left border
                                      Container(
                                        width: 6,
                                        decoration: BoxDecoration(
                                          color:
                                              _getStatusColor(expense.status),
                                          borderRadius:
                                              const BorderRadiusDirectional
                                                  .only(
                                                  topStart: Radius.circular(12),
                                                  bottomStart:
                                                      Radius.circular(12)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      l10n.categoryName(
                                                          expense.category),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: AppTheme
                                                              .textPrimary)),
                                                  Text(
                                                    '${expense.currency} ${NumberFormat('#,##0.00', l10n.localeName).format(expense.amount)}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .primaryTeal),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  _buildStatusBadge(
                                                      expense.status),
                                                  Text(
                                                    l10n.formatDate(
                                                        expense.date),
                                                    style: const TextStyle(
                                                        color: AppTheme
                                                            .textSecondary,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/add-expense');
          _load();
        },
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}
