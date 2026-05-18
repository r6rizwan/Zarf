import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/categories.dart';
import '../../core/constants/currencies.dart';
import '../../core/constants/payment_methods.dart';
import '../../data/models/expense.dart';
import '../../data/repositories/expense_repo.dart';
import '../../data/services/receipt_ai_service.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _repo = ExpenseRepo();
  final _amount = TextEditingController();
  final _notes = TextEditingController();
  String _category = expenseCategories.first;
  String _currency = expenseCurrencies.first;
  String _paymentMethod = paymentMethods.first;
  DateTime _date = DateTime.now();
  bool _vatApplicable = false;
  num _vatAmount = 0;

  bool _aiCurrency = false;
  bool _aiDate = false;
  bool _aiNotes = false;
  bool _loading = false;

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final amount = num.tryParse(_amount.text) ?? 0;
      final dto = ExpenseCreateDto(
        amount: amount,
        currency: _currency,
        category: _category,
        notes: _notes.text,
        vatApplicable: _vatApplicable,
        vatAmount: _vatAmount,
        paymentMethod: _paymentMethod,
        date: _date,
      );
      await _repo.createExpense(dto);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save expense.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() => _date = picked);
  }

  Future<void> _toggleVat(bool value) async {
    setState(() => _vatApplicable = value);
    if (!value) {
      setState(() => _vatAmount = 0);
      return;
    }
    try {
      final amount = num.tryParse(_amount.text) ?? 0;
      final company = await _repo.getCompanyById('me');
      setState(() {
        _vatAmount = amount * (company.vatRate / 100);
      });
    } catch (e) {
      if (mounted) {
        setState(() => _vatApplicable = false); // Revert switch if failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch VAT info.')),
        );
      }
    }
  }

  Future<void> _scanReceipt() async {
    final parsed = await context.push<ParsedReceipt>('/receipt-scan');
    if (parsed == null) return;

    setState(() {
      if (parsed.amount != null) {
        _amount.text = parsed.amount!.toStringAsFixed(2);
      }
      if (parsed.currency != null &&
          expenseCurrencies.contains(parsed.currency!.toUpperCase())) {
        _currency = parsed.currency!.toUpperCase();
        _aiCurrency = true;
      }
      if (parsed.date != null) {
        _date = parsed.date!;
        _aiDate = true;
      }
      if (parsed.merchant != null && parsed.merchant!.trim().isNotEmpty) {
        _notes.text = parsed.merchant!.trim();
        _aiNotes = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  InputDecoration _decor(String label, {bool aiFilled = false}) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color:
                aiFilled ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: aiFilled ? const Color(0xFF0D9488) : const Color(0xFF0D9488),
            width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amountVal = num.tryParse(_amount.text) ?? 0;
    final canSubmit = amountVal > 0 && !_loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _scanReceipt,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Scan Receipt'),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                    color: const Color(0xFF64748B).withValues(alpha: 0.5)),
                prefixText: 'AED ',
                prefixStyle: const TextStyle(
                    color: Color(0xFF0D9488),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 24),
            const Text('DETAILS',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 1.2)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: _decor('Category'),
              items: expenseCategories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: _decor('Currency', aiFilled: _aiCurrency),
              items: expenseCurrencies
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _currency = v!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notes,
              decoration: _decor('Notes', aiFilled: _aiNotes),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: _decor('Date', aiFilled: _aiDate),
                child: Text(_date.toIso8601String().split('T').first),
              ),
            ),
            const SizedBox(height: 32),
            const Text('PAYMENT',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 1.2)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _paymentMethod,
              decoration: _decor('Payment Method'),
              items: paymentMethods
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('VAT (5%)',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                Switch(
                  value: _vatApplicable,
                  onChanged: _toggleVat,
                  activeThumbColor: const Color(0xFF22C55E),
                  // activeColor: const Color(0xFF0D9488),
                ),
              ],
            ),
            if (_vatApplicable)
              Text('VAT: AED ${_vatAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Color(0xFF0D9488),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Submit Expense',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
