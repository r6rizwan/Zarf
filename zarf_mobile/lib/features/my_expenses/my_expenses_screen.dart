import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/expense.dart';
import '../../data/repositories/expense_repo.dart';

class MyExpensesScreen extends StatefulWidget {
  const MyExpensesScreen({super.key});

  @override
  State<MyExpensesScreen> createState() => _MyExpensesScreenState();
}

class _MyExpensesScreenState extends State<MyExpensesScreen>
    with WidgetsBindingObserver {
  final _repo = ExpenseRepo();
  final _items = <Expense>[];
  final _scroll = ScrollController();
  Timer? _pollTimer;
  int _page = 1;
  int _totalPages = 1;
  bool _loading = false;
  String _status = '';
  String _sortBy = 'date';
  bool _sortAsc = false;

  static const Map<String, String> _sortOptions = {
    'date': 'Date',
    'amount': 'Amount',
    'status': 'Status',
    'category': 'Category',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load(reset: true);
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 100 &&
          !_loading &&
          _page < _totalPages) {
        _load();
      }
    });
    _pollTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      _load(reset: true);
    });
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final nextPage = reset ? 1 : _page + 1;
      final res = await _repo.getExpenses(
        status: _status,
        page: nextPage,
        limit: 20,
        sortBy: _sortBy,
        sortOrder: _sortAsc ? 'asc' : 'desc',
      );
      if (!mounted) return;
      setState(() {
        _page = res['page'];
        _totalPages = res['totalPages'];
        if (reset) _items.clear();
        _items.addAll((res['data'] as List<Expense>));
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to load expenses. Please check your connection.')),
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
      _load(reset: true);
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    super.dispose();
  }

  Widget _buildStatusBadge(String status) {
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
        status.toUpperCase(),
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
    return Scaffold(
      appBar: AppBar(title: const Text('My Expenses')),
      body: RefreshIndicator(
        onRefresh: () => _load(reset: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  for (final item in const [
                    '',
                    'pending',
                    'approved',
                    'rejected'
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _status = item);
                          _load(reset: true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _status == item
                                ? AppTheme.primaryTeal
                                : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: _status == item
                                    ? AppTheme.primaryTeal
                                    : AppTheme.borderColor),
                          ),
                          child: Text(
                            item.isEmpty
                                ? 'All'
                                : item[0].toUpperCase() + item.substring(1),
                            style: TextStyle(
                              color: _status == item
                                  ? Colors.white
                                  : AppTheme.primaryTeal,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text('Sort by:',
                      style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _sortBy,
                    items: _sortOptions.entries
                        .map((entry) => DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sortBy = value);
                      _load(reset: true);
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                        _sortAsc ? Icons.arrow_upward : Icons.arrow_downward),
                    color: AppTheme.primaryTeal,
                    onPressed: () {
                      setState(() => _sortAsc = !_sortAsc);
                      _load(reset: true);
                    },
                  ),
                  if (_status.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() => _status = '');
                        _load(reset: true);
                      },
                      child: const Text('Clear filter'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _loading && _items.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long,
                                  size: 80,
                                  color: AppTheme.primaryTeal
                                      .withValues(alpha: 0.3)),
                              const SizedBox(height: 16),
                              Text(
                                _status.isEmpty
                                    ? 'No expenses yet'
                                    : 'No expenses match this filter',
                                style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          controller: _scroll,
                          padding: const EdgeInsets.all(20),
                          itemCount: _items.length + (_loading ? 1 : 0),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            if (i >= _items.length) {
                              return const Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator()));
                            }
                            final expense = _items[i];
                            return GestureDetector(
                              onTap: () async {
                                await context.push('/expense/${expense.id}');
                                _load(reset: true);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: const Border(
                                    top:
                                        BorderSide(color: AppTheme.borderColor),
                                    right:
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
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12)),
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
                                                  Text(expense.category,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: AppTheme
                                                              .textPrimary)),
                                                  Text(
                                                    '${expense.currency} ${NumberFormat('#,##0.00').format(expense.amount)}',
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
                                                    expense.date
                                                        .toIso8601String()
                                                        .split('T')
                                                        .first,
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
    );
  }
}
