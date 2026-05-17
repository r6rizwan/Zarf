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

  bool _aiAmount = false;
  bool _aiCurrency = false;
  bool _aiDate = false;
  bool _aiNotes = false;

  Future<void> _submit() async {
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
    final amount = num.tryParse(_amount.text) ?? 0;
    final company = await _repo.getCompanyById('me');
    setState(() {
      _vatAmount = amount * (company.vatRate / 100);
    });
  }

  Future<void> _scanReceipt() async {
    final parsed = await context.push<ParsedReceipt>('/receipt-scan');
    if (parsed == null) return;

    setState(() {
      if (parsed.amount != null) {
        _amount.text = parsed.amount!.toStringAsFixed(2);
        _aiAmount = true;
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

  InputDecoration _decor(String label, {bool aiFilled = false}) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: aiFilled ? Colors.teal : Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: aiFilled ? Colors.teal : Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _scanReceipt,
                child: const Text('Scan Receipt'),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: _decor('Amount', aiFilled: _aiAmount),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: _decor('Category'),
              items: expenseCategories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: _decor('Currency', aiFilled: _aiCurrency),
              items: expenseCurrencies
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _currency = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _paymentMethod,
              decoration: _decor('Payment Method'),
              items: paymentMethods
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              decoration: _decor('Notes', aiFilled: _aiNotes),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: _decor('Date', aiFilled: _aiDate),
                child: Text(_date.toIso8601String().split('T').first,
                    textAlign: TextAlign.start),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _vatApplicable,
              onChanged: _toggleVat,
              title: const Text('VAT Applicable', textAlign: TextAlign.start),
            ),
            Text('VAT Amount: $_vatAmount', textAlign: TextAlign.start),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _submit, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
