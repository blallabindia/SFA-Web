import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'visit_execution_model.dart';

class CheckOutSection extends StatefulWidget {
  final VisitExecutionModel visit;
  final Function(
    String outcome,
    String notes,
    String nextAction,
    DateTime? nextActionDate,
    List<String> attachments,
  ) onCompleteVisit;

  const CheckOutSection({
    super.key,
    required this.visit,
    required this.onCompleteVisit,
  });

  @override
  State<CheckOutSection> createState() => _CheckOutSectionState();
}

class _CheckOutSectionState extends State<CheckOutSection> {
  final _formKey = GlobalKey<FormState>();
  
  String? _outcome;
  final TextEditingController _notesController = TextEditingController();
  String? _nextAction;
  DateTime? _nextActionDate;
  final TextEditingController _dateController = TextEditingController();
  List<String> _attachments = [];

  final List<String> _outcomes = ["Positive", "Neutral", "Negative", "Not Met"];
  final List<String> _nextActions = [
    "Follow-up",
    "Create Opportunity",
    "Price Request",
    "Onboarding Request",
    "None"
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _nextActionDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _attachments.addAll(result.files.map((f) => f.name).toList());
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onCompleteVisit(
        _outcome!,
        _notesController.text,
        _nextAction!,
        _nextActionDate,
        _attachments,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "End Visit (Check-out)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Outcome
          DropdownButtonFormField<String>(
            initialValue: _outcome,
            decoration: const InputDecoration(
              labelText: "Visit Outcome",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.assessment),
            ),
            items: _outcomes
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _outcome = val),
            validator: (val) => val == null ? "Required" : null,
          ),
          const SizedBox(height: 16),

          // Notes
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Discussion Notes",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),

          // Next Action
          DropdownButtonFormField<String>(
            initialValue: _nextAction,
            decoration: const InputDecoration(
              labelText: "Next Action Type",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.next_plan),
            ),
            items: _nextActions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              setState(() {
                _nextAction = val;
                if (val != "Follow-up") {
                  _nextActionDate = null;
                  _dateController.clear();
                }
              });
            },
            validator: (val) => val == null ? "Required" : null,
          ),
          const SizedBox(height: 16),

          // Conditional Date Picker
          if (_nextAction == "Follow-up")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: "Next Action Due Date",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (val) =>
                    (val == null || val.isEmpty) ? "Required for Follow-up" : null,
              ),
            ),

          // Attachments
          OutlinedButton.icon(
            onPressed: _pickFiles,
            icon: const Icon(Icons.attach_file),
            label: const Text("Attach Photos / Documents"),
          ),
          if (_attachments.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _attachments
                  .map((file) => Chip(
                        label: Text(file),
                        onDeleted: () {
                          setState(() {
                            _attachments.remove(file);
                          });
                        },
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 24),

          // Complete Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check_circle),
              label: const Text("Complete Visit"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}