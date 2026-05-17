import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/expense.dart';
import '../../data/models/user.dart';
import '../../data/repositories/expense_repo.dart';
import '../../data/services/api_service.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final String id;
  const ExpenseDetailScreen({super.key, required this.id});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  final _repo = ExpenseRepo();
  Expense? expense;
  User? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final e = await _repo.getExpenseById(widget.id);
    final user = await ApiService.instance.getCurrentUser();
    setState(() {
      expense = e;
      _user = user;
    });
  }

  Future<void> _openApproveRejectSheet(String status) async {
    final controller = TextEditingController();
    final note = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(status == 'approved' ? 'Approve Expense' : 'Reject Expense',
                  textAlign: TextAlign.start),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration:
                    const InputDecoration(labelText: 'Comment (optional)'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(controller.text.trim()),
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        );
      },
    );

    await _repo.updateStatus(
        widget.id, status, note == null || note.isEmpty ? null : note);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final e = expense;
    if (e == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canReview = (_user?.role == 'manager' || _user?.role == 'admin') &&
        e.status == 'pending';

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Detail')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: [
            Text('Amount: ${e.amount} ${e.currency}',
                textAlign: TextAlign.start),
            if (e.amountBase != null)
              Text('Base Amount: ${e.amountBase}', textAlign: TextAlign.start),
            Text('Category: ${e.category}', textAlign: TextAlign.start),
            Text('Status: ${e.status}', textAlign: TextAlign.start),
            Text('Date: ${e.date.toIso8601String().split('T').first}',
                textAlign: TextAlign.start),
            if (e.notes != null && e.notes!.isNotEmpty)
              Text('Notes: ${e.notes}', textAlign: TextAlign.start),
            if (e.vatApplicable)
              Text('VAT: ${e.vatAmount}', textAlign: TextAlign.start),
            if (e.receiptUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CachedNetworkImage(imageUrl: e.receiptUrl!),
              ),
            if (canReview) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openApproveRejectSheet('approved'),
                      child: const Text('Approve'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openApproveRejectSheet('rejected'),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
