import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/expense.dart';
import '../../data/repositories/expense_repo.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _pollTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      _load();
    });
  }

  Future<void> _load() async {
    final res = await _repo.getExpenses(status: 'pending', page: 1, limit: 20);
    if (!mounted) return;
    setState(() => _items = (res['data'] as List<Expense>));
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
    return Scaffold(
      appBar: AppBar(title: const Text('Approval Queue')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final e = _items[i];
          return ListTile(
            title: Text(
                '${e.userName ?? 'Employee'} • ${e.amount} ${e.currency}',
                textAlign: TextAlign.start),
            subtitle: Text(
                '${e.category} • ${e.date.toIso8601String().split('T').first}',
                textAlign: TextAlign.start),
            onTap: () async {
              await context.push('/expense/${e.id}');
              _load();
            },
          );
        },
      ),
    );
  }
}
