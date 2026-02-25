import 'package:flutter/material.dart';

enum ProposalStatus { draft, submitted, pendingApproval, approved, sent }

class CreateProposalDialog extends StatefulWidget {
  const CreateProposalDialog({super.key});

  @override
  State<CreateProposalDialog> createState() => _CreateProposalDialogState();
}

class _CreateProposalDialogState extends State<CreateProposalDialog> {
  List<ProposalItem> items = [ProposalItem()];
  ProposalStatus _status = ProposalStatus.draft;

  void _addItem() {
    setState(() {
      items.add(ProposalItem());
    });
  }

  void _removeItem(int index) {
    if (items.length > 1) {
      setState(() {
        items.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = _status == ProposalStatus.draft;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Create Proposal"),
          if (_status != ProposalStatus.draft)
            Chip(
              label: Text(_status.name.toUpperCase().replaceAll("PENDINGAPPROVAL", "PENDING")),
              backgroundColor: Colors.blue.shade50,
              labelStyle: TextStyle(fontSize: 12, color: Colors.blue.shade900),
            ),
        ],
      ),
      content: SizedBox(
        width: 900,
        height: 600,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < items.length; i++)
                      IgnorePointer(
                        ignoring: !isEditable,
                        child: Opacity(
                          opacity: isEditable ? 1.0 : 0.7,
                          child: _buildItemRow(i, items[i]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isEditable)
              OutlinedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text("Add More Item"),
              ),
          ],
        ),
      ),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    switch (_status) {
      case ProposalStatus.draft:
        return [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Save as Draft"),
          ),
          ElevatedButton(
            onPressed: () => setState(() => _status = ProposalStatus.submitted),
            child: const Text("Submit"),
          ),
        ];
      case ProposalStatus.submitted:
        return [
          ElevatedButton(
            onPressed: () =>
                setState(() => _status = ProposalStatus.pendingApproval),
            child: const Text("Send to Approval"),
          ),
        ];
      case ProposalStatus.pendingApproval:
        return [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => setState(() => _status = ProposalStatus.approved),
            child: const Text("Approve (Manager)"),
          ),
        ];
      case ProposalStatus.approved:
        return [
          ElevatedButton.icon(
            icon: const Icon(Icons.send),
            onPressed: _showShareOptions,
            label: const Text("Send to Client"),
          ),
        ];
      case ProposalStatus.sent:
        return [
          const Text("Proposal Sent Successfully!",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ];
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Share Proposal via",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _shareOption(Icons.email, "Email", Colors.red),
                _shareOption(Icons.message, "WhatsApp", Colors.green),
                _shareOption(Icons.share, "Other", Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() => _status = ProposalStatus.sent);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withAlpha((0.1 * 255).round()),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildItemRow(int index, ProposalItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Type
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: item.type,
                decoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                items: ["Test", "Package"]
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (val) => setState(() => item.type = val),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            // Category
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: item.category,
                decoration: const InputDecoration(
                  labelText: "Cat.",
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                items: ["A", "B", "C", "D"]
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (val) => setState(() => item.category = val),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            // Name
            Expanded(
              flex: 4,
              child: TextFormField(
                initialValue: item.name,
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                style: const TextStyle(fontSize: 13),
                onChanged: (val) => item.name = val,
              ),
            ),
            const SizedBox(width: 8),
            // MRP
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: item.mrp,
                decoration: const InputDecoration(
                  labelText: "MRP",
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                style: const TextStyle(fontSize: 13),
                keyboardType: TextInputType.number,
                onChanged: (val) => item.mrp = val,
              ),
            ),
            const SizedBox(width: 8),
            // Offered
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: item.offeredPrice,
                decoration: const InputDecoration(
                  labelText: "Offer Price",
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                style: const TextStyle(fontSize: 13),
                keyboardType: TextInputType.number,
                onChanged: (val) => item.offeredPrice = val,
              ),
            ),
            const SizedBox(width: 8),
            // %
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: item.offeredPercentage,
                decoration: const InputDecoration(
                  labelText: "Offer %",
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                style: const TextStyle(fontSize: 13),
                keyboardType: TextInputType.number,
                onChanged: (val) => item.offeredPercentage = val,
              ),
            ),
            if (items.length > 1) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => _removeItem(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProposalItem {
  String? type;
  String? category;
  String name = "";
  String mrp = "";
  String offeredPrice = "";
  String offeredPercentage = "";
}