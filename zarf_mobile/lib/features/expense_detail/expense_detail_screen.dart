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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final e = await _repo.getExpenseById(widget.id);
      final user = await ApiService.instance.getCurrentUser();
      setState(() {
        expense = e;
        _user = user;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _hasError = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load expense details.')),
        );
      }
    }
  }

  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview(String status) async {
    final note = _commentController.text.trim();
    FocusScope.of(context).unfocus();
    try {
      await _repo.updateStatus(widget.id, status, note.isEmpty ? null : note);
      _commentController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense ${status == 'approved' ? 'approved' : 'rejected'} successfully'),
            backgroundColor: status == 'approved' ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
          ),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status.')),
        );
      }
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = const Color(0xFF22C55E);
        break;
      case 'rejected':
        color = const Color(0xFFEF4444);
        break;
      case 'pending':
      default:
        color = const Color(0xFFF59E0B);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(100)),
      child: Text(status.toUpperCase(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5)),
    );
  }

  void _viewReceipt(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: url,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white, size: 48),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = expense;
    if (_hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Expense Detail')),
        body: const Center(
            child: Text('Failed to load expense. Please try again.')),
      );
    }
    if (e == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canReview = (_user?.role == 'manager' || _user?.role == 'admin') &&
        e.status == 'pending';

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top hero card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  _buildStatusBadge(e.status),
                  const SizedBox(height: 16),
                  Text(
                    'AED ${e.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D9488)),
                  ),
                  const SizedBox(height: 4),
                  Text(e.category,
                      style: const TextStyle(
                          fontSize: 16, color: Color(0xFF64748B))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Details section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  _buildDetailRow('Category', e.category),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  _buildDetailRow('Payment Method', e.paymentMethod ?? 'N/A'),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  _buildDetailRow(
                      'Date', e.date.toIso8601String().split('T').first),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  _buildDetailRow(
                      'Base Amount',
                      e.amountBase != null
                          ? 'AED ${e.amountBase!.toStringAsFixed(2)}'
                          : 'N/A'),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  _buildDetailRow(
                      'VAT Amount',
                      e.vatApplicable
                          ? 'AED ${e.vatAmount.toStringAsFixed(2)}'
                          : 'N/A'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (e.vatApplicable)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF0D9488)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'VAT Included: AED ${e.vatAmount.toStringAsFixed(2)} at 5%',
                        style: const TextStyle(
                            color: Color(0xFF0D9488),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            if (e.notes != null && e.notes!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('NOTES',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 1.2)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(e.notes!,
                    style: const TextStyle(color: Color(0xFF0F172A))),
              ),
            ],

            if (e.receiptUrl != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => _viewReceipt(e.receiptUrl!),
                  child: const Text('View Receipt'),
                ),
              ),
            ],

            SizedBox(height: canReview ? 200 : 40),
          ],
        ),
      ),
      bottomSheet: canReview
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5))
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Add a comment (optional)',
                        filled: true,
                        fillColor: Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () => _submitReview('rejected'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFEF4444),
                                side: const BorderSide(
                                    color: Color(0xFFEF4444), width: 1.5),
                              ),
                              child: const Text('Reject'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () => _submitReview('approved'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D9488),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Approve'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
