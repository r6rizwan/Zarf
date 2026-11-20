import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations_extensions.dart';
import '../../data/models/expense.dart';
import '../../data/repositories/expense_repo.dart';
import '../../l10n/app_localizations.dart';

class ApprovalQueueScreen extends StatefulWidget {
  const ApprovalQueueScreen({super.key});

  @override
  State<ApprovalQueueScreen> createState() => _ApprovalQueueScreenState();
}

class _ApprovalQueueScreenState extends State<ApprovalQueueScreen>
    with WidgetsBindingObserver {
  final _repo = ExpenseRepo();
  Timer? _pollTimer;
  List<Expense> _items = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _pollTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      _load();
    });
  }

  Future<void> _load() async {
    if (_loading) return;
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final res = await _repo.getExpenses(
          status: 'pending', page: 1, limit: 10, useCache: false);
      if (!mounted) return;
      setState(() => _items = (res['data'] as List<Expense>));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToLoadApprovals),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(l10n.pendingApprovals),
            if (_items.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppTheme.primaryTeal,
                    borderRadius: BorderRadius.circular(100)),
                child: Text('${_items.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ]
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading && _items.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 120,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                ],
              )
            : _items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 120,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 80,
                                  color: AppTheme.primaryTeal
                                      .withValues(alpha: 0.3)),
                              const SizedBox(height: 16),
                              Text(l10n.allCaughtUp,
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 16)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _load,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryTeal,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(l10n.refresh),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final e = _items[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderColor),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Top row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.userName ?? l10n.employee,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.textPrimary)),
                                Text(
                                    '${e.currency} ${NumberFormat('#,##0.00', l10n.localeName).format(e.amount)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.primaryTeal)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Middle row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppTheme.borderColor),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(l10n.categoryName(e.category),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(l10n.formatDate(e.date),
                                    style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Bottom row
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: () async {
                                  await context.push('/expense/${e.id}');
                                  _load();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primaryTeal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(l10n.review,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
