import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/expense.dart';
import '../../data/models/user.dart';
import '../../data/repositories/expense_repo.dart';
import '../../data/services/api_service.dart';

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
    final user = await ApiService.instance.getCurrentUser();
    final myExpensesRes = await _repo.getExpenses(page: 1, limit: 5);
    final myExpenses = (myExpensesRes['data'] as List<Expense>);

    var monthCount = 0;
    final now = DateTime.now();
    for (final expense in myExpenses) {
      if (expense.date.year == now.year && expense.date.month == now.month) {
        monthCount++;
      }
    }

    int pendingApprovals = 0;
    if (user?.role == 'manager') {
      final pendingRes =
          await _repo.getExpenses(status: 'pending', page: 1, limit: 20);
      pendingApprovals = pendingRes['total'] as int;
    }

    if (!mounted) return;
    setState(() {
      _user = user;
      _recent = myExpenses;
      _myMonthCount = monthCount;
      _pendingApprovals = pendingApprovals;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isManager = _user?.role == 'manager';

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${_user?.name ?? 'User'}',
                textAlign: TextAlign.start),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('My Expenses This Month',
                              textAlign: TextAlign.start),
                          const SizedBox(height: 6),
                          Text('$_myMonthCount', textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isManager) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pending Approvals',
                                textAlign: TextAlign.start),
                            const SizedBox(height: 6),
                            Text('$_pendingApprovals',
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            const Text('Recent Expenses', textAlign: TextAlign.start),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _recent.length,
                itemBuilder: (_, i) {
                  final expense = _recent[i];
                  return ListTile(
                    title: Text(
                        '${expense.category} - ${expense.amount} ${expense.currency}',
                        textAlign: TextAlign.start),
                    subtitle: Text(expense.status, textAlign: TextAlign.start),
                    onTap: () => context.push('/expense/${expense.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-expense'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
