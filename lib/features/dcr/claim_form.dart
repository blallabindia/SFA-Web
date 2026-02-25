import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sfa_ui_flutter/features/dcr/claim_model.dart';
import 'package:sfa_ui_flutter/features/visits/visit_model.dart';

class ClaimForm extends StatefulWidget {
  final String salesPerson;
  final List<Visit> visits;
  final Claim? initial;
  final void Function(Claim claim) onSaveDraft;
  final void Function(Claim claim) onSubmit;

  const ClaimForm({
    Key? key,
    required this.salesPerson,
    required this.visits,
    this.initial,
    required this.onSaveDraft,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ClaimForm> createState() => _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  late Claim _claim;

  @override
  void initState() {
    super.initState();
    _claim = widget.initial ?? Claim(salesPerson: widget.salesPerson, visitIds: widget.visits.map((v) => v.id).toList(), expenses: []);
  }

  void _addExpense() {
    setState(() => _claim.expenses = List.from(_claim.expenses)..add(ExpenseLine(expenseType: 'Travel', amount: 0.0)));
  }

  void _removeExpense(String id) {
    setState(() => _claim.expenses = List.from(_claim.expenses)..removeWhere((e) => e.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Expense Claim')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sales Person: ${_claim.salesPerson}'),
            const SizedBox(height: 8),
            Text('Visit Reference(s):'),
            Wrap(
              spacing: 8,
              children: widget.visits.map((v) => Chip(label: Text('${v.accountName} (${v.date.day}/${v.date.month})'))).toList(),
            ),
            const SizedBox(height: 12),
            const Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._claim.expenses.map((e) => Card(
                  key: ValueKey(e.id),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: e.expenseType,
                            decoration: const InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            ),
                            onChanged: (v) => setState(() => e.expenseType = v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: e.amount.toStringAsFixed(2),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            ),
                            onChanged: (v) => setState(() => e.amount = double.tryParse(v) ?? 0.0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: e.description,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            ),
                            onChanged: (v) => setState(() => e.description = v),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_file, color: e.receiptPath != null ? Colors.blue : Colors.grey),
                          tooltip: e.receiptPath ?? 'Attach Receipt',
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() {
                                e.receiptPath = result.files.single.name;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeExpense(e.id),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(onPressed: _addExpense, icon: const Icon(Icons.add), label: const Text('Add Expense')),
                const SizedBox(width: 12),
                Text('Total: ₹ ${_claim.totalAmount.toStringAsFixed(2)}')
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => widget.onSaveDraft(_claim), child: const Text('Save Draft')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => widget.onSubmit(_claim), child: const Text('Submit')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
