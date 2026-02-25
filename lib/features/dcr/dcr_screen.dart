import 'package:flutter/material.dart';
import 'package:sfa_ui_flutter/features/visits/visit_model.dart';
import 'package:sfa_ui_flutter/features/dcr/claim_model.dart';
import 'package:sfa_ui_flutter/features/dcr/claim_form.dart';
import 'package:sfa_ui_flutter/features/dcr/claim_store.dart';
import 'package:sfa_ui_flutter/features/visits/visit_store.dart';

class DcrScreen extends StatefulWidget {
  final List<Visit> completedVisits;
  final Map<String, ClaimStatus> visitClaimStatus; // visitId -> status

  const DcrScreen({Key? key, required this.completedVisits, this.visitClaimStatus = const {}}) : super(key: key);

  @override
  State<DcrScreen> createState() => _DcrScreenState();
}

class _DcrScreenState extends State<DcrScreen> {
  final Set<String> _selected = {};

  List<Visit> get _visits => widget.completedVisits;
  List<Visit> get _storeVisits => VisitStore().completedVisits;
  List<Visit> get _source => widget.completedVisits.isNotEmpty ? _visits : _storeVisits;

  void _toggleSelect(String id, {bool? value}) {
    setState(() {
      if (value == true) _selected.add(id);
      else _selected.remove(id);
    });
  }

  void _selectAll() {
    setState(() {
      _selected.clear();
      _selected.addAll(_source.map((v) => v.id));
    });
  }

  void _createClaim() {
    final selectedVisits = _source.where((v) => _selected.contains(v.id)).toList();
    if (selectedVisits.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClaimForm(
          salesPerson: 'Current User',
          visits: selectedVisits,
          onSaveDraft: (claim) {
            ClaimStore().addClaim(claim);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved')));
            Navigator.pop(context);
            setState(() {});
          },
          onSubmit: (claim) {
            claim.status = ClaimStatus.submitted;
            ClaimStore().addClaim(claim);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submitted')));
            Navigator.pop(context);
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Visit>>{};
    final source = widget.completedVisits.isNotEmpty ? _visits : _storeVisits;
    for (var v in source) {
      final key = '${v.date.year}-${v.date.month}-${v.date.day}';
      grouped.putIfAbsent(key, () => []).add(v);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Call Report (DCR)')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: _selectAll, child: const Text('Select All')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _createClaim, child: const Text('Create Claim')),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            ...grouped.entries.map((entry) {
              final dateParts = entry.key.split('-');
              final dateLabel = '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
              return ExpansionTile(
                title: Text(dateLabel),
                children: entry.value.map((v) {
                  final fromMap = widget.visitClaimStatus[v.id];
                  final fromStore = ClaimStore().isVisitInSubmittedClaim(v.id);
                  final status = fromMap != null ? fromMap : (fromStore ? ClaimStatus.submitted : ClaimStatus.notCreated);
                  final disabled = status == ClaimStatus.submitted || status == ClaimStatus.approved;
                  return ListTile(
                    leading: Checkbox(
                      value: _selected.contains(v.id),
                      onChanged: disabled ? null : (val) => _toggleSelect(v.id, value: val),
                    ),
                    title: Text(v.accountName.isEmpty ? v.visitType : v.accountName),
                    subtitle: Text('${v.time?.format(context) ?? 'Time N/A'} • ${v.notes ?? ''}'),
                    trailing: Text(status.toString().split('.').last),
                  );
                }).toList(),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
