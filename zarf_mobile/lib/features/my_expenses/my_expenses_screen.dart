import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/expense.dart';
import '../../data/repositories/expense_repo.dart';

class MyExpensesScreen extends StatefulWidget {
  const MyExpensesScreen({super.key});

  @override
  State<MyExpensesScreen> createState() => _MyExpensesScreenState();
}

class _MyExpensesScreenState extends State<MyExpensesScreen> {
  final _repo = ExpenseRepo();
  final _items = <Expense>[];
  final _scroll = ScrollController();
  int _page = 1;
  int _totalPages = 1;
  bool _loading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 100 && !_loading && _page < _totalPages) {
        _load();
      }
    });
  }

  Future<void> _load({bool reset = false}) async {
    setState(() => _loading = true);
    final nextPage = reset ? 1 : _page + 1;
    final res = await _repo.getExpenses(status: _status, page: nextPage, limit: 20);
    setState(() {
      _page = res['page'];
      _totalPages = res['totalPages'];
      if (reset) _items.clear();
      _items.addAll((res['data'] as List<Expense>));
      _loading = false;
    });
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
              child: Row(
                children: [
                  for (final item in const ['', 'pending', 'approved', 'rejected'])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: ChoiceChip(
                        label: Text(item.isEmpty ? 'All' : item),
                        selected: _status == item,
                        onSelected: (_) {
                          setState(() => _status = item);
                          _load(reset: true);
                        },
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                itemCount: _items.length + (_loading ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i >= _items.length) return const Center(child: CircularProgressIndicator());
                  final expense = _items[i];
                  return ListTile(
                    title: Text('${expense.category} - ${expense.amount} ${expense.currency}', textAlign: TextAlign.start),
                    subtitle: Text(expense.status, textAlign: TextAlign.start),
                    onTap: () => context.push('/expense/${expense.id}'),
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
