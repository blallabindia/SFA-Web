import 'package:flutter/material.dart';

class AddPlannedVisitDialog extends StatefulWidget {
  const AddPlannedVisitDialog({super.key});

  @override
  State<AddPlannedVisitDialog> createState() =>
      _AddPlannedVisitDialogState();
}

class _AddPlannedVisitDialogState
    extends State<AddPlannedVisitDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String? _visitType;
  String? _linkedOpportunity;
  String _assignedTo = "Self";

  @override
  void dispose() {
    _accountController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _objectiveController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Planned Visit"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Account
                TextFormField(
                  controller: _accountController,
                  decoration: const InputDecoration(
                    labelText: "Account / Customer",
                    hintText: "Search & Select Account",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please select an account"
                      : null,
                ),
                const SizedBox(height: 16),

                // Visit Type
                DropdownButtonFormField<String>(
                  initialValue: _visitType,
                  decoration: const InputDecoration(
                    labelText: "Visit Type",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: [
                    "Sales Visit",
                    "Service",
                    "Collection",
                    "Courtesy",
                    "Complaint"
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _visitType = val),
                  validator: (value) =>
                      value == null ? "Please select visit type" : null,
                ),
                const SizedBox(height: 16),

                // Date & Time Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Required"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        onTap: _pickTime,
                        decoration: const InputDecoration(
                          labelText: "Time",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Required"
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Objective
                TextFormField(
                  controller: _objectiveController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Objective / Agenda",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter objective"
                      : null,
                ),
                const SizedBox(height: 16),

                // Assigned To
                DropdownButtonFormField<String>(
                  initialValue: _assignedTo,
                  decoration: const InputDecoration(
                    labelText: "Assigned To",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: ["Self", "ASM - Raj", "RM - Karan"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _assignedTo = val!),
                ),
                const SizedBox(height: 16),

                // Link Opportunity
                DropdownButtonFormField<String>(
                  initialValue: _linkedOpportunity,
                  decoration: const InputDecoration(
                    labelText: "Link to Opportunity (Optional)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                  items: ["Opp - Apollo Hospital", "Opp - Dr. Sharma"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _linkedOpportunity = val),
                ),
                const SizedBox(height: 16),

                // Remarks
                TextFormField(
                  controller: _remarksController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Remarks (Optional)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text("Save Visit"),
        ),
      ],
    );
  }
}
