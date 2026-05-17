import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/expense.dart';
import '../../data/repositories/expense_repo.dart';

class ApprovalQueueScreen extends StatefulWidget {
  const ApprovalQueueScreen({super.key});

  @override
  State<ApprovalQueueScreen> createState() => _ApprovalQueueScreenState();
}

class _ApprovalQueueScreenState extends State<ApprovalQueueScreen> {
  final _repo = ExpenseRepo();
  List<Expense> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await _repo.getExpenses(status: 'pending', page: 1, limit: 20);
    setState(() => _items = (res['data'] as List<Expense>));
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
            onTap: () => context.push('/expense/${e.id}'),
          );
        },
      ),
    );
  }
}
