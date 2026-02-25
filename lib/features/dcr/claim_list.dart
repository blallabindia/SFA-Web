import 'package:flutter/material.dart';
import 'claim_store.dart';
import 'claim_model.dart';

class ClaimListScreen extends StatefulWidget {
  const ClaimListScreen({Key? key}) : super(key: key);

  @override
  State<ClaimListScreen> createState() => _ClaimListScreenState();
}

class _ClaimListScreenState extends State<ClaimListScreen> {
  @override
  Widget build(BuildContext context) {
    final claims = ClaimStore().all;
    return Scaffold(
      appBar: AppBar(title: const Text('Claims')),
      body: ListView.builder(
        itemCount: claims.length,
        itemBuilder: (context, i) {
          final c = claims[i];
          return ListTile(
            title: Text('${c.salesPerson} — ₹ ${c.totalAmount.toStringAsFixed(2)}'),
            subtitle: Text('Visits: ${c.visitIds.join(', ')} • Status: ${c.status.toString().split('.').last}'),
            isThreeLine: true,
            trailing: PopupMenuButton<String>(
              onSelected: (action) async {
                if (action == 'approve') {
                  ClaimStore().setStatus(c.id, ClaimStatus.approved);
                } else if (action == 'reject') {
                  final remarks = await showDialog<String>(context: context, builder: (_) => _remarksDialog());
                  if (remarks != null) ClaimStore().setStatus(c.id, ClaimStatus.rejected, remarks: remarks);
                }
                setState(() {});
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'approve', child: Text('Approve')),
                const PopupMenuItem(value: 'reject', child: Text('Reject')),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _remarksDialog() {
    final ctl = TextEditingController();
    return AlertDialog(
      title: const Text('Manager Remarks'),
      content: TextField(controller: ctl, decoration: const InputDecoration(hintText: 'Enter remarks')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(context, ctl.text.trim()), child: const Text('Submit')),
      ],
    );
  }
}
